import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStubScreen(
      context,
      'MeineTermine',
      'Hier sehen Sie alle Ihre Termine im Detail.',
      LucideIcons.calendar,
    );
  }
}

class InspirationScreen extends StatelessWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStubScreen(
      context,
      'Inspiration',
      'Entdecken Sie neue Frisuren und Styles.',
      LucideIcons.sparkles,
    );
  }
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStubScreen(
      context,
      'Nachrichten',
      'Ihre Konversationen mit Salons und Stylisten.',
      LucideIcons.messageCircle,
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStubScreen(
      context,
      'Support',
      'Kontaktieren Sie unser Support-Team.',
      LucideIcons.headphones,
    );
  }
}

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStubScreen(
      context,
      'Lagerverwaltung',
      'Verwalten Sie Produkte, Bestände und Lieferanten.',
      LucideIcons.package,
    );
  }
}

class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStubScreen(
      context,
      'Kassensystem',
      'Point of Sale - Zahlungen und Rechnungen.',
      LucideIcons.creditCard,
    );
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStubScreen(
      context,
      'Berichte',
      'Umsatz, Statistiken und Auswertungen.',
      LucideIcons.barChart3,
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStubScreen(
      context,
      'Einstellungen',
      'App-Einstellungen und Präferenzen.',
      LucideIcons.settings,
    );
  }
}

Widget _buildStubScreen(
  BuildContext context,
  String title,
  String description,
  IconData icon,
) {
  final theme = Theme.of(context);

  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.construction, color: AppColors.warning),
                  const SizedBox(width: 12),
                  Text(
                    'In Entwicklung',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
