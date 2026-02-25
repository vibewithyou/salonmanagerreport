import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/app_widgets.dart';
import '../../../core/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/supabase_service.dart';
import 'register_screen.dart';

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
      final supabase = SupabaseService();
      await supabase.signInWithEmail(
        email: email,
        password: _passwordController.text,
      );

      debugPrint(
        '[Auth][Login] Sign-in succeeded, navigating to dashboard (email=$maskedEmail)',
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      debugPrint('[Auth][Login] Sign-in failed (email=$maskedEmail) - $e');
      setState(() {
        _errorMessage = 'Login failed: ${e.toString()}';
      });
    } finally {
      debugPrint('[Auth][Login] Sign-in finished (email=$maskedEmail)');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: ResponsiveContainer(
        padding: EdgeInsets.all(isMobile ? AppSizes.lg : AppSizes.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(Icons.cut, size: AppSizes.iconXl, color: AppColors.primary),
            const SizedBox(height: AppSizes.lg),

            // Title
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.md),

            // Subtitle
            Text(
              'Salon Management Made Easy',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xxl),

            // Error Message
            if (_errorMessage != null) ...[
              AppErrorWidget(message: _errorMessage!),
              const SizedBox(height: AppSizes.lg),
            ],

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextFormField(
                    label: AppStrings.email,
                    hintText: 'you@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.required;
                      }
                      if (!AppUtils.isValidEmail(value!)) {
                        return AppStrings.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.lg),
                  AppTextFormField(
                    label: AppStrings.password,
                    hintText: '••••••••',
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return AppStrings.required;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Navigate to forgot password
                      },
                      child: const Text(AppStrings.forgotPassword),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Login Button
            AppButton(
              text: AppStrings.signIn,
              isLoading: _isLoading,
              onPressed: _handleLogin,
            ),
            const SizedBox(height: AppSizes.lg),

            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.noAccount,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(AppStrings.signUp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
