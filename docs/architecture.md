# Architecture — Photo Fixer MVP

```
Flutter app
  ├─ Firebase Auth (anonymous)
  ├─ Cloud Firestore (users, credits, jobs, purchases)
  └─ HTTPS → Photo Fixer API (api/)
                ├─ verify Firebase ID token
                ├─ reserve / release credits
                ├─ Cloudflare R2 (tmp images)
                └─ Gemini image edit
```

## Why not Firebase Storage / Functions?

Spark plan + cost control. R2 holds temporary images; a small Node API owns secrets and Gemini calls.

## Temporary files

R2 keys: `users/{uid}/tmp/{jobId}/input.jpg|output.jpg`  
Prefer private bucket + signed URLs. Configure R2 object lifecycle to expire `tmp/` after ~24h.
