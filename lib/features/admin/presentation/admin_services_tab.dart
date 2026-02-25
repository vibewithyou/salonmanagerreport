import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/auth/identity_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../services/data/service_repository.dart';

class AdminServicesTab extends ConsumerStatefulWidget {
  const AdminServicesTab({super.key});

  @override
  ConsumerState<AdminServicesTab> createState() => _AdminServicesTabState();
}

class _AdminServicesTabState extends ConsumerState<AdminServicesTab> {
  bool _loading = false;
  List<ServiceData> _services = const [];
  String? _error;
  String? _activeSalonId;
  RealtimeChannel? _servicesChannel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadServices());
  }

  Future<void> _loadServices({bool silent = false}) async {
    final salonId = ref.read(identityProvider).currentSalonId;
    if (salonId == null || salonId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _services = const [];
        _error = 'Kein Salon ausgewählt.';
      });
      return;
    }

    final requestedSalonId = salonId;

    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    } else if (_error != null) {
      setState(() {
        _error = null;
      });
    }

    try {
      final repository = ref.read(serviceRepositoryProvider);
      final services = await repository.getSalonServices(salonId);

      if (!mounted) return;
      if (ref.read(identityProvider).currentSalonId != requestedSalonId) return;
      setState(() {
        _services = services..sort((a, b) => a.name.compareTo(b.name));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Fehler beim Laden der Dienstleistungen: $e';
      });
    } finally {
      if (mounted && !silent) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _bindRealtimeForSalon(String salonId) {
    _servicesChannel?.unsubscribe();
    _servicesChannel = Supabase.instance.client
        .channel('admin-services-$salonId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'services',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'salon_id',
            value: salonId,
          ),
          callback: (payload) {
            if (!mounted) return;
            _loadServices(silent: true);
          },
        )
        .subscribe();
  }

  Future<void> _deleteService(ServiceData service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dienstleistung löschen'),
        content: Text('"${service.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      setState(() => _loading = true);
      final repository = ref.read(serviceRepositoryProvider);
      await repository.deleteService(service.id);
      if (!mounted) return;
      setState(() {
        _services = _services.where((item) => item.id != service.id).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dienstleistung gelöscht.')),
      );
      _loadServices(silent: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Löschen fehlgeschlagen: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _openServiceDialog({ServiceData? initial}) async {
    final nameController = TextEditingController(text: initial?.name ?? '');
    final durationController = TextEditingController(
      text: (initial?.durationMinutes ?? 30).toString(),
    );
    final priceController = TextEditingController(
      text: (initial?.price ?? 0).toStringAsFixed(2),
    );
    final categoryController = TextEditingController(text: initial?.category ?? '');
    final descriptionController = TextEditingController(text: initial?.description ?? '');
    final bufferBeforeController = TextEditingController(
      text: initial?.bufferBefore?.toString() ?? '',
    );
    final bufferAfterController = TextEditingController(
      text: initial?.bufferAfter?.toString() ?? '',
    );
    final depositController = TextEditingController(
      text: initial?.depositAmount?.toStringAsFixed(2) ?? '',
    );
    bool isActive = initial?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(initial == null ? 'Dienstleistung hinzufügen' : 'Dienstleistung bearbeiten'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 420,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name *'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Dauer (Minuten) *'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Preis (€) *'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: categoryController,
                        decoration: const InputDecoration(labelText: 'Kategorie'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descriptionController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(labelText: 'Beschreibung'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: bufferBeforeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Puffer davor (Min)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: bufferAfterController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Puffer danach (Min)',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: depositController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Anzahlung (€)'),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Aktiv'),
                        value: isActive,
                        onChanged: (value) => setDialogState(() => isActive = value),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Abbrechen'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != true) return;

    final name = nameController.text.trim();
    final duration = int.tryParse(durationController.text.trim());
    final price = double.tryParse(priceController.text.replaceAll(',', '.').trim());
    final bufferBefore = bufferBeforeController.text.trim().isEmpty
      ? null
      : int.tryParse(bufferBeforeController.text.trim());
    final bufferAfter = bufferAfterController.text.trim().isEmpty
      ? null
      : int.tryParse(bufferAfterController.text.trim());
    final depositAmount = depositController.text.trim().isEmpty
      ? null
      : double.tryParse(depositController.text.replaceAll(',', '.').trim());

    if (name.isEmpty || duration == null || duration <= 0 || price == null || price < 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Name, gültige Dauer und Preis eingeben.')),
      );
      return;
    }

    if ((bufferBeforeController.text.trim().isNotEmpty && bufferBefore == null) ||
        (bufferAfterController.text.trim().isNotEmpty && bufferAfter == null) ||
        (depositController.text.trim().isNotEmpty && depositAmount == null)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gültige Zahlen für Puffer/Anzahlung eingeben.')),
      );
      return;
    }

    final salonId = ref.read(identityProvider).currentSalonId;
    if (salonId == null || salonId.isEmpty) return;

    try {
      setState(() => _loading = true);
      final repository = ref.read(serviceRepositoryProvider);

      if (initial == null) {
        final created = await repository.createService(
          salonId: salonId,
          name: name,
          durationMinutes: duration,
          price: price,
          category: categoryController.text.trim().isEmpty ? null : categoryController.text.trim(),
          description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
          bufferBefore: bufferBefore,
          bufferAfter: bufferAfter,
          depositAmount: depositAmount,
        );
        setState(() {
          _services = [..._services, created]..sort((a, b) => a.name.compareTo(b.name));
        });
      } else {
        final updated = await repository.updateService(
          serviceId: initial.id,
          name: name,
          durationMinutes: duration,
          price: price,
          category: categoryController.text.trim().isEmpty ? null : categoryController.text.trim(),
          description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
          isActive: isActive,
          bufferBefore: bufferBefore,
          bufferAfter: bufferAfter,
          depositAmount: depositAmount,
        );
        setState(() {
          _services = _services
              .map((item) => item.id == updated.id ? updated : item)
              .toList()
            ..sort((a, b) => a.name.compareTo(b.name));
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(initial == null ? 'Dienstleistung hinzugefügt.' : 'Dienstleistung aktualisiert.'),
        ),
      );
      _loadServices(silent: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speichern fehlgeschlagen: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSalonId = ref.watch(
      identityProvider.select((value) => value.currentSalonId),
    );

    if (selectedSalonId != _activeSalonId) {
      _activeSalonId = selectedSalonId;
      if (selectedSalonId != null && selectedSalonId.isNotEmpty) {
        _bindRealtimeForSalon(selectedSalonId);
      } else {
        _servicesChannel?.unsubscribe();
        _servicesChannel = null;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadServices();
        }
      });
    }

    if (_loading && _services.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _services.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.alertCircle, color: Colors.red, size: 28),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _loadServices,
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadServices,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Dienstleistungen',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              FilledButton.icon(
                onPressed: _loading ? null : () => _openServiceDialog(),
                icon: const Icon(LucideIcons.plus, size: 16),
                label: const Text('Neu'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Verwaltung von verfügbaren Dienstleistungen und Preisen.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 16),
          if (_services.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Noch keine Dienstleistungen vorhanden.'),
              ),
            )
          else
            ..._services.map(
              (service) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              service.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          IconButton(
                            onPressed: _loading ? null : () => _openServiceDialog(initial: service),
                            icon: const Icon(LucideIcons.pencil, size: 18),
                            tooltip: 'Bearbeiten',
                          ),
                          IconButton(
                            onPressed: _loading ? null : () => _deleteService(service),
                            icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.red),
                            tooltip: 'Löschen',
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text('${service.durationMinutes} Min')),
                          Chip(label: Text('${service.price.toStringAsFixed(2)} €')),
                          if ((service.category ?? '').trim().isNotEmpty)
                            Chip(label: Text(service.category!.trim())),
                          if (service.bufferBefore != null)
                            Chip(label: Text('Puffer davor: ${service.bufferBefore} Min')),
                          if (service.bufferAfter != null)
                            Chip(label: Text('Puffer danach: ${service.bufferAfter} Min')),
                          if (service.depositAmount != null)
                            Chip(label: Text('Anzahlung: ${service.depositAmount!.toStringAsFixed(2)} €')),
                          Chip(
                            label: Text((service.isActive ?? true) ? 'Aktiv' : 'Inaktiv'),
                            backgroundColor: (service.isActive ?? true)
                                ? Colors.green.withValues(alpha: 0.12)
                                : Colors.grey.withValues(alpha: 0.2),
                          ),
                        ],
                      ),
                      if ((service.description ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(service.description!.trim()),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _servicesChannel?.unsubscribe();
    _servicesChannel = null;
    super.dispose();
  }
}
