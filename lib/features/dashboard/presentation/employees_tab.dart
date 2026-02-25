import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonmanager/models/employee_model.dart';
import 'package:salonmanager/providers/dashboard_providers.dart';
import 'package:salonmanager/providers/employee_provider.dart';

// State Provider für Add-Form
final showAddEmployeeProvider = StateProvider<bool>((ref) => false);
final newEmployeeNameProvider = StateProvider<String>((ref) => '');
final newEmployeeEmailProvider = StateProvider<String>((ref) => '');
final isLoadingEmployeeProvider = StateProvider<bool>((ref) => false);
final removingEmployeeIdProvider = StateProvider<String?>((ref) => null);

class EmployeeManagementTab extends ConsumerWidget {
  final String salonId;

  const EmployeeManagementTab({required this.salonId, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(employeesProvider);
    final showAddEmployee = ref.watch(showAddEmployeeProvider);
    final isLoading = ref.watch(isLoadingEmployeeProvider);

    return employees.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Fehler beim Laden der Mitarbeiter: $error')),
      data: (employeeList) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit Add Button
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Mitarbeiter verwalten',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${employeeList.length} Mitarbeiter',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (!showAddEmployee)
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(showAddEmployeeProvider.notifier).state = true;
                      },
                      icon: Icon(Icons.add),
                      label: Text('+ Mitarbeiter hinzufügen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8),

            // Add Employee Form
            if (showAddEmployee) _buildAddEmployeeForm(context, ref, isLoading),

            SizedBox(height: 16),

            // Employees List
            if (employeeList.isEmpty)
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
                itemCount: employeeList.length,
                itemBuilder: (context, index) {
                  final employee = employeeList[index];
                  final removingId = ref.watch(removingEmployeeIdProvider);

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${employee.firstName} ${employee.lastName}',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    employee.email,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: removingId == employee.id || isLoading
                                  ? null
                                  : () =>
                                        _deleteEmployee(context, ref, employee),
                              icon: removingId == employee.id
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(Icons.delete, size: 16),
                              label: Text('Entfernen'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      ref.read(newEmployeeNameProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      ref.read(newEmployeeEmailProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ref.read(showAddEmployeeProvider.notifier).state =
                              false;
                          ref.read(newEmployeeNameProvider.notifier).state = '';
                          ref.read(newEmployeeEmailProvider.notifier).state =
                              '';
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[700],
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
    final name = ref.read(newEmployeeNameProvider);
    final email = ref.read(newEmployeeEmailProvider);

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Name und Email erforderlich')));
      return;
    }

    ref.read(isLoadingEmployeeProvider.notifier).state = true;

    try {
      final service = ref.read(dashboardServiceProvider);
      final success = await service.createEmployee(
        salonId,
        name, // firstName
        '', // lastName - für die einfache Implementierung
        email,
        '', // phone
        'stylist', // default role
      );

      if (success != null) {
        ref.invalidate(employeesProvider);
        ref.read(showAddEmployeeProvider.notifier).state = false;
        ref.read(newEmployeeNameProvider.notifier).state = '';
        ref.read(newEmployeeEmailProvider.notifier).state = '';

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Mitarbeiter hinzugefügt!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Hinzufügen des Mitarbeiters')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
    } finally {
      ref.read(isLoadingEmployeeProvider.notifier).state = false;
    }
  }

  void _deleteEmployee(BuildContext context, WidgetRef ref, Employee employee) {
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
              ref.read(removingEmployeeIdProvider.notifier).state = employee.id;

              try {
                final service = ref.read(dashboardServiceProvider);
                final success = await service.deleteEmployee(employee.id);
                if (success) {
                  ref.invalidate(employeesProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mitarbeiter entfernt!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fehler beim Entfernen des Mitarbeiters'),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
              } finally {
                ref.read(removingEmployeeIdProvider.notifier).state = null;
              }
            },
            child: Text('Entfernen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
