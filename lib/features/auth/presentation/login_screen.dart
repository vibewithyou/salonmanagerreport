import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../core/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../../../core/auth/identity_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) {
      return '***';
    }
    final name = parts.first;
    final domain = parts.last;
    final maskedName = name.isEmpty
        ? '***'
        : name.length <= 2
        ? '${name[0]}***'
        : '${name.substring(0, 2)}***';
    return '$maskedName@$domain';
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final maskedEmail = _maskEmail(email);
    debugPrint('[Auth][Login] Submit pressed (email=$maskedEmail)');

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      debugPrint('[Auth][Login] Validation failed (email=$maskedEmail)');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    debugPrint(
      '[Auth][Login] Validation passed, starting sign-in (email=$maskedEmail)',
    );

    try {
      final authService = ref.read(authServiceProvider);
      final identityNotifier = ref.read(identityProvider.notifier);
      final success = await authService.login(
        email,
        _passwordController.text,
      );

      if (!success) {
        throw Exception('Login failed');
      }

      debugPrint(
        '[Auth][Login] Sign-in succeeded, loading identity (email=$maskedEmail)',
      );

      // IMPORTANT: Load identity BEFORE checking mounted
      // This ensures identity is loaded even if widget gets disposed
      debugPrint('[Auth][Login] 🔄 Starting identity load...');
      await identityNotifier.loadIdentity();

      if (mounted) {
        final identity = ref.read(identityProvider);
        debugPrint('[Auth][Login] ✅ Identity loaded:');
        debugPrint('[Auth][Login]   User ID: ${identity.userId}');
        debugPrint('[Auth][Login]   Role Key: ${identity.roleKey}');
        debugPrint('[Auth][Login]   Salon ID: ${identity.currentSalonId}');
        debugPrint('[Auth][Login]   Loading: ${identity.loading}');
        debugPrint('[Auth][Login]   Error: ${identity.error}');
      }
      
      // DON'T navigate manually - let router do it automatically!
      // Router will detect: authenticated + roleKey loaded → redirect to home
      debugPrint('[Auth][Login] ✅ Success! Router will handle redirect...');
      
    } catch (e) {
      debugPrint('[Auth][Login] Sign-in failed (email=$maskedEmail) - $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'auth.loginFailed'.tr();
        });
      }
    } finally {
      debugPrint('[Auth][Login] Sign-in finished (email=$maskedEmail)');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(decoration: UiUtils.gradientPrimary()),

          // Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo & Title
                      Container(
                        decoration: UiUtils.liquidGlass(),
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: UiUtils.gradientGold(),
                              child: const Icon(
                                Icons.cut,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ShaderMask(
                              shaderCallback: UiUtils.textGradient([
                                AppColors.gold,
                                AppColors.rose,
                              ]),
                              child: Text(
                                'auth.welcomeBack'.tr(),
                                style: Theme.of(context).textTheme.displaySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'auth.loginSubtitle'.tr(),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 32),

                            // Error Message
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red.shade700,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Form
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Email Field
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: 'auth.email'.tr(),
                                      hintText: 'you@example.com',
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: AppColors.gold,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.borderLight,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.borderLight,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.gold,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'common.required'.tr();
                                      }
                                      if (!AppUtils.isValidEmail(value!)) {
                                        return 'auth.invalidEmail'.tr();
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Password Field
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'auth.password'.tr(),
                                      hintText: '••••••••',
                                      prefixIcon: Icon(
                                        Icons.lock_outlined,
                                        color: AppColors.gold,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: AppColors.textSecondary,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.borderLight,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.borderLight,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.gold,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'common.required'.tr();
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (_) => _handleLogin(),
                                  ),

                                  const SizedBox(height: 16),

                                  // Remember Me & Forgot Password
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: Checkbox(
                                                value: _rememberMe,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _rememberMe = value ?? false;
                                                  });
                                                },
                                                activeColor: AppColors.gold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'auth.rememberMe'.tr(),
                                                style: TextStyle(
                                                  color: AppColors.textSecondary,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.go('/auth/forgot-password');
                                        },
                                        child: Text(
                                          'auth.forgotPassword'.tr(),
                                          style: TextStyle(
                                            color: AppColors.gold,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  // Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Ink(
                                        decoration: UiUtils.gradientGold()
                                            .copyWith(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: UiUtils.shadowGold(),
                                            ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: _isLoading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                )
                                              : Text(
                                                  'auth.signIn'.tr(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Register Link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'auth.noAccount'.tr(),
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.go('/register');
                                        },
                                        child: Text(
                                          'auth.register'.tr(),
                                          style: TextStyle(
                                            color: AppColors.gold,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Guest Booking Link
                                  TextButton(
                                    onPressed: () {
                                      context.go('/booking/guest');
                                    },
                                    child: Text(
                                      'Termin ohne Konto buchen',
                                      style: TextStyle(
                                        color: AppColors.gold.withValues(alpha: 0.8),
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Back to Entry
                      TextButton.icon(
                        onPressed: () {
                          context.go('/entry');
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        label: Text(
                          'common.back'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
