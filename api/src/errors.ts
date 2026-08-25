export class ApiError extends Error {
  constructor(
    public readonly code: string,
    message: string,
    public readonly status: number = 400,
    public readonly retryable: boolean = false,
  ) {
    super(message);
    this.name = 'ApiError';
  }

  toJSON() {
    return {
      code: this.code,
      message: this.message,
      retryable: this.retryable,
    };
  }
}

export const ErrorCodes = {
  UNAUTHENTICATED: 'UNAUTHENTICATED',
  INVALID_IMAGE: 'INVALID_IMAGE',
  IMAGE_TOO_LARGE: 'IMAGE_TOO_LARGE',
  INSUFFICIENT_CREDITS: 'INSUFFICIENT_CREDITS',
  GEMINI_TIMEOUT: 'GEMINI_TIMEOUT',
  GEMINI_BLOCKED: 'GEMINI_BLOCKED',
  GEMINI_ERROR: 'GEMINI_ERROR',
  RATE_LIMITED: 'RATE_LIMITED',
  INTERNAL_ERROR: 'INTERNAL_ERROR',
  INVALID_REQUEST: 'INVALID_REQUEST',
} as const;
