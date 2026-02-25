import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/employee_provider.dart';

class EmployeeDetailScreen extends ConsumerWidget {
  final String employeeId;
  const EmployeeDetailScreen({required this.employeeId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeAsync = ref.watch(employeeDetailProvider(employeeId));

    return Scaffold(
      appBar: AppBar(
        title: Text('employee.details'.tr()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: employeeAsync.when(
        data: (employee) {
          if (employee == null) return Center(child: Text('employee.not_found'.tr()));
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        child: Center(
                          child: Text(
                            '${employee.firstName[0]}${employee.lastName[0]}'.toUpperCase(),
                            style: AppStyles.headlineLarge.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('${employee.firstName} ${employee.lastName}', style: AppStyles.headlineSmall),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(employee.role.toUpperCase(), 
                          style: AppStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('📧', employee.email),
                      const SizedBox(height: 12),
                      _buildInfoRow('📱', employee.phone),
                      if (employee.yearsOfExperience != null)
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            _buildInfoRow('💼', '${employee.yearsOfExperience} years experience'),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildInfoRow(String icon, String text) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppStyles.bodyMedium)),
      ],
    );
  }
}
