import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/payment_constants.dart';

/// NouPai payment datasource (fallback)
abstract class NouPaiDataSource {
  Future<Map<String, dynamic>> initiatePayment({
    required String phoneNumber,
    required double amount,
    required String description,
    required String externalReference,
  });

  Future<Map<String, dynamic>> checkPaymentStatus(String transactionId);

  Future<bool> validateWebhook(Map<String, dynamic> webhookData);
}

/// NouPai implementation
class NouPaiDataSourceImpl implements NouPaiDataSource {
  final DioClient dioClient;

  NouPaiDataSourceImpl(this.dioClient);

  @override
  Future<Map<String, dynamic>> initiatePayment({
    required String phoneNumber,
    required double amount,
    required String description,
    required String externalReference,
  }) async {
    try {
      final response = await dioClient.dio.post(
        PaymentConstants.noupaiBaseUrl,
        data: {
          'amount': amount.toString(),
          'currency': 'XAF',
          'phone': phoneNumber,
          'description': description,
          'reference': externalReference,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${PaymentConstants.noupaiApiKey}',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data;
    } catch (e) {
      throw Exception('NouPai payment initiation failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> checkPaymentStatus(String transactionId) async {
    try {
      final response = await dioClient.dio.get(
        '${PaymentConstants.noupaiBaseUrl}/$transactionId/status',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${PaymentConstants.noupaiApiKey}',
          },
        ),
      );

      return response.data;
    } catch (e) {
      throw Exception('NouPai status check failed: $e');
    }
  }

  @override
  Future<bool> validateWebhook(Map<String, dynamic> webhookData) async {
    // Validate webhook signature (implement based on NouPai documentation)
    return webhookData.containsKey('transaction_id') &&
           webhookData.containsKey('status');
  }
}
