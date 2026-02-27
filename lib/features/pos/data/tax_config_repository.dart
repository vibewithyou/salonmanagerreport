import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

final taxConfigRepositoryProvider = Provider<TaxConfigRepository>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return TaxConfigRepository(supabase.client);
});

class TaxConfigRepository {
  TaxConfigRepository(this._client);

  final SupabaseClient _client;

  Future<SalonTaxConfig> getTaxConfig(
    String salonId, {
    List<String> productIds = const [],
  }) async {
    final configRow = await _client
        .from('salon_tax_config')
        .select('default_rate,reduced_rate')
        .eq('salon_id', salonId)
        .maybeSingle();

    final defaultRate =
        (configRow?['default_rate'] as num?)?.toDouble() ?? 0.19;
    final reducedRate =
        (configRow?['reduced_rate'] as num?)?.toDouble() ?? 0.07;

    Map<String, double> overrides = {};
    if (productIds.isNotEmpty) {
      final rows = await _client
          .from('product_tax_overrides')
          .select('product_id,tax_rate')
          .inFilter('product_id', productIds);

      overrides = {
        for (final row in rows)
          row['product_id'] as String: (row['tax_rate'] as num).toDouble(),
      };
    }

    return SalonTaxConfig(
      defaultRate: defaultRate,
      reducedRate: reducedRate,
      productOverrides: overrides,
    );
  }
}

class SalonTaxConfig {
  const SalonTaxConfig({
    required this.defaultRate,
    required this.reducedRate,
    this.productOverrides = const {},
  });

  final double defaultRate;
  final double reducedRate;
  final Map<String, double> productOverrides;

  double resolveTaxRate(String productId) {
    return productOverrides[productId] ?? defaultRate;
  }
}
