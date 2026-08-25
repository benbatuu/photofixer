import 'dotenv/config';

function required(name: string): string {
  const value = process.env[name]?.trim();
  if (!value) {
    throw new Error(`Missing required env: ${name}`);
  }
  return value;
}

function optional(name: string, fallback = ''): string {
  return process.env[name]?.trim() || fallback;
}

export const env = {
  port: Number(process.env.PORT || 8787),
  nodeEnv: optional('NODE_ENV', 'development'),
  geminiApiKey: () => required('GEMINI_API_KEY'),
  geminiModel: optional(
    'GEMINI_IMAGE_MODEL',
    'gemini-2.0-flash-preview-image-generation',
  ),
  firebaseProjectId: optional('FIREBASE_PROJECT_ID', 'photofixer-4bc1f'),
  r2: {
    accountId: () => required('R2_ACCOUNT_ID'),
    accessKeyId: () => required('R2_ACCESS_KEY_ID'),
    secretAccessKey: () => required('R2_SECRET_ACCESS_KEY'),
    bucket: optional('R2_BUCKET', 'photofixer-tmp'),
    publicBaseUrl: optional('R2_PUBLIC_BASE_URL'),
    signedUrlTtlSeconds: Number(process.env.R2_SIGNED_URL_TTL_SECONDS || 900),
  },
  maxImageBytes: Number(process.env.MAX_IMAGE_BYTES || 12 * 1024 * 1024),
  anonRateLimitPerHour: Number(process.env.ANON_RATE_LIMIT_PER_HOUR || 5),
};
