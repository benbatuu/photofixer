import { initializeApp, cert, getApps, type App } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';
import { readFileSync } from 'node:fs';
import { env } from '../config/env.js';

let app: App | undefined;

export function getFirebaseApp(): App {
  if (app) return app;
  if (getApps().length > 0) {
    app = getApps()[0]!;
    return app;
  }

  const credPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  if (credPath) {
    const json = JSON.parse(readFileSync(credPath, 'utf8')) as object;
    app = initializeApp({
      credential: cert(json as Parameters<typeof cert>[0]),
      projectId: env.firebaseProjectId,
    });
  } else {
    // Application Default Credentials (Cloud Run / local gcloud)
    app = initializeApp({ projectId: env.firebaseProjectId });
  }
  return app;
}

export function adminAuth() {
  return getAuth(getFirebaseApp());
}

export function adminDb() {
  return getFirestore(getFirebaseApp());
}
