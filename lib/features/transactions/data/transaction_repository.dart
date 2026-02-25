import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

/// Transaction repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return TransactionRepository(supabaseService.client);
});

/// Repository for transaction/POS operations
class TransactionRepository {
  final SupabaseClient _client;

  TransactionRepository(this._client);

  /// Create a transaction
  Future<TransactionData> createTransaction({
    required String salonId,
    required String? customerId,
    required String? employeeId,
    required double amount,
    required String type, // 'appointment', 'service', 'product', 'charge'
    String? status,
    Map<String, dynamic>? metadata,
    List<TransactionItem>? items,
  }) async {
    try {
      final data = await _client.from('transactions').insert({
        'salon_id': salonId,
        'customer_profile_id': customerId,
        'employee_id': employeeId,
        'amount': amount,
        'type': type,
        'status': status ?? 'completed',
        'metadata': metadata,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      final transactionId = data['id'] as String;

      // Insert transaction items if provided
      if (items != null && items.isNotEmpty) {
        for (final item in items) {
          await _client.from('transaction_items').insert({
            'transaction_id': transactionId,
            'service_id': item.serviceId,
            'description': item.description,
            'price': item.price,
            'quantity': item.quantity ?? 1,
          });
        }
      }

      return TransactionData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  /// Get transaction by ID
  Future<TransactionData?> getTransactionById(String transactionId) async {
    try {
      final data = await _client
          .from('transactions')
          .select()
          .eq('id', transactionId)
          .maybeSingle();

      if (data == null) return null;

      return TransactionData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch transaction: $e');
    }
  }

  /// Get transactions for salon
  Future<List<TransactionData>> getSalonTransactions({
    required String salonId,
    DateTime? fromDate,
    DateTime? toDate,
    String? status,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      var query = _client
          .from('transactions')
          .select()
          .eq('salon_id', salonId);

      if (status != null) {
        query = query.eq('status', status);
      }

      if (fromDate != null) {
        query = query.gte('created_at', fromDate.toIso8601String());
      }

      if (toDate != null) {
        query = query.lte('created_at', toDate.toIso8601String());
      }

      final data = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (data as List)
          .map((json) => TransactionData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  /// Create invoice from transaction
  Future<InvoiceData> createInvoice({
    required String salonId,
    required String transactionId,
    required String customerId,
    double? tax,
    double? discount,
  }) async {
    try {
      // Get transaction to get amount
      final transaction = await getTransactionById(transactionId);
      if (transaction == null) {
        throw Exception('Transaction not found');
      }

      final totalAmount = transaction.amount;
      final taxAmount = tax ?? 0.0;
      final discountAmount = discount ?? 0.0;

      final data = await _client.from('invoices').insert({
        'salon_id': salonId,
        'transaction_id': transactionId,
        'customer_profile_id': customerId,
        'total_amount': totalAmount,
        'tax': taxAmount,
        'discount': discountAmount,
        'invoice_number': 'INV-${DateTime.now().millisecondsSinceEpoch}',
      }).select().single();

      return InvoiceData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create invoice: $e');
    }
  }

  /// Get invoices for salon
  Future<List<InvoiceData>> getSalonInvoices({
    required String salonId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final data = await _client
          .from('invoices')
          .select()
          .eq('salon_id', salonId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (data as List)
          .map((json) => InvoiceData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch invoices: $e');
    }
  }

  /// Get transaction revenue summary
  Future<RevenueSummary> getRevenueSummary({
    required String salonId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final data = await _client
          .from('transactions')
          .select()
          .eq('salon_id', salonId)
          .eq('status', 'completed')
          .gte('created_at', fromDate.toIso8601String())
          .lte('created_at', toDate.toIso8601String());

      double totalRevenue = 0.0;
      int transactionCount = 0;

      for (final transaction in (data as List)) {
        totalRevenue += (transaction['amount'] as num).toDouble();
        transactionCount++;
      }

      return RevenueSummary(
        totalRevenue: totalRevenue,
        transactionCount: transactionCount,
        averageTransaction: transactionCount > 0 ? totalRevenue / transactionCount : 0.0,
      );
    } catch (e) {
      throw Exception('Failed to fetch revenue summary: $e');
    }
  }
}

/// Transaction data model
class TransactionData {
  final String id;
  final String salonId;
  final String? customerId;
  final String? employeeId;
  final double amount;
  final String type;
  final String status;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  TransactionData({
    required this.id,
    required this.salonId,
    this.customerId,
    this.employeeId,
    required this.amount,
    required this.type,
    required this.status,
    this.metadata,
    required this.createdAt,
  });

  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      customerId: json['customer_profile_id'] as String?,
      employeeId: json['employee_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String? ?? 'service',
      status: json['status'] as String? ?? 'completed',
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Transaction item model
class TransactionItem {
  final String? serviceId;
  final String? description;
  final double price;
  final int? quantity;

  TransactionItem({
    this.serviceId,
    this.description,
    required this.price,
    this.quantity,
  });
}

/// Invoice data model
class InvoiceData {
  final String id;
  final String salonId;
  final String transactionId;
  final String customerId;
  final String invoiceNumber;
  final double totalAmount;
  final double? tax;
  final double? discount;
  final DateTime createdAt;

  InvoiceData({
    required this.id,
    required this.salonId,
    required this.transactionId,
    required this.customerId,
    required this.invoiceNumber,
    required this.totalAmount,
    this.tax,
    this.discount,
    required this.createdAt,
  });

  double get netAmount => totalAmount - (discount ?? 0.0) + (tax ?? 0.0);

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      transactionId: json['transaction_id'] as String? ?? '',
      customerId: json['customer_profile_id'] as String? ?? '',
      invoiceNumber: json['invoice_number'] as String? ?? '',
      totalAmount: (json['total_amount'] as num).toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Revenue summary model
class RevenueSummary {
  final double totalRevenue;
  final int transactionCount;
  final double averageTransaction;

  RevenueSummary({
    required this.totalRevenue,
    required this.transactionCount,
    required this.averageTransaction,
  });
}
