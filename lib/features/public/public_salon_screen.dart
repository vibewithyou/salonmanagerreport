import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/public_salon_provider.dart';
import '../../core/theme/app_theme.dart';

class PublicSalonScreen extends ConsumerWidget {
  final String salonId;
  const PublicSalonScreen({super.key, required this.salonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonAsync = ref.watch(publicSalonDataProvider(salonId));

    return Scaffold(
      body: salonAsync.when(
        data: (salon) {
          if (salon == null) {
            return const Center(child: Text('Salon not found'));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(salon.name),
                  background: salon.logoUrl != null
                      ? Image.network(salon.logoUrl!, fit: BoxFit.cover)
                      : Container(
                          decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
                          child: const Icon(Icons.business, size: 80, color: AppTheme.goldColor),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(salon.description, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 24),
                      if (salon.address != null) _InfoRow(icon: Icons.location_on, text: salon.address!),
                      if (salon.phone != null) _InfoRow(icon: Icons.phone, text: salon.phone!),
                      if (salon.email != null) _InfoRow(icon: Icons.email, text: salon.email!),
                      const SizedBox(height: 24),
                      const Text('Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...salon.services.map((service) => Card(
                            child: ListTile(
                              title: Text(service.name),
                              subtitle: Text('${service.duration} min${service.description != null ? ' • ${service.description}' : ''}'),
                              trailing: Text('\$${service.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.goldColor)),
                            ),
                          )),
                      const SizedBox(height: 24),
                      if (salon.openingHours.isNotEmpty) ...[
                        const Text('Opening Hours', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ...salon.openingHours.map((hours) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(hours),
                            )),
                      ],
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.goldColor,
                            padding: const EdgeInsets.all(16),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking system integration coming soon!')));
                          },
                          child: const Text('Book Appointment', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.goldColor),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
