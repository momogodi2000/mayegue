import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/payment_constants.dart';
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

/// CamPay implementation
class CamPayDataSourceImpl implements PaymentDataSource {
  final DioClient dioClient;

  CamPayDataSourceImpl(this.dioClient);

  @override
  Future<Map<String, dynamic>> initiatePayment({
    required String phoneNumber,
    required double amount,
    required String description,
    required String externalReference,
  }) async {
    try {
      final response = await dioClient.dio.post(
        PaymentConstants.campayBaseUrl,
        data: {
          'amount': amount.toString(),
          'currency': 'XAF',
          'phone': phoneNumber,
          'description': description,
          'external_reference': externalReference,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${PaymentConstants.campayApiKey}',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data;
    } catch (e) {
      throw Exception('CamPay payment initiation failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> checkPaymentStatus(String transactionId) async {
    try {
      final response = await dioClient.dio.get(
        '${PaymentConstants.campayBaseUrl}/$transactionId/status',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${PaymentConstants.campayApiKey}',
          },
        ),
      );

      return response.data;
    } catch (e) {
      throw Exception('CamPay status check failed: $e');
    }
  }

  @override
  Future<bool> validateWebhook(Map<String, dynamic> webhookData) async {
    // Validate webhook signature (implement based on CamPay documentation)
    // For now, basic validation
    return webhookData.containsKey('transaction_id') &&
           webhookData.containsKey('status');
  }
}
