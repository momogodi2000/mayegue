import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/onboarding_viewmodel.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Initialize onboarding status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingViewModel>().initialize();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final viewModel = context.read<OnboardingViewModel>();
    if (viewModel.currentStep < OnboardingViewModel.totalSteps - 1) {
      viewModel.nextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    final viewModel = context.read<OnboardingViewModel>();
    if (viewModel.currentStep > 0) {
      viewModel.previousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final viewModel = context.read<OnboardingViewModel>();
    final success = await viewModel.completeOnboarding();

    if (success && mounted) {
      // Navigate to dashboard
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  Future<void> _skipOnboarding() async {
    final viewModel = context.read<OnboardingViewModel>();
    final success = await viewModel.skipOnboarding();

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: viewModel.isLoading ? null : _skipOnboarding,
                child: const Text('Passer', style: TextStyle(color: Colors.grey)),
              ),
            ),

            // Progress indicator
            LinearProgressIndicator(
              value: (viewModel.currentStep + 1) / OnboardingViewModel.totalSteps,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _WelcomeStep(viewModel: viewModel),
                  _LanguageSelectionStep(viewModel: viewModel),
                  _PreferencesStep(viewModel: viewModel),
                  _CompletionStep(viewModel: viewModel),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (viewModel.currentStep > 0)
                    OutlinedButton(
                      onPressed: _previousPage,
                      child: const Text('Précédent'),
                    )
                  else
                    const SizedBox.shrink(),

                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(viewModel.currentStep == OnboardingViewModel.totalSteps - 1
                            ? 'Commencer'
                            : 'Suivant'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  final OnboardingViewModel viewModel;

  const _WelcomeStep({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school, size: 100, color: Colors.green),
          const SizedBox(height: 32),
          Text(
            viewModel.stepTitles[0],
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.stepDescriptions[0],
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LanguageSelectionStep extends StatelessWidget {
  final OnboardingViewModel viewModel;

  const _LanguageSelectionStep({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.language, size: 80, color: Colors.blue),
          const SizedBox(height: 32),
          Text(
            viewModel.stepTitles[1],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.stepDescriptions[1],
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _LanguageOption(
            language: 'ewondo',
            displayName: 'Ewondo',
            description: 'Langue bantoue parlée au Cameroun',
            isSelected: viewModel.selectedLanguage == 'ewondo',
            onTap: () => viewModel.setSelectedLanguage('ewondo'),
          ),
          const SizedBox(height: 16),
          _LanguageOption(
            language: 'bafang',
            displayName: 'Bafang',
            description: 'Langue bantoue parlée dans l\'Ouest du Cameroun',
            isSelected: viewModel.selectedLanguage == 'bafang',
            onTap: () => viewModel.setSelectedLanguage('bafang'),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String language;
  final String displayName;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.displayName,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.green.shade50 : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: isSelected ? Colors.green : Colors.grey.shade300,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.green : Colors.black,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.green.shade700 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferencesStep extends StatelessWidget {
  final OnboardingViewModel viewModel;

  const _PreferencesStep({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings, size: 80, color: Colors.orange),
          const SizedBox(height: 32),
          Text(
            viewModel.stepTitles[2],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.stepDescriptions[2],
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Name input
          TextField(
            decoration: const InputDecoration(
              labelText: 'Votre nom (optionnel)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: viewModel.setUserName,
          ),
          const SizedBox(height: 32),

          // Preferences
          _PreferenceToggle(
            title: 'Notifications',
            subtitle: 'Recevoir des rappels pour vos leçons',
            value: viewModel.notificationsEnabled,
            onChanged: viewModel.toggleNotifications,
          ),
          const SizedBox(height: 16),
          _PreferenceToggle(
            title: 'Sons',
            subtitle: 'Activer les effets sonores',
            value: viewModel.soundEnabled,
            onChanged: viewModel.toggleSound,
          ),
        ],
      ),
    );
  }
}

class _PreferenceToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _CompletionStep extends StatelessWidget {
  final OnboardingViewModel viewModel;

  const _CompletionStep({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, size: 100, color: Colors.green),
          const SizedBox(height: 32),
          Text(
            viewModel.stepTitles[3],
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.stepDescriptions[3],
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                Text(
                  'Langue sélectionnée: ${viewModel.selectedLanguage == 'ewondo' ? 'Ewondo' : 'Bafang'}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (viewModel.userName.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Bienvenue, ${viewModel.userName}!',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
