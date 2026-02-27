import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../loyalty/data/loyalty_repository.dart';
import '../../data/models/customer_profile.dart';

class CustomerLoyaltyTab extends ConsumerWidget {
  final CustomerProfile customer;

  const CustomerLoyaltyTab({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.wait([
        ref
            .read(loyaltyRepositoryProvider)
            .getLoyaltyCard(salonId: customer.salonId, customerId: customer.id),
        ref.read(loyaltyRepositoryProvider).getLoyaltyLevels(customer.salonId),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Fehler beim Laden der Loyalty-Daten: ${snapshot.error}'),
            ),
          );
        }

        final data = snapshot.data;
        final card = data?[0] as LoyaltyCard?;
        final levels = (data?[1] as List<LoyaltyLevelConfig>? ?? [])
          ..sort((a, b) => a.thresholdPoints.compareTo(b.thresholdPoints));

        if (card == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Noch keine Treuekarte vorhanden.'),
            ),
          );
        }

        final nextLevel = levels
            .where((level) => level.thresholdPoints > card.points)
            .cast<LoyaltyLevelConfig?>()
            .firstWhere((item) => item != null, orElse: () => null);

        final remaining = nextLevel == null
            ? 0
            : (nextLevel.thresholdPoints - card.points).clamp(0, 1 << 30);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Punkte: ${card.points}',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Level: ${card.level.toUpperCase()}'),
                    const SizedBox(height: 8),
                    Text('Besuche: ${card.visits}'),
                    const SizedBox(height: 8),
                    Text(
                      nextLevel == null
                          ? 'Höchstes Level erreicht 🎉'
                          : 'Nächstes Level (${nextLevel.level}): noch $remaining Punkte',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Level-Konfiguration',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...levels.map(
                      (level) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                            '${level.level} (ab ${level.thresholdPoints} Punkten)'),
                        subtitle: Text(level.rewardType == null
                            ? 'Kein Reward'
                            : '${level.rewardType} / ${level.rewardValue ?? 0}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
