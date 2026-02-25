import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/onboarding_provider.dart';

class UserOnboardingScreen extends ConsumerStatefulWidget {
  const UserOnboardingScreen({super.key});

  @override
  ConsumerState<UserOnboardingScreen> createState() =>
      _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends ConsumerState<UserOnboardingScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _houseNumberController;
  late TextEditingController _postalCodeController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _streetController = TextEditingController();
    _houseNumberController = TextEditingController();
    _postalCodeController = TextEditingController();
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (!_formKey.currentState!.validate()) return;

    _updateTempData();

    final onboardingData = {
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'street': _streetController.text.trim(),
      'house_number': _houseNumberController.text.trim(),
      'postal_code': _postalCodeController.text.trim(),
      'city': _cityController.text.trim(),
    };

    try {
      final notifier = ref.read(onboardingNotifierProvider.notifier);
      await notifier.completeOnboarding(onboardingData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('onboarding.profileUpdated'.tr()),
            backgroundColor: AppColors.sage,
            duration: const Duration(seconds: 2),
          ),
        );
        // Navigate to dashboard after a short delay to show success message
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.rose,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _updateTempData() {
    ref.read(tempOnboardingProvider.notifier).state = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'phone': _phoneController.text,
      'street': _streetController.text,
      'house_number': _houseNumberController.text,
      'postal_code': _postalCodeController.text,
      'city': _cityController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.gradientWarm),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Progress indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'onboarding.completeProfile'.tr(),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'onboarding.stepInfo'.tr(args: [(_currentStep + 1).toString(), '3']),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      LinearProgressIndicator(
                        value: (_currentStep + 1) / 3,
                        minHeight: 4,
                        backgroundColor: AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.gold.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Form content
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_currentStep == 0) ...[
                          Text(
                            'onboarding.personalInfo'.tr(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration: InputDecoration(
                                    labelText: 'profile.firstName'.tr(),
                                    prefixIcon: const Icon(LucideIcons.user, color: AppColors.gold),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) => value?.isEmpty ?? true ? 'common.required'.tr() : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    labelText: 'profile.lastName'.tr(),
                                    prefixIcon: const Icon(LucideIcons.user, color: AppColors.gold),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) => value?.isEmpty ?? true ? 'common.required'.tr() : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'profile.phone'.tr(),
                              prefixIcon: const Icon(LucideIcons.phone, color: AppColors.gold),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) => value?.isEmpty ?? true ? 'common.required'.tr() : null,
                          ),
                        ] else if (_currentStep == 1) ...[
                          Text(
                            'onboarding.address'.tr(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _streetController,
                                  decoration: InputDecoration(
                                    labelText: 'profile.street'.tr(),
                                    prefixIcon: const Icon(LucideIcons.mapPin, color: AppColors.gold),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) => value?.isEmpty ?? true ? 'common.required'.tr() : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _houseNumberController,
                                  decoration: InputDecoration(
                                    labelText: 'profile.houseNumber'.tr(),
                                    prefixIcon: const Icon(LucideIcons.hash, color: AppColors.gold),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) => value?.isEmpty ?? true ? 'common.required'.tr() : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _postalCodeController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'profile.postalCode'.tr(),
                                    prefixIcon: const Icon(LucideIcons.mailbox, color: AppColors.gold),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) => value?.isEmpty ?? true ? 'common.required'.tr() : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _cityController,
                                  decoration: InputDecoration(
                                    labelText: 'profile.city'.tr(),
                                    prefixIcon: const Icon(LucideIcons.building, color: AppColors.gold),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) => value?.isEmpty ?? true ? 'common.required'.tr() : null,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Text(
                            'onboarding.review'.tr(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildReviewItem('profile.firstName'.tr(), _firstNameController.text),
                          _buildReviewItem('profile.lastName'.tr(), _lastNameController.text),
                          _buildReviewItem('profile.phone'.tr(), _phoneController.text),
                          const SizedBox(height: 16),
                          _buildReviewItem('profile.street'.tr(), _streetController.text),
                          _buildReviewItem('profile.city'.tr(), _cityController.text),
                        ],
                        const SizedBox(height: 32),
                        // Buttons
                        Row(
                          children: [
                            if (_currentStep > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    _updateTempData();
                                    setState(() => _currentStep--);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: const BorderSide(color: AppColors.gold),
                                  ),
                                  child: Text('common.back'.tr()),
                                ),
                              ),
                            if (_currentStep > 0) const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_currentStep < 2) {
                                    _updateTempData();
                                    setState(() => _currentStep++);
                                  } else {
                                    _completeOnboarding();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: AppColors.gold,
                                ),
                                child: Text(
                                  _currentStep < 2 ? 'common.next'.tr() : 'common.complete'.tr(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
