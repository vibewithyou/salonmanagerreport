import 'package:supabase_flutter/supabase_flutter.dart';

class PosRepository {
  final SupabaseClient client;
  PosRepository(this.client);

  Future<int?> createInvoice({
    required int salonId,
    required int? customerId,
    required double subtotal,
    required double tax,
    required double total,
    required String status,
    required List<Map<String, dynamic>> items,
    required double paymentAmount,
    required String paymentMethod,
  }) async {
    // Insert invoice
    final invoiceResp = await client.from('invoices').insert({
      'salon_id': salonId,
      'number': DateTime.now().millisecondsSinceEpoch.toString(),
      'customer_id': customerId,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'status': status,
    }).select('id').single();
    final invoiceId = invoiceResp['id'] as int?;
    if (invoiceId == null) return null;

    // Insert items
    for (final item in items) {
      await client.from('invoice_items').insert({
        'invoice_id': invoiceId,
        'type': item['type'],
        'ref_id': item['ref_id'] ?? 0,
        'qty': item['qty'],
        'price': item['price'],
        'tax_rate': item['tax_rate'],
      });
    }

    // Insert payment
    await client.from('payments').insert({
      'invoice_id': invoiceId,
      'amount': paymentAmount,
      'method': paymentMethod,
      'status': 'paid',
    });
    return invoiceId;
  }
}
