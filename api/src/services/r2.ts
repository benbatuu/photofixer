import {
  DeleteObjectCommand,
  GetObjectCommand,
  PutObjectCommand,
  S3Client,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { env } from '../config/env.js';

let client: S3Client | undefined;

function r2Client(): S3Client {
  if (client) return client;
  const accountId = env.r2.accountId();
  client = new S3Client({
    region: 'auto',
    endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
    credentials: {
      accessKeyId: env.r2.accessKeyId(),
      secretAccessKey: env.r2.secretAccessKey(),
    },
  });
  return client;
}

export async function putTempObject(params: {
  key: string;
  body: Buffer;
  contentType: string;
}): Promise<void> {
  await r2Client().send(
    new PutObjectCommand({
      Bucket: env.r2.bucket,
      Key: params.key,
      Body: params.body,
      ContentType: params.contentType,
    }),
  );
}

export async function getObjectUrl(key: string): Promise<string> {
  if (env.r2.publicBaseUrl) {
    return `${env.r2.publicBaseUrl.replace(/\/$/, '')}/${key}`;
  }

  return getSignedUrl(
    r2Client(),
    new GetObjectCommand({
      Bucket: env.r2.bucket,
      Key: key,
    }),
    { expiresIn: env.r2.signedUrlTtlSeconds },
  );
}

export async function deleteObject(key: string): Promise<void> {
  await r2Client().send(
    new DeleteObjectCommand({
      Bucket: env.r2.bucket,
      Key: key,
    }),
  );
}

export function tempKey(uid: string, jobId: string, kind: 'input' | 'output') {
  return `users/${uid}/tmp/${jobId}/${kind}.jpg`;
}
