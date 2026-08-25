import { createMiddleware } from 'hono/factory';
import { ApiError, ErrorCodes } from '../errors.js';
import { adminAuth } from '../services/firebase.js';

export type AuthVariables = {
  uid: string;
};

export const firebaseAuth = createMiddleware<{ Variables: AuthVariables }>(
  async (c, next) => {
    const header = c.req.header('Authorization');
    if (!header?.startsWith('Bearer ')) {
      throw new ApiError(
        ErrorCodes.UNAUTHENTICATED,
        'Missing Bearer token',
        401,
      );
    }

    const token = header.slice('Bearer '.length).trim();
    try {
      const decoded = await adminAuth().verifyIdToken(token);
      c.set('uid', decoded.uid);
      await next();
    } catch {
      throw new ApiError(
        ErrorCodes.UNAUTHENTICATED,
        'Invalid or expired token',
        401,
      );
    }
  },
);
