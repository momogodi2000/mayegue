import 'package:flutter/material.dart';

/// Payment Method Selector Widget
class PaymentMethodSelector extends StatefulWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Méthode de paiement',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildMethodOption(
          value: 'campay',
          title: 'CamPay',
          subtitle: 'Paiement Mobile Money (MTN, Orange)',
          icon: Icons.account_balance_wallet,
          logo: 'assets/images/campay_logo.png', // TODO: Add logo asset
        ),
        const SizedBox(height: 12),
        _buildMethodOption(
          value: 'noupai',
          title: 'NouPai',
          subtitle: 'Alternative Mobile Money',
          icon: Icons.payment,
          logo: 'assets/images/noupai_logo.png', // TODO: Add logo asset
        ),
        const SizedBox(height: 12),
        _buildMethodOption(
          value: 'card',
          title: 'Carte bancaire',
          subtitle: 'Visa, MasterCard',
          icon: Icons.credit_card,
          logo: null,
        ),
      ],
    );
  }

  Widget _buildMethodOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    String? logo,
  }) {
    final isSelected = widget.selectedMethod == value;

    return InkWell(
      onTap: () => widget.onMethodChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            // Logo or Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: logo != null
                  ? Image.asset(logo, fit: BoxFit.contain)
                  : Icon(
                      icon,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                    ),
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
                  const SizedBox(height: 4),
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
              groupValue: widget.selectedMethod,
              onChanged: (value) => widget.onMethodChanged(value!),
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}