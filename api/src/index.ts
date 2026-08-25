import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { HTTPException } from 'hono/http-exception';
import { serve } from '@hono/node-server';
import { ApiError, ErrorCodes } from './errors.js';
import { env } from './config/env.js';
import { processRoutes } from './routes/process.js';

const app = new Hono();

app.use(
  '*',
  cors({
    origin: '*',
    allowHeaders: ['Authorization', 'Content-Type'],
    allowMethods: ['GET', 'POST', 'OPTIONS'],
  }),
);

app.get('/health', (c) =>
  c.json({
    ok: true,
    service: 'photofixer-api',
    env: env.nodeEnv,
  }),
);

app.route('/', processRoutes);

app.onError((err, c) => {
  if (err instanceof ApiError) {
    return c.json(err.toJSON(), err.status as 400);
  }
  if (err instanceof HTTPException) {
    return c.json(
      {
        code: ErrorCodes.INVALID_REQUEST,
        message: err.message,
        retryable: false,
      },
      err.status,
    );
  }

  console.error('[api]', err);
  return c.json(
    {
      code: ErrorCodes.INTERNAL_ERROR,
      message: 'Something went wrong',
      retryable: true,
    },
    500,
  );
});

app.notFound((c) =>
  c.json(
    {
      code: ErrorCodes.INVALID_REQUEST,
      message: 'Not found',
      retryable: false,
    },
    404,
  ),
);

const port = env.port;
console.log(`[photofixer-api] listening on http://localhost:${port}`);
serve({ fetch: app.fetch, port });

export default app;
