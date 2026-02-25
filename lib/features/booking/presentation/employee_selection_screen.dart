import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/booking_context_provider.dart';

/// Employee selection after time slot pick
class EmployeeSelectionScreen extends ConsumerWidget {
  const EmployeeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingContext = ref.watch(bookingContextProvider);
    final employeesAsync = ref.watch(availableEmployeesProvider);

    if (bookingContext.selectedSalon == null ||
        bookingContext.selectedService == null ||
        bookingContext.selectedDate == null ||
        bookingContext.selectedTime == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Stylist wählen')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.alertCircle, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              const Text('Bitte zuerst Datum und Uhrzeit auswählen'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Zurück'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stylist wählen'),
        elevation: 0,
      ),
      body: employeesAsync.when(
        data: (employees) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: bookingContext.selectedEmployee == null
                    ? AppColors.gold.withValues(alpha: 0.1)
                    : null,
                child: ListTile(
                  leading: Icon(
                    LucideIcons.users,
                    color: bookingContext.selectedEmployee == null
                        ? AppColors.gold
                        : AppColors.textSecondary,
                  ),
                  title: const Text('Kein Stylist (nächster verfügbarer)'),
                  trailing: bookingContext.selectedEmployee == null
                      ? Icon(LucideIcons.check, color: AppColors.gold)
                      : null,
                  onTap: () {
                    ref.read(bookingContextProvider.notifier).state = ref
                        .read(bookingContextProvider)
                        .copyWith(selectedEmployee: null);
                  },
                ),
              ),
              if (employees.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Keine passenden Stylisten gefunden',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...employees.map((employee) {
                  final isSelected =
                      bookingContext.selectedEmployee?.id == employee.id;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected
                        ? AppColors.gold.withValues(alpha: 0.1)
                        : null,
                    child: ListTile(
                      leading: Icon(
                        LucideIcons.user,
                        color:
                            isSelected ? AppColors.gold : AppColors.textSecondary,
                      ),
                      title: Text(
                        employee.fullName.isEmpty
                            ? 'Stylist ohne Namen'
                            : employee.fullName,
                      ),
                      trailing: isSelected
                          ? Icon(LucideIcons.check, color: AppColors.gold)
                          : null,
                      onTap: () {
                        ref.read(bookingContextProvider.notifier).state = ref
                            .read(bookingContextProvider)
                            .copyWith(selectedEmployee: employee);
                      },
                    ),
                  );
                }),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(LucideIcons.check),
                  label: const Text('Auswahl bestätigen'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Fehler: $e')),
      ),
    );
  }
}
