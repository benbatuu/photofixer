# Firestore Schema — Photo Fixer

Project: `photofixer-4bc1f`

## Collections

### `users/{uid}`

| Field | Type | Notes |
|-------|------|--------|
| createdAt | timestamp | server |
| lastActiveAt | timestamp | server |
| platform | string | ios / android |
| locale | string | device locale |
| credits | number | **client-write forbidden** (except create with freeCredits) |
| onboardingCompleted | bool | preference |
| notificationsEnabled | bool | preference |

### `users/{uid}/purchases/{purchaseId}`

| Field | Type |
|-------|------|
| platform | string |
| productId | string |
| transactionId | string (unique) |
| verificationStatus | string |
| creditsGranted | number |
| createdAt | timestamp |

Client **cannot** create/update. Admin SDK / Cloud Functions only.

### `users/{uid}/credit_ledger/{ledgerId}`

| Field | Type |
|-------|------|
| type | free \| purchase \| usage \| refund \| adjustment |
| amount | number |
| source | string |
| referenceId | string? |
| createdAt | timestamp |

Client **cannot** write.

### `users/{uid}/jobs/{jobId}`

| Field | Type |
|-------|------|
| type | enhance \| unblur \| relight \| restore |
| status | queued \| reserved \| uploading \| processing \| completed \| failed |
| inputSize | number? |
| failureReason | string? |
| createdAt | timestamp |
| completedAt | timestamp? |

Client may **read** own jobs. Writes via Functions.

### `users/{uid}/devices/{tokenHash}`

FCM device tokens (Epic 11).

### `config/app`

| Field | Example |
|-------|---------|
| freeCredits | 3 |
| maxImageSizeMb | 12 |
| maintenanceMode | false |
| minAppVersionAndroid | 1.0.0 |
| minAppVersionIos | 1.0.0 |

Client **read-only**. Writes via Console / Admin.
