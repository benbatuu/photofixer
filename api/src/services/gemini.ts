import { ApiError, ErrorCodes } from '../errors.js';
import { env } from '../config/env.js';
import { promptFor } from '../prompts/templates.js';
import type { PhotoOperation } from '../types.js';

type GeminiPart =
  | { text: string }
  | { inlineData: { mimeType: string; data: string } };

interface GeminiResponse {
  candidates?: Array<{
    content?: { parts?: Array<{ text?: string; inlineData?: { mimeType?: string; data?: string } }> };
    finishReason?: string;
  }>;
  error?: { message?: string; status?: string };
}

export async function editImageWithGemini(params: {
  operation: PhotoOperation;
  imageBase64: string;
  mimeType: string;
}): Promise<{ imageBase64: string; mimeType: string; model: string }> {
  const model = env.geminiModel;
  const apiKey = env.geminiApiKey();
  const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;

  const parts: GeminiPart[] = [
    { text: promptFor(params.operation) },
    {
      inlineData: {
        mimeType: params.mimeType,
        data: params.imageBase64,
      },
    },
  ];

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 90_000);

  try {
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      signal: controller.signal,
      body: JSON.stringify({
        contents: [{ role: 'user', parts }],
        generationConfig: {
          responseModalities: ['TEXT', 'IMAGE'],
        },
      }),
    });

    const json = (await res.json()) as GeminiResponse;

    if (!res.ok) {
      const msg = json.error?.message || `Gemini HTTP ${res.status}`;
      if (res.status === 429) {
        throw new ApiError(ErrorCodes.RATE_LIMITED, msg, 429, true);
      }
      throw new ApiError(ErrorCodes.GEMINI_ERROR, msg, 502, true);
    }

    const candidate = json.candidates?.[0];
    const finish = candidate?.finishReason;
    if (finish === 'SAFETY' || finish === 'BLOCKLIST' || finish === 'PROHIBITED_CONTENT') {
      throw new ApiError(
        ErrorCodes.GEMINI_BLOCKED,
        'This image can\'t be processed.',
        422,
        false,
      );
    }

    const imagePart = candidate?.content?.parts?.find((p) => p.inlineData?.data);
    if (!imagePart?.inlineData?.data) {
      throw new ApiError(
        ErrorCodes.GEMINI_ERROR,
        'Gemini returned no image',
        502,
        true,
      );
    }

    return {
      imageBase64: imagePart.inlineData.data,
      mimeType: imagePart.inlineData.mimeType || 'image/jpeg',
      model,
    };
  } catch (err) {
    if (err instanceof ApiError) throw err;
    if (err instanceof Error && err.name === 'AbortError') {
      throw new ApiError(ErrorCodes.GEMINI_TIMEOUT, 'Gemini timed out', 504, true);
    }
    throw new ApiError(
      ErrorCodes.GEMINI_ERROR,
      err instanceof Error ? err.message : 'Gemini failed',
      502,
      true,
    );
  } finally {
    clearTimeout(timeout);
  }
}
