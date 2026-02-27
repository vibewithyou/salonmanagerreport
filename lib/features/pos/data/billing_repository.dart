import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/supabase_service.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return BillingRepository(supabaseService.client);
});

class BillingRepository {
  BillingRepository(this._client);

  final SupabaseClient _client;

  Future<String?> resolveSalonId(String userId) async {
    final employee = await _client
        .from('employees')
        .select('salon_id')
        .eq('user_id', userId)
        .maybeSingle();

    final employeeSalonId = employee?['salon_id'] as String?;
    if (employeeSalonId != null && employeeSalonId.isNotEmpty) {
      return employeeSalonId;
    }

    final salon = await _client
        .from('salons')
        .select('id')
        .eq('owner_id', userId)
        .maybeSingle();

    return salon?['id'] as String?;
  }

  Future<List<POSCatalogItem>> fetchServices(String salonId) async {
    final rows = await _client
        .from('services')
        .select('id,name,price')
        .eq('salon_id', salonId)
        .order('name', ascending: true);

    return (rows as List)
        .map(
          (row) => POSCatalogItem(
            id: row['id'] as String,
            name: row['name'] as String? ?? 'Service',
            unitPrice: (row['price'] as num?)?.toDouble() ?? 0,
            type: POSItemType.service,
          ),
        )
        .toList();
  }

  Future<List<POSCatalogItem>> fetchProducts(String salonId) async {
    final rows = await _client
        .from('inventory_products')
        .select('id,name,price')
        .eq('salon_id', salonId)
        .order('name', ascending: true);

    return (rows as List)
        .map(
          (row) => POSCatalogItem(
            id: row['id'] as String,
            name: row['name'] as String? ?? 'Product',
            unitPrice: (row['price'] as num?)?.toDouble() ?? 0,
            type: POSItemType.product,
          ),
        )
        .toList();
  }

  Future<void> finalizeSale({
    required String salonId,
    required List<POSCartItem> items,
    required String paymentMethod,
    String? customerId,
    double taxRate = 0.19,
  }) async {
    if (items.isEmpty) {
      throw Exception('Cannot finalize empty cart.');
    }

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.unitPrice * item.quantity,
    );
    final tax = subtotal * taxRate;
    final total = subtotal + tax;

    final invoice = await _client
        .from('invoices')
        .insert({
          'salon_id': salonId,
          'number': 'TMP-${DateTime.now().millisecondsSinceEpoch}',
          'customer_id': customerId,
          'subtotal': subtotal,
          'tax': tax,
          'total': total,
          'status': 'paid',
        })
        .select('id')
        .single();

    final invoiceId = invoice['id'] as String;

    await _client.from('invoice_items').insert(
      items
          .map(
            (item) => {
              'invoice_id': invoiceId,
              'type': item.type.name,
              'ref_id': item.id,
              'qty': item.quantity,
              'unit_price': item.unitPrice,
              'tax_rate': taxRate,
              'total': (item.unitPrice * item.quantity) * (1 + taxRate),
            },
          )
          .toList(),
    );

    await _client.from('payments').insert({
      'invoice_id': invoiceId,
      'amount': total,
      'method': paymentMethod,
      'status': 'succeeded',
    });
  }
}

enum POSItemType { service, product }

class POSCatalogItem {
  const POSCatalogItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.type,
  });

  final String id;
  final String name;
  final double unitPrice;
  final POSItemType type;
}

class POSCartItem {
  const POSCartItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.type,
    required this.quantity,
  });

  final String id;
  final String name;
  final double unitPrice;
  final POSItemType type;
  final int quantity;

  POSCartItem copyWith({
    int? quantity,
  }) {
    return POSCartItem(
      id: id,
      name: name,
      unitPrice: unitPrice,
      type: type,
      quantity: quantity ?? this.quantity,
    );
  }
}
