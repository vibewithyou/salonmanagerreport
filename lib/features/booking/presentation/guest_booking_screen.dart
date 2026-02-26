import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_utils.dart';

/// Guest Booking Screen - Termin ohne Konto buchen (Stub/Start)
class GuestBookingScreen extends StatelessWidget {
  const GuestBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Container(
        decoration: UiUtils.gradientPrimary(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 24.0 : 48.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      // Beispiel-Daten für Demo
                      final booking = {'status': 'pending', 'customer': 'Anna', 'service': 'Haircut', 'time': '2026-02-27 10:00'};
                    // Icon
                    Icon(
                      LucideIcons.calendar,
                      size: 80,
                      color: AppColors.gold,
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Termin ohne Konto buchen',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Buchen Sie schnell und einfach einen Termin',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                            // Status-Badge
                            Align(
                              alignment: Alignment.center,
                              child: _StatusBadge(status: booking['status']!),
                            ),
                            const SizedBox(height: 16),
                          // Steps
                          _buildStep(
                            number: '1',
                            title: 'Salon auswählen',
                            description: 'Wählen Sie Ihren Wunschsalon',
                            icon: LucideIcons.mapPin,
                          ),
                          // Status-Badge Widget (wie in BookingRequestsScreen)
                          class _StatusBadge extends StatelessWidget {
                            final String status;
                            const _StatusBadge({required this.status});

                            @override
                            Widget build(BuildContext context) {
                              Color color;
                              switch (status) {
                                case 'pending':
                                  color = Colors.amber;
                                  break;
                                case 'accepted':
                                  color = Colors.green;
                                  break;
                                case 'declined':
                                  color = Colors.red;
                                  break;
                                case 'cancelled':
                                  color = Colors.grey;
                                  break;
                                case 'completed':
                                  color = Colors.blue;
                                  break;
                                case 'reschedule_proposed':
                                  color = Colors.orange;
                                  break;
                                default:
                                  color = Colors.grey;
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              );
                            }
                          }
                          const SizedBox(height: 16),
                          _buildStep(
                            number: '2',
                            title: 'Leistung wählen',
                            description: 'Haarschnitt, Färben, Styling, etc.',
                            icon: LucideIcons.scissors,
                          ),
                          const SizedBox(height: 16),
                          _buildStep(
                            number: '3',
                            title: 'Termin wählen',
                            description: 'Datum und Uhrzeit auswählen',
                            icon: LucideIcons.clock,
                          ),
                          const SizedBox(height: 16),
                          _buildStep(
                            number: '4',
                            title: 'Kontaktdaten',
                            description: 'Name, E-Mail und Telefon',
                            icon: LucideIcons.user,
                          ),
                          const SizedBox(height: 32),

                          // Start Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to booking wizard
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Buchungs-Wizard kommt bald!',
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Termin buchen',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.arrow_forward, size: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Account Hint
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            LucideIcons.info,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 24,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sie haben bereits ein Konto?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => context.go('/login'),
                            child: const Text(
                              'Jetzt anmelden',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Back Button
                    TextButton.icon(
                      onPressed: () => context.go('/entry'),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: const Text(
                        'Zurück',
                        style: TextStyle(
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
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Row(
      children: [
        // Number Circle
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Icon
        Icon(
          icon,
          color: AppColors.gold,
          size: 28,
        ),
        const SizedBox(width: 16),

        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
