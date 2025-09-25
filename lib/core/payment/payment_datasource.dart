/// Abstract interface for payment data sources (CamPay, NouPai, etc.)
abstract class PaymentDataSource {
  /// Initiate a payment transaction
  Future<Map<String, dynamic>> initiatePayment({
    required String phoneNumber,
    required double amount,
    required String description,
    required String externalReference,
  });

  /// Check payment status
  Future<Map<String, dynamic>> checkPaymentStatus(String transactionId);

  /// Validate webhook/callback data
  Future<bool> validateWebhook(Map<String, dynamic> webhookData);
}