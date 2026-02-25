import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/salon_provider.dart';

class SalonSetupScreen extends ConsumerStatefulWidget {
  const SalonSetupScreen({super.key});

  @override
  ConsumerState<SalonSetupScreen> createState() => _SalonSetupScreenState();
}

class _SalonSetupScreenState extends ConsumerState<SalonSetupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;
  late TextEditingController _streetController;
  late TextEditingController _houseNumberController;
  late TextEditingController _postalCodeController;
  late TextEditingController _cityController;

  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Service categories
  final List<String> _availableCategories = [
    'Hair',
    'Nails',
    'Massage',
    'Skincare',
    'Makeup',
    'Waxing'
  ];
  final List<String> _selectedCategories = [];

  // Amenities
  final List<String> _availableAmenities = [
    'Parking',
    'WiFi',
    'Coffee Bar',
    'Waiting Area',
    'Restroom',
    'Disabled Access'
  ];
  final List<String> _selectedAmenities = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();
    _instagramController = TextEditingController();
    _facebookController = TextEditingController();
    _streetController = TextEditingController();
    _houseNumberController = TextEditingController();
    _postalCodeController = TextEditingController();
    _cityController = TextEditingController();

    // Load existing salon if present
    _loadExistingSalon();
  }

  Future<void> _loadExistingSalon() async {
    try {
      final salon = await ref.read(userSalonProvider.future);
      if (salon != null && mounted) {
        _nameController.text = salon.name;
        _descriptionController.text = salon.description ?? '';
        _phoneController.text = salon.phone ?? '';
        _emailController.text = salon.email ?? '';
        _websiteController.text = salon.website ?? '';
        _streetController.text = salon.address ?? '';
        _postalCodeController.text = salon.postalCode ?? '';
        _cityController.text = salon.city ?? '';
      }
    } catch (e) {
      // New salon setup, no existing data
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _saveSalon() async {
    if (!_formKey.currentState!.validate()) return;

    final salonData = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'website': _websiteController.text.trim(),
      'instagram': _instagramController.text.trim(),
      'facebook': _facebookController.text.trim(),
      'street': _streetController.text.trim(),
      'house_number': _houseNumberController.text.trim(),
      'postal_code': _postalCodeController.text.trim(),
      'city': _cityController.text.trim(),
      'service_categories': _selectedCategories,
      'amenities': _selectedAmenities,
    };

    try {
      final notifier = ref.read(salonNotifierProvider.notifier);
      await notifier.createOrUpdateSalon(salonData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('salon.setupComplete'.tr()),
            backgroundColor: AppColors.sage,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final salonState = ref.watch(salonNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('salon.setup'.tr()),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.gradientWarm),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Progress indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'salon.setupYourSalon'.tr(),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'salon.stepInfo'.tr(args: [(_currentStep + 1).toString(), '3']),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                const SizedBox(height: 30),
                // Form content
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_currentStep == 0) ...[
                          _buildBasicInfoStep(),
                        ] else if (_currentStep == 1) ...[
                          _buildAddressStep(),
                        ] else ...[
                          _buildSettingsStep(),
                        ],
                        const SizedBox(height: 32),
                        // Navigation buttons
                        Row(
                          children: [
                            if (_currentStep > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: salonState.isLoading
                                      ? null
                                      : () {
                                          setState(() => _currentStep--);
                                        },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    side: const BorderSide(
                                        color: AppColors.gold),
                                  ),
                                  child: Text('common.back'.tr()),
                                ),
                              ),
                            if (_currentStep > 0) const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: salonState.isLoading
                                    ? null
                                    : () {
                                        if (_currentStep < 2) {
                                          setState(() => _currentStep++);
                                        } else {
                                          _saveSalon();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  backgroundColor: AppColors.gold,
                                ),
                                child: salonState.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        _currentStep < 2
                                            ? 'common.next'.tr()
                                            : 'common.save'.tr(),
                                        style: const TextStyle(
                                            color: Colors.white),
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

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'salon.basicInfo'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _nameController,
          label: 'salon.name'.tr(),
          icon: LucideIcons.building,
          validator: (value) =>
              value?.isEmpty ?? true ? 'common.required'.tr() : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _descriptionController,
          label: 'salon.description'.tr(),
          icon: LucideIcons.fileText,
          maxLines: 4,
          validator: (value) =>
              value?.isEmpty ?? true ? 'common.required'.tr() : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'common.phone'.tr(),
          icon: LucideIcons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) =>
              value?.isEmpty ?? true ? 'common.required'.tr() : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'common.email'.tr(),
          icon: LucideIcons.mail,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'common.required'.tr();
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value!)) {
              return 'common.invalidEmail'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'common.address'.tr(),
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
              child: _buildTextField(
                controller: _streetController,
                label: 'common.street'.tr(),
                icon: LucideIcons.mapPin,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'common.required'.tr() : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _houseNumberController,
                label: 'common.houseNumber'.tr(),
                icon: LucideIcons.hash,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'common.required'.tr() : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _postalCodeController,
                label: 'common.postalCode'.tr(),
                icon: LucideIcons.mailbox,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'common.required'.tr() : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: _cityController,
                label: 'common.city'.tr(),
                icon: LucideIcons.building,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'common.required'.tr() : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _websiteController,
          label: 'salon.website'.tr(),
          icon: LucideIcons.globe,
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildSettingsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'salon.serviceCategories'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableCategories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              backgroundColor: AppColors.cardBg,
              selectedColor: AppColors.gold.withValues(alpha: 0.3),
              side: BorderSide(
                color: isSelected ? AppColors.gold : AppColors.borderLight,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Text(
          'salon.amenities'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableAmenities.map((amenity) {
            final isSelected = _selectedAmenities.contains(amenity);
            return FilterChip(
              label: Text(amenity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAmenities.add(amenity);
                  } else {
                    _selectedAmenities.remove(amenity);
                  }
                });
              },
              backgroundColor: AppColors.cardBg,
              selectedColor: AppColors.sage.withValues(alpha: 0.3),
              side: BorderSide(
                color: isSelected ? AppColors.sage : AppColors.borderLight,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _instagramController,
          label: 'salon.instagram'.tr(),
          icon: LucideIcons.instagram,
          prefixText: '@',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _facebookController,
          label: 'salon.facebook'.tr(),
          icon: LucideIcons.facebook,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.gold),
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
        filled: true,
        fillColor: AppColors.cardBg,
      ),
      validator: validator,
    );
  }
}
