import 'package:flutter/material.dart';

/// Payment Form Widget
class PaymentForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentForm({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations de paiement',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Payment Method Selection
          Text(
            'Méthode de paiement',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodSelector(),
          const SizedBox(height: 24),

          // Phone Number Field
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Numéro de téléphone',
              hintText: '+237 6XX XXX XXX',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: _validatePhoneNumber,
          ),
          const SizedBox(height: 16),

          // Payment Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Le paiement sera traité de manière sécurisée. Vous recevrez une confirmation par SMS.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        _buildPaymentMethodOption(
          value: 'campay',
          title: 'CamPay',
          subtitle: 'Mobile Money (MTN, Orange)',
          icon: Icons.account_balance_wallet,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodOption(
          value: 'noupai',
          title: 'NouPai',
          subtitle: 'Alternative Mobile Money',
          icon: Icons.payment,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Builder(
      builder: (context) {
        final isSelected = selectedMethod == value;

        return InkWell(
          onTap: () => onMethodChanged(value),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Theme.of(context).primaryColor : null,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<String>(
                  value: value,
                  groupValue: selectedMethod,
                  onChanged: (value) => onMethodChanged(value!),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    // Cameroon phone number validation
    final phoneRegex = RegExp(r'^\+?237\s?6[0-9]{8}$|^6[0-9]{8}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Numéro de téléphone invalide (format: +237 6XX XXX XXX)';
    }

    return null;
  }
}