import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/app_widgets.dart';
import '../../../core/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/supabase_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  String _maskName(String name) {
    if (name.isEmpty) {
      return '***';
    }
    if (name.length == 1) {
      return '${name[0]}***';
    }
    return '${name.substring(0, 1)}***';
  }

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final maskedEmail = _maskEmail(email);
    final maskedFirstName = _maskName(_firstNameController.text.trim());
    final maskedLastName = _maskName(_lastNameController.text.trim());
    debugPrint(
      '[Auth][Register] Submit pressed (email=$maskedEmail, firstName=$maskedFirstName, lastName=$maskedLastName)',
    );

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      debugPrint('[Auth][Register] Validation failed (email=$maskedEmail)');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    debugPrint(
      '[Auth][Register] Validation passed, starting sign-up (email=$maskedEmail)',
    );

    try {
      final supabase = SupabaseService();
      await supabase.signUpWithEmail(
        email: email,
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      debugPrint('[Auth][Register] Sign-up succeeded (email=$maskedEmail)');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please verify your email.'),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('[Auth][Register] Sign-up failed (email=$maskedEmail) - $e');
      setState(() {
        _errorMessage = 'Registration failed: ${e.toString()}';
      });
    } finally {
      debugPrint('[Auth][Register] Sign-up finished (email=$maskedEmail)');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.signUp)),
      body: ResponsiveContainer(
        padding: EdgeInsets.all(isMobile ? AppSizes.lg : AppSizes.xxl),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                      label: 'First Name',
                      hintText: 'John',
                      controller: _firstNameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.person_outlined),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return AppStrings.required;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),
                    AppTextFormField(
                      label: 'Last Name',
                      hintText: 'Doe',
                      controller: _lastNameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.person_outlined),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return AppStrings.required;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),
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
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return AppStrings.required;
                        }
                        if (value!.length < 6) {
                          return AppStrings.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),
                    AppTextFormField(
                      label: AppStrings.confirmPassword,
                      hintText: '••••••••',
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return AppStrings.required;
                        }
                        if (value != _passwordController.text) {
                          return AppStrings.passwordMismatch;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // Register Button
              AppButton(
                text: AppStrings.signUp,
                isLoading: _isLoading,
                onPressed: _handleRegister,
              ),
              const SizedBox(height: AppSizes.lg),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.haveAccount,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(AppStrings.signIn),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
