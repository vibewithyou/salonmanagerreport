import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/identity_provider.dart';
import '../data/loyalty_repository.dart';

class LoyaltyLevelsScreen extends ConsumerStatefulWidget {
  const LoyaltyLevelsScreen({super.key});

  @override
  ConsumerState<LoyaltyLevelsScreen> createState() => _LoyaltyLevelsScreenState();
}

class _LoyaltyLevelsScreenState extends ConsumerState<LoyaltyLevelsScreen> {
  Future<void> _openLevelDialog({LoyaltyLevelConfig? level}) async {
    final identity = ref.read(identityProvider);
    final salonId = identity.currentSalonId;
    if (salonId == null || salonId.isEmpty) return;

    final levelController = TextEditingController(text: level?.level ?? '');
    final thresholdController =
        TextEditingController(text: level?.thresholdPoints.toString() ?? '0');
    final rewardTypeController =
        TextEditingController(text: level?.rewardType ?? 'percentage');
    final rewardValueController =
        TextEditingController(text: level?.rewardValue?.toString() ?? '');

    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(level == null ? 'Level hinzufügen' : 'Level bearbeiten'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: levelController,
                decoration: const InputDecoration(labelText: 'Level Name'),
              ),
              TextField(
                controller: thresholdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Threshold Punkte'),
              ),
              TextField(
                controller: rewardTypeController,
                decoration: const InputDecoration(
                  labelText: 'Reward Type (percentage/fixed/leer)',
                ),
              ),
              TextField(
                controller: rewardValueController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Reward Value'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    if (save != true) return;

    final normalizedRewardType = rewardTypeController.text.trim().isEmpty
        ? null
        : rewardTypeController.text.trim();
    final parsedRewardValue = rewardValueController.text.trim().isEmpty
        ? null
        : double.tryParse(rewardValueController.text.trim());

    if (level == null) {
      await ref.read(loyaltyRepositoryProvider).createLoyaltyLevel(
            salonId: salonId,
            level: levelController.text.trim().toLowerCase(),
            thresholdPoints:
                int.tryParse(thresholdController.text.trim()) ?? 0,
            rewardType: normalizedRewardType,
            rewardValue: parsedRewardValue,
          );
    } else {
      await ref.read(loyaltyRepositoryProvider).updateLoyaltyLevel(
            levelId: level.id,
            level: levelController.text.trim().toLowerCase(),
            thresholdPoints:
                int.tryParse(thresholdController.text.trim()) ?? 0,
            rewardType: normalizedRewardType,
            rewardValue: parsedRewardValue,
          );
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final salonId = ref.watch(identityProvider).currentSalonId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treueprogramm Levels'),
        actions: [
          IconButton(
            onPressed: () => _openLevelDialog(),
            icon: const Icon(Icons.add),
            tooltip: 'Level hinzufügen',
          ),
        ],
      ),
      body: salonId == null || salonId.isEmpty
          ? const Center(child: Text('Kein Salon ausgewählt'))
          : FutureBuilder<List<LoyaltyLevelConfig>>(
              future: ref.read(loyaltyRepositoryProvider).getLoyaltyLevels(salonId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Fehler: ${snapshot.error}'));
                }

                final levels = snapshot.data ?? [];
                if (levels.isEmpty) {
                  return const Center(
                    child: Text('Noch keine Levels vorhanden.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: levels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${level.level.toUpperCase()} • ab ${level.thresholdPoints} Punkten',
                        ),
                        subtitle: Text(level.rewardType == null
                            ? 'Kein Reward'
                            : '${level.rewardType} (${level.rewardValue ?? 0})'),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _openLevelDialog(level: level),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                await ref
                                    .read(loyaltyRepositoryProvider)
                                    .deleteLoyaltyLevel(level.id);
                                if (mounted) setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
