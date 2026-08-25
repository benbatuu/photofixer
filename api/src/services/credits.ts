import { FieldValue } from 'firebase-admin/firestore';
import { ApiError, ErrorCodes } from '../errors.js';
import { adminDb } from './firebase.js';

export async function reserveCredit(uid: string, jobId: string): Promise<void> {
  const db = adminDb();
  const userRef = db.collection('users').doc(uid);
  const jobRef = userRef.collection('jobs').doc(jobId);
  const ledgerRef = userRef.collection('credit_ledger').doc();

  await db.runTransaction(async (tx) => {
    const userSnap = await tx.get(userRef);
    if (!userSnap.exists) {
      throw new ApiError(ErrorCodes.UNAUTHENTICATED, 'User profile missing', 401);
    }

    const credits = Number(userSnap.get('credits') ?? 0);
    if (credits < 1) {
      throw new ApiError(
        ErrorCodes.INSUFFICIENT_CREDITS,
        'Not enough credits',
        402,
        false,
      );
    }

    tx.update(userRef, {
      credits: credits - 1,
      lastActiveAt: FieldValue.serverTimestamp(),
    });

    tx.set(ledgerRef, {
      type: 'usage',
      amount: -1,
      source: 'processPhoto',
      referenceId: jobId,
      createdAt: FieldValue.serverTimestamp(),
    });

    tx.set(jobRef, {
      type: 'pending',
      status: 'reserved',
      createdAt: FieldValue.serverTimestamp(),
    }, { merge: true });
  });
}

export async function releaseCredit(uid: string, jobId: string, reason: string): Promise<void> {
  const db = adminDb();
  const userRef = db.collection('users').doc(uid);
  const jobRef = userRef.collection('jobs').doc(jobId);
  const ledgerRef = userRef.collection('credit_ledger').doc();

  await db.runTransaction(async (tx) => {
    const userSnap = await tx.get(userRef);
    if (!userSnap.exists) return;

    const credits = Number(userSnap.get('credits') ?? 0);
    tx.update(userRef, {
      credits: credits + 1,
      lastActiveAt: FieldValue.serverTimestamp(),
    });

    tx.set(ledgerRef, {
      type: 'refund',
      amount: 1,
      source: 'processPhoto_failure',
      referenceId: jobId,
      createdAt: FieldValue.serverTimestamp(),
    });

    tx.set(
      jobRef,
      {
        status: 'failed',
        failureReason: reason,
        completedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
  });
}

export async function completeJob(params: {
  uid: string;
  jobId: string;
  operation: string;
  inputSize: number;
  model: string;
  latencyMs: number;
  resultKey: string;
}): Promise<void> {
  const jobRef = adminDb()
    .collection('users')
    .doc(params.uid)
    .collection('jobs')
    .doc(params.jobId);

  await jobRef.set(
    {
      type: params.operation,
      status: 'completed',
      inputSize: params.inputSize,
      model: params.model,
      latencyMs: params.latencyMs,
      resultKey: params.resultKey,
      completedAt: FieldValue.serverTimestamp(),
    },
    { merge: true },
  );
}

/** Simple in-memory rate limit (single instance). Replace with Redis later if needed. */
const hits = new Map<string, number[]>();

export function assertRateLimit(uid: string, limitPerHour: number): void {
  const now = Date.now();
  const windowMs = 60 * 60 * 1000;
  const recent = (hits.get(uid) ?? []).filter((t) => now - t < windowMs);
  if (recent.length >= limitPerHour) {
    throw new ApiError(
      ErrorCodes.RATE_LIMITED,
      'Too many requests. Try again later.',
      429,
      true,
    );
  }
  recent.push(now);
  hits.set(uid, recent);
}
