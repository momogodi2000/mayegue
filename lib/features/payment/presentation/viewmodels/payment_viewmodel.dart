import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/process_payment_usecase.dart';

/// Payment ViewModel
class PaymentViewModel extends ChangeNotifier {
  final ProcessPaymentUseCase processPaymentUseCase;

  PaymentViewModel(this.processPaymentUseCase);

  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<void> processPayment({
    required String userId,
    required double amount,
    required String method,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    final params = ProcessPaymentParams(
      userId: userId,
      amount: amount,
      method: method,
      phoneNumber: phoneNumber,
    );

    final result = await processPaymentUseCase(params);

    result.fold(
      (failure) {
        _error = failure.message;
      },
      (payment) {
        _successMessage = 'Payment initiated successfully. Transaction ID: ${payment.transactionId}';
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
