import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/platform/avatar_picker/avatar_picker_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/profile_model.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/auth_provider.dart';

class ProfileDashboard extends ConsumerStatefulWidget {
  const ProfileDashboard({super.key});

  @override
  ConsumerState<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends ConsumerState<ProfileDashboard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _houseNumberController;
  late TextEditingController _postalCodeController;
  late TextEditingController _cityController;

  bool _isSaving = false;
  bool _isUploadingAvatar = false;
  bool _didInitExtraSettings = false;

  String _preferredLanguage = 'de';
  bool _cookieConsent = false;
  bool _privacyConsent = false;
  bool _termsConsent = false;

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

  void _initializeControllers(Profile? profile) {
    if (profile != null) {
      _firstNameController.text = profile.firstName ?? '';
      _lastNameController.text = profile.lastName ?? '';
      _phoneController.text = profile.phone ?? '';
      _streetController.text = profile.street ?? '';
      _houseNumberController.text = profile.houseNumber ?? '';
      _postalCodeController.text = profile.postalCode ?? '';
      _cityController.text = profile.city ?? '';
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final profileNotifier = ref.read(profileProvider.notifier);
      final currentProfile = ref.read(profileProvider).value;

      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          street: _streetController.text.trim(),
          houseNumber: _houseNumberController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          city: _cityController.text.trim(),
        );

        await profileNotifier.updateProfile(updatedProfile);

        if (mounted) {
          setState(() => _didInitExtraSettings = true);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('profile.profileUpdated'.tr()),
              backgroundColor: AppColors.sage,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('profile.updateError'.tr()),
            backgroundColor: AppColors.rose,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _uploadAvatar() async {
    if (_isUploadingAvatar) return;

    setState(() => _isUploadingAvatar = true);

    try {
      final payload = await pickAvatarUploadPayload();
      if (payload == null) {
        return;
      }

      await ref.read(profileProvider.notifier).uploadAvatarBytes(
            bytes: payload.bytes,
            extension: payload.extension,
            contentType: payload.contentType,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('profile.avatarUpdated'.tr()),
            backgroundColor: AppColors.sage,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('profile.avatarError'.tr()),
          backgroundColor: AppColors.rose,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final extraSettings = ref.watch(profileExtraSettingsProvider);
    final authState = ref.watch(authStateProvider);

    return profileAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.alertCircle, size: 48, color: AppColors.rose),
            const SizedBox(height: 16),
            Text(
              'common.error'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (profile) {
        if (profile == null) {
          return Center(
            child: Text('profile.noProfile'.tr()),
          );
        }

        // Initialize controllers with profile data
        if (_firstNameController.text.isEmpty) {
          _initializeControllers(profile);
        }

        if (!_didInitExtraSettings) {
          _preferredLanguage = extraSettings.preferredLanguage;
          _cookieConsent = extraSettings.cookieConsent;
          _privacyConsent = extraSettings.privacyConsent;
          _termsConsent = extraSettings.termsConsent;
          _didInitExtraSettings = true;
        }

        final user = authState.value;
        final initials = '${profile.firstName?[0] ?? ''}${profile.lastName?[0] ?? ''}'.toUpperCase();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'profile.settings'.tr(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Profile Card
                Container(
                  decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar Section
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.gradientPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: profile.avatarUrl != null
                                      ? ClipOval(
                                          child: Image.network(
                                            profile.avatarUrl!,
                                            width: 116,
                                            height: 116,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stack) =>
                                                _buildInitialsAvatar(initials),
                                          ),
                                        )
                                      : _buildInitialsAvatar(initials),
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: _isUploadingAvatar ? null : _uploadAvatar,
                                icon: _isUploadingAvatar
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(LucideIcons.upload, size: 16),
                                label: Text('profile.uploadAvatar'.tr()),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                user?.email ?? '',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        Text(
                          'profile.language'.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _preferredLanguage,
                          decoration: InputDecoration(
                            labelText: 'profile.preferredLanguage'.tr(),
                            prefixIcon: const Icon(LucideIcons.languages, color: AppColors.gold),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: AppColors.cardBg,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'de',
                              child: Text('profile.languageGerman'.tr()),
                            ),
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('profile.languageEnglish'.tr()),
                            ),
                          ],
                          onChanged: (value) async {
                            if (value == null) return;
                            setState(() => _preferredLanguage = value);
                            await context.setLocale(Locale(value));
                          },
                        ),
                        const SizedBox(height: 24),

                        // Personal Information
                        Text(
                          'profile.personalInformation'.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _firstNameController,
                                label: 'profile.firstName'.tr(),
                                icon: LucideIcons.user,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'common.required'.tr();
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _lastNameController,
                                label: 'profile.lastName'.tr(),
                                icon: LucideIcons.user,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'common.required'.tr();
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _phoneController,
                          label: 'profile.phone'.tr(),
                          icon: LucideIcons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),

                        // Address Information
                        Text(
                          'profile.addressInformation'.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildTextField(
                                controller: _streetController,
                                label: 'profile.street'.tr(),
                                icon: LucideIcons.mapPin,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _houseNumberController,
                                label: 'profile.houseNumber'.tr(),
                                icon: LucideIcons.hash,
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
                                label: 'profile.postalCode'.tr(),
                                icon: LucideIcons.mailbox,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: _buildTextField(
                                controller: _cityController,
                                label: 'profile.city'.tr(),
                                icon: LucideIcons.building,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        Text(
                          'profile.consents'.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          value: _cookieConsent,
                          onChanged: (value) => setState(() => _cookieConsent = value),
                          title: Text('profile.cookieConsent'.tr()),
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColors.gold,
                        ),
                        SwitchListTile(
                          value: _privacyConsent,
                          onChanged: (value) => setState(() => _privacyConsent = value),
                          title: Text('profile.privacyConsent'.tr()),
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColors.gold,
                        ),
                        SwitchListTile(
                          value: _termsConsent,
                          onChanged: (value) => setState(() => _termsConsent = value),
                          title: Text('profile.termsConsent'.tr()),
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColors.gold,
                        ),
                        const SizedBox(height: 24),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSaving
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) return;

                                    setState(() => _isSaving = true);
                                    try {
                                      final profileNotifier = ref.read(profileProvider.notifier);
                                      final currentProfile = ref.read(profileProvider).value;
                                      if (currentProfile == null) return;

                                      final updatedProfile = currentProfile.copyWith(
                                        firstName: _firstNameController.text.trim(),
                                        lastName: _lastNameController.text.trim(),
                                        phone: _phoneController.text.trim(),
                                        street: _streetController.text.trim(),
                                        houseNumber: _houseNumberController.text.trim(),
                                        postalCode: _postalCodeController.text.trim(),
                                        city: _cityController.text.trim(),
                                      );

                                      await profileNotifier.updateProfile(
                                        updatedProfile,
                                        preferredLanguage: _preferredLanguage,
                                        cookieConsent: _cookieConsent,
                                        privacyConsent: _privacyConsent,
                                        termsConsent: _termsConsent,
                                      );

                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('profile.profileUpdated'.tr()),
                                            backgroundColor: AppColors.sage,
                                          ),
                                        );
                                      }
                                    } catch (_) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('profile.updateError'.tr()),
                                            backgroundColor: AppColors.rose,
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isSaving = false);
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColors.gold,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(LucideIcons.save, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'common.save'.tr(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      width: 116,
      height: 116,
      decoration: BoxDecoration(
        color: AppColors.background,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.isEmpty ? 'U' : initials,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.gold),
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
      keyboardType: keyboardType,
    );
  }
}
