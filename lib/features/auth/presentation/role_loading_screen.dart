import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_utils.dart';

/// Role Loading Screen - Shown while identity (role) is being loaded from Supabase
/// 
/// This prevents routing to the wrong dashboard before the user's role is determined.
/// Matches React behavior where UserRoleContext shows loading state.
class RoleLoadingScreen extends StatelessWidget {
  const RoleLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: UiUtils.gradientPrimary(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: UiUtils.gradientGold(),
                child: const Icon(
                  Icons.cut,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Loading indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                  strokeWidth: 3,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Loading text
              Text(
                'Lade Benutzer-Rolle...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Einen Moment bitte',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
