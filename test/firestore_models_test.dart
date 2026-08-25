import 'package:flutter_test/flutter_test.dart';
import 'package:photofixer/shared/models/firestore_models.dart';

void main() {
  test('job status serializes by name', () {
    const job = PhotoJob(
      id: 'j1',
      type: 'enhance',
      status: JobStatus.processing,
      inputSize: 1024,
    );
    expect(job.toMap()['status'], 'processing');
    expect(job.toMap()['type'], 'enhance');
  });

  test('ledger and purchase maps include required fields', () {
    const ledger = CreditLedgerEntry(
      id: 'l1',
      type: CreditLedgerType.free,
      amount: 3,
      source: 'signup',
    );
    expect(ledger.toMap()['type'], 'free');

    const purchase = PurchaseRecord(
      id: 'p1',
      platform: 'ios',
      productId: 'photo_fixer_10_credits',
      transactionId: 'tx-1',
      verificationStatus: PurchaseVerificationStatus.verified,
      creditsGranted: 10,
    );
    expect(purchase.toMap()['creditsGranted'], 10);
  });
}
