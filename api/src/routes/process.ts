import { randomUUID } from 'node:crypto';
import { Hono } from 'hono';
import { ApiError, ErrorCodes } from '../errors.js';
import { env } from '../config/env.js';
import {
  firebaseAuth,
  type AuthVariables,
} from '../middleware/firebaseAuth.js';
import {
  assertRateLimit,
  completeJob,
  releaseCredit,
  reserveCredit,
} from '../services/credits.js';
import { editImageWithGemini } from '../services/gemini.js';
import { getObjectUrl, putTempObject, tempKey } from '../services/r2.js';
import { processPhotoSchema } from '../types.js';

function stripDataUrl(raw: string): { base64: string; mimeType?: string } {
  const match = /^data:(image\/[a-zA-Z0-9+.-]+);base64,(.+)$/.exec(raw);
  if (match) {
    return { mimeType: match[1], base64: match[2]! };
  }
  return { base64: raw.replace(/\s/g, '') };
}

export const processRoutes = new Hono<{ Variables: AuthVariables }>();

processRoutes.post('/v1/process', firebaseAuth, async (c) => {
  const uid = c.get('uid');
  assertRateLimit(uid, env.anonRateLimitPerHour);

  const body = await c.req.json().catch(() => {
    throw new ApiError(ErrorCodes.INVALID_REQUEST, 'Invalid JSON body', 400);
  });

  const parsed = processPhotoSchema.safeParse(body);
  if (!parsed.success) {
    throw new ApiError(
      ErrorCodes.INVALID_REQUEST,
      parsed.error.issues[0]?.message ?? 'Invalid request',
      400,
    );
  }

  const stripped = stripDataUrl(parsed.data.imageBase64);
  const mimeType = stripped.mimeType ?? parsed.data.mimeType;
  const imageBase64 = stripped.base64;

  let bytes: Buffer;
  try {
    bytes = Buffer.from(imageBase64, 'base64');
  } catch {
    throw new ApiError(ErrorCodes.INVALID_IMAGE, 'Invalid base64 image', 400);
  }

  if (bytes.byteLength === 0) {
    throw new ApiError(ErrorCodes.INVALID_IMAGE, 'Empty image', 400);
  }
  if (bytes.byteLength > env.maxImageBytes) {
    throw new ApiError(
      ErrorCodes.IMAGE_TOO_LARGE,
      `Image exceeds ${Math.floor(env.maxImageBytes / (1024 * 1024))} MB`,
      413,
    );
  }

  const jobId = parsed.data.jobId ?? randomUUID();
  const started = Date.now();
  let reserved = false;

  try {
    await reserveCredit(uid, jobId);
    reserved = true;

    const inputKey = tempKey(uid, jobId, 'input');
    await putTempObject({
      key: inputKey,
      body: bytes,
      contentType: mimeType,
    });

    const gemini = await editImageWithGemini({
      operation: parsed.data.operation,
      imageBase64,
      mimeType,
    });

    const outBytes = Buffer.from(gemini.imageBase64, 'base64');
    const outputKey = tempKey(uid, jobId, 'output');
    await putTempObject({
      key: outputKey,
      body: outBytes,
      contentType: gemini.mimeType,
    });

    const resultUrl = await getObjectUrl(outputKey);
    const latencyMs = Date.now() - started;

    await completeJob({
      uid,
      jobId,
      operation: parsed.data.operation,
      inputSize: bytes.byteLength,
      model: gemini.model,
      latencyMs,
      resultKey: outputKey,
    });

    return c.json({
      jobId,
      operation: parsed.data.operation,
      resultUrl,
      expiresInSeconds: env.r2.signedUrlTtlSeconds,
      creditsCharged: 1,
      latencyMs,
    });
  } catch (err) {
    if (reserved) {
      const reason =
        err instanceof ApiError ? err.code : ErrorCodes.INTERNAL_ERROR;
      await releaseCredit(uid, jobId, reason).catch(() => undefined);
    }
    throw err;
  }
});
