# Photo Fixer API

Small Node (Hono) backend for AI photo processing.

```
Flutter
  → Bearer Firebase ID token
  → POST /v1/process
  → reserve credit (Firestore)
  → store input on Cloudflare R2
  → Gemini image edit
  → store output on R2
  → return short-lived result URL
```

Gemini API key never leaves this server.

## Endpoints

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/health` | no | Liveness |
| POST | `/v1/process` | Firebase Bearer | Enhance / unblur / relight / restore |

### `POST /v1/process`

```json
{
  "operation": "enhance",
  "imageBase64": "<base64 or data-url>",
  "mimeType": "image/jpeg",
  "jobId": "optional-client-id"
}
```

Success:

```json
{
  "jobId": "...",
  "operation": "enhance",
  "resultUrl": "https://...",
  "expiresInSeconds": 900,
  "creditsCharged": 1,
  "latencyMs": 4200
}
```

Error (always this shape):

```json
{
  "code": "INSUFFICIENT_CREDITS",
  "message": "Not enough credits",
  "retryable": false
}
```

## Setup

### 1. Cloudflare R2

1. Create bucket `photofixer-tmp`
2. Create R2 API token (Object Read & Write)
3. Copy Account ID, Access Key ID, Secret Access Key into `.env`

### 2. Firebase service account

1. Firebase Console → Project settings → Service accounts  
2. Generate new private key → save as `api/service-account.json`  
3. **Do not commit** this file

### 3. Gemini

1. Create key at https://aistudio.google.com/apikey  
2. Put in `.env` as `GEMINI_API_KEY`

### 4. Run locally

```bash
cd api
cp .env.example .env
# fill .env + add service-account.json
npm install
npm run dev
```

Health check: http://localhost:8787/health

## Deploy (later)

Any Node host works: Railway, Fly.io, Render, VPS.

Set the same env vars in the host. Point Flutter `API_BASE_URL` at the public HTTPS URL.

## Notes

- Credits are reserved before Gemini; failures refund via ledger.
- In-memory rate limit is per process (fine for single instance MVP).
- Prefer signed R2 URLs (`R2_PUBLIC_BASE_URL` empty) so objects stay private.
- Schedule TTL cleanup on the R2 bucket (e.g. delete `users/*/tmp/**` after 1 day).
