import { z } from 'zod';

export const processPhotoSchema = z.object({
  operation: z.enum(['enhance', 'unblur', 'relight', 'restore']),
  // Base64 without data-url prefix preferred; data URLs accepted and stripped.
  imageBase64: z.string().min(32),
  mimeType: z
    .enum(['image/jpeg', 'image/png', 'image/webp'])
    .default('image/jpeg'),
  jobId: z.string().min(8).optional(),
});

export type ProcessPhotoInput = z.infer<typeof processPhotoSchema>;

export type PhotoOperation = ProcessPhotoInput['operation'];
