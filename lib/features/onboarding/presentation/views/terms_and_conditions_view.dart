import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../shared/widgets/custom_button.dart';

/// Terms and Conditions page that users must accept before proceeding
class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key});

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  bool _acceptedTerms = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onAcceptTerms() {
    if (_acceptedTerms) {
      // Navigate to landing page after accepting terms
      context.go(Routes.landing);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez accepter les termes et conditions pour continuer'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termes et Conditions'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: 0.1,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Welcome message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.language,
                          size: 48,
                          color: Colors.green,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Bienvenue dans Mayegue',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Préservons ensemble le patrimoine linguistique du Cameroun',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Terms content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Termes et Conditions d\'Utilisation',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              _buildSection(
                                '1. Acceptation des Conditions',
                                'En utilisant l\'application Mayegue, vous acceptez d\'être lié par ces termes et conditions. Si vous n\'acceptez pas ces termes, veuillez ne pas utiliser cette application.',
                              ),

                              _buildSection(
                                '2. Mission Culturelle',
                                'Mayegue est dédiée à la préservation et à l\'enseignement des langues traditionnelles camerounaises : Ewondo, Duala, Bafang, Fulfulde, Bassa, et Bamum. Nous nous engageons à respecter et honorer ces cultures.',
                              ),

                              _buildSection(
                                '3. Utilisation de l\'Application',
                                '• Respectez les autres utilisateurs et les cultures représentées\n• Ne publiez pas de contenu offensant ou inapproprié\n• Utilisez l\'application à des fins éducatives et culturelles\n• Respectez les droits de propriété intellectuelle',
                              ),

                              _buildSection(
                                '4. Données Personnelles',
                                'Nous collectons et utilisons vos données conformément à notre politique de confidentialité. Vos progrès d\'apprentissage sont stockés de manière sécurisée pour améliorer votre expérience.',
                              ),

                              _buildSection(
                                '5. Paiements et Abonnements',
                                'Les paiements sont traités via CamPay et NouPai. Les abonnements sont renouvelés automatiquement. Vous pouvez annuler à tout moment dans les paramètres.',
                              ),

                              _buildSection(
                                '6. Contenu Culturel',
                                'Le contenu linguistique et culturel est fourni en collaboration avec des locuteurs natifs et des experts culturels. Nous nous efforçons de maintenir l\'authenticité et le respect des traditions.',
                              ),

                              _buildSection(
                                '7. Modification des Conditions',
                                'Nous nous réservons le droit de modifier ces conditions. Les utilisateurs seront notifiés des changements importants.',
                              ),

                              const SizedBox(height: 16),

                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange.shade200),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'En acceptant, vous contribuez à la préservation du patrimoine culturel camerounais.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Acceptance checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      const Expanded(
                        child: Text(
                          'J\'ai lu et j\'accepte les termes et conditions',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Exit app or show dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Quitter Mayegue'),
                                content: const Text('Êtes-vous sûr de vouloir quitter l\'application ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Close app - this is platform specific
                                    },
                                    child: const Text('Quitter'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text('Refuser'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Accepter et Continuer',
                          onPressed: _onAcceptTerms,
                          backgroundColor: _acceptedTerms ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}