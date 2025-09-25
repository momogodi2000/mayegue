import '../config/environment_config.dart';

/// Payment and subscription constants
class PaymentConstants {
  // CamPay
  static String get campayBaseUrl => EnvironmentConfig.campayBaseUrl;
  static String get campayApiKey => EnvironmentConfig.campayApiKey;
  static String get campaySecret => EnvironmentConfig.campaySecret;

  // NouPai
  static String get noupaiBaseUrl => EnvironmentConfig.noupaiBaseUrl;
  static String get noupaiApiKey => EnvironmentConfig.noupaiApiKey;

  // Subscription Plans
  static const Map<String, dynamic> freemiumPlan = {
    'id': 'freemium',
    'name': 'Freemium',
    'price': 0.0,
    'currency': 'FCFA',
    'features': [
      '5 lessons per month',
      'Basic games',
      'Community access',
    ],
  };

  static const Map<String, dynamic> premiumMonthlyPlan = {
    'id': 'premium_monthly',
    'name': 'Premium Mensuel',
    'price': 2500.0,
    'currency': 'FCFA',
    'features': [
      'Unlimited lessons',
      'AI Assistant',
      'All games',
      'Advanced community',
      'Certificates',
    ],
  };

  static const Map<String, dynamic> premiumAnnualPlan = {
    'id': 'premium_annual',
    'name': 'Premium Annuel',
    'price': 25000.0,
    'currency': 'FCFA',
    'features': [
      'All monthly features',
      '2 months free',
      'Priority support',
    ],
  };

  static const Map<String, dynamic> teacherPlan = {
    'id': 'teacher',
    'name': 'Enseignant',
    'price': 15000.0,
    'currency': 'FCFA',
    'features': [
      'All premium features',
      'Create lessons',
      'Student management',
      'Analytics dashboard',
    ],
  };

  // Payment Status
  static const String paymentPending = 'pending';
  static const String paymentCompleted = 'completed';
  static const String paymentFailed = 'failed';
  static const String paymentCancelled = 'cancelled';
}
