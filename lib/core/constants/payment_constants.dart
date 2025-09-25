/// Payment and subscription constants
class PaymentConstants {
  // CamPay
  static const String campayBaseUrl = 'https://api.campay.net';
  static const String campayApiKey = 'your_campay_api_key';
  static const String campaySecret = 'your_campay_secret';

  // NouPai
  static const String noupaiBaseUrl = 'https://api.noupai.com';
  static const String noupaiApiKey = 'your_noupai_api_key';

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
