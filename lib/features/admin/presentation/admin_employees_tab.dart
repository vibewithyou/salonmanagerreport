import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/employee_model.dart';
import '../../../providers/employee_provider.dart';
import '../../../providers/dashboard_providers.dart';
import '../../../services/activity_log_service.dart';
import '../../../models/activity_log_model.dart';

// State Provider für Add-Form
final adminShowAddEmployeeProvider = StateProvider<bool>((ref) => false);
final adminNewEmployeeNameProvider = StateProvider<String>((ref) => '');
final adminNewEmployeeEmailProvider = StateProvider<String>((ref) => '');
final adminIsLoadingEmployeeProvider = StateProvider<bool>((ref) => false);
final adminRemovingEmployeeIdProvider = StateProvider<String?>((ref) => null);

class AdminEmployeesTab extends ConsumerWidget {
  final String salonId;

  const AdminEmployeesTab({
    required this.salonId,
    Key? key,
  }) : super(key: key);

  ButtonStyle _actionButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      minimumSize: const Size(0, 40),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeGroups = ref.watch(adminEmployeesBySalonProvider);
    final showAddEmployee = ref.watch(adminShowAddEmployeeProvider);
    final isLoading = ref.watch(adminIsLoadingEmployeeProvider);

    return employeeGroups.when(
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Fehler beim Laden der Mitarbeiter: $error'),
      ),
      data: (groups) {
        final totalEmployees = groups.fold<int>(
          0,
          (sum, group) => sum + group.employees.length,
        );

        return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit Add Button
            Padding(
              padding: EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 760;

                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.users, size: 24),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Mitarbeiter verwalten',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          '$totalEmployees Mitarbeiter',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        if (!showAddEmployee) ...[
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(adminShowAddEmployeeProvider.notifier)
                                    .state = true;
                              },
                              icon: Icon(Icons.add),
                              label: Text('+ Mitarbeiter hinzufügen'),
                              style: _actionButtonStyle(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(LucideIcons.users, size: 24),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Mitarbeiter verwalten',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              '$totalEmployees Mitarbeiter',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      if (!showAddEmployee)
                        ElevatedButton.icon(
                          onPressed: () {
                            ref.read(adminShowAddEmployeeProvider.notifier).state =
                                true;
                          },
                          icon: Icon(Icons.add),
                          label: Text('+ Mitarbeiter hinzufügen'),
                          style: _actionButtonStyle(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 8),

            // Add Employee Form
            if (showAddEmployee)
              _buildAddEmployeeForm(context, ref, isLoading),

            SizedBox(height: 16),

            // Employees List
            if (totalEmployees == 0)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Keine Mitarbeiter vorhanden'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: groups.length,
                itemBuilder: (context, groupIndex) {
                  final group = groups[groupIndex];
                  final removingId = ref.watch(adminRemovingEmployeeIdProvider);

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${group.salonName} (${group.employees.length})',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        if (group.employees.isEmpty)
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Keine Mitarbeiter in diesem Salon',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          )
                        else
                          ...group.employees.map((employee) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${employee.firstName} ${employee.lastName}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              employee.email,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: removingId == employee.id ||
                                                isLoading
                                            ? null
                                            : () => _deleteEmployee(
                                                  context,
                                                  ref,
                                                  employee,
                                                ),
                                        icon: removingId == employee.id
                                            ? SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Icon(Icons.delete, size: 16),
                                        label: Text('Entfernen'),
                                        style: _actionButtonStyle(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      );
      },
    );
  }

  Widget _buildAddEmployeeForm(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Neuer Mitarbeiter',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      ref.read(adminNewEmployeeNameProvider.notifier).state =
                          value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      ref.read(adminNewEmployeeEmailProvider.notifier).state =
                          value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => _handleAddEmployee(context, ref),
                  icon: isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(Icons.check, size: 16),
                  label: Text('Speichern'),
                  style: _actionButtonStyle(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ref.read(adminShowAddEmployeeProvider.notifier).state =
                              false;
                          ref.read(adminNewEmployeeNameProvider.notifier).state =
                              '';
                          ref
                              .read(
                                  adminNewEmployeeEmailProvider.notifier)
                              .state = '';
                        },
                  style: _actionButtonStyle(
                    backgroundColor: Colors.grey[300]!,
                    foregroundColor: Colors.grey[700]!,
                  ),
                  child: Text('Abbrechen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddEmployee(BuildContext context, WidgetRef ref) async {
    final name = ref.read(adminNewEmployeeNameProvider);
    final email = ref.read(adminNewEmployeeEmailProvider);

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name und Email erforderlich')),
      );
      return;
    }

    ref.read(adminIsLoadingEmployeeProvider.notifier).state = true;

    try {
      final service = ref.read(dashboardServiceProvider);
      final success = await service.createEmployee(
        salonId,
        name,
        '',
        email,
        '',
        'stylist',
      );

      if (success != null) {
        ref.invalidate(adminEmployeesBySalonProvider);
        ref.invalidate(employeesProvider);
        ref.read(adminShowAddEmployeeProvider.notifier).state = false;
        ref.read(adminNewEmployeeNameProvider.notifier).state = '';
        ref.read(adminNewEmployeeEmailProvider.notifier).state = '';

        // Log activity
        try {
          final activityService = ActivityLogService(Supabase.instance.client);
          await activityService.logActivity(
            salonId: salonId,
            userId: 'admin',
            userName: 'Admin',
            type: ActivityType.employee_created,
            description: 'Mitarbeiter $name hinzugefügt',
            metadata: {'employee_name': name, 'employee_email': email},
          );
        } catch (e) {
          print('Error logging activity: $e');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mitarbeiter hinzugefügt!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Hinzufügen des Mitarbeiters')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    } finally {
      ref.read(adminIsLoadingEmployeeProvider.notifier).state = false;
    }
  }

  void _deleteEmployee(
    BuildContext context,
    WidgetRef ref,
    Employee employee,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mitarbeiter entfernen'),
        content: Text(
          'Mitarbeiter "${employee.firstName} ${employee.lastName}" wirklich entfernen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              ref.read(adminRemovingEmployeeIdProvider.notifier).state =
                  employee.id;

              try {
                final service = ref.read(dashboardServiceProvider);
                final success = await service.deleteEmployee(employee.id);
                if (success) {
                  ref.invalidate(adminEmployeesBySalonProvider);
                  ref.invalidate(employeesProvider);

                  // Log activity
                  try {
                    final activityService =
                        ActivityLogService(Supabase.instance.client);
                    await activityService.logActivity(
                      salonId: employee.salonId,
                      userId: 'admin',
                      userName: 'Admin',
                      type: ActivityType.employee_deleted,
                      description: 'Mitarbeiter ${employee.firstName} ${employee.lastName} gelöscht',
                      metadata: {
                        'employee_name': '${employee.firstName} ${employee.lastName}',
                        'employee_id': employee.id,
                      },
                    );
                  } catch (e) {
                    print('Error logging activity: $e');
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mitarbeiter entfernt!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Fehler beim Entfernen des Mitarbeiters')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fehler: $e')),
                );
              } finally {
                ref.read(adminRemovingEmployeeIdProvider.notifier).state =
                    null;
              }
            },
            child: Text('Entfernen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
