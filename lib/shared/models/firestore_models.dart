/// Photo processing job stored at `users/{uid}/jobs/{jobId}`.
enum JobStatus { queued, reserved, uploading, processing, completed, failed }

class PhotoJob {
  const PhotoJob({
    required this.id,
    required this.type,
    required this.status,
    this.inputSize,
    this.failureReason,
    this.createdAt,
    this.completedAt,
  });

  final String id;
  final String type; // enhance | unblur | relight | restore
  final JobStatus status;
  final int? inputSize;
  final String? failureReason;
  final DateTime? createdAt;
  final DateTime? completedAt;

  Map<String, Object?> toMap() {
    return {
      'type': type,
      'status': status.name,
      'inputSize': inputSize,
      'failureReason': failureReason,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

/// Credit ledger entry at `users/{uid}/credit_ledger/{ledgerId}`.
enum CreditLedgerType { free, purchase, usage, refund, adjustment }

class CreditLedgerEntry {
  const CreditLedgerEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.source,
    this.referenceId,
  });

  final String id;
  final CreditLedgerType type;
  final int amount;
  final String source;
  final String? referenceId;

  Map<String, Object?> toMap() {
    return {
      'type': type.name,
      'amount': amount,
      'source': source,
      'referenceId': referenceId,
    };
  }
}

/// Purchase record at `users/{uid}/purchases/{purchaseId}`.
enum PurchaseVerificationStatus {
  pending,
  verified,
  alreadyProcessed,
  failed,
}

class PurchaseRecord {
  const PurchaseRecord({
    required this.id,
    required this.platform,
    required this.productId,
    required this.transactionId,
    required this.verificationStatus,
    required this.creditsGranted,
  });

  final String id;
  final String platform; // ios | android
  final String productId;
  final String transactionId;
  final PurchaseVerificationStatus verificationStatus;
  final int creditsGranted;

  Map<String, Object?> toMap() {
    return {
      'platform': platform,
      'productId': productId,
      'transactionId': transactionId,
      'verificationStatus': verificationStatus.name,
      'creditsGranted': creditsGranted,
    };
  }
}
