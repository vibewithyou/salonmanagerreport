import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

/// Inventory repository provider
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return InventoryRepository(supabaseService.client);
});

/// Repository for inventory operations
class InventoryRepository {
  final SupabaseClient _client;

  InventoryRepository(this._client);

  /// Get all inventory items for a salon
  Future<List<InventoryItem>> getSalonInventory(String salonId) async {
    try {
      final data = await _client
          .from('inventory')
          .select()
          .eq('salon_id', salonId);

      return (data as List)
          .map((json) => InventoryItem.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch inventory: $e');
    }
  }

  /// Get all inventory items for a salon (alias for getSalonInventory)
  Future<List<dynamic>> getInventory(String salonId) async {
    try {
      final data = await _client
          .from('inventory')
          .select()
          .eq('salon_id', salonId);

      return data as List;
    } catch (e) {
      throw Exception('Failed to fetch inventory: $e');
    }
  }

  /// Get low stock items
  Future<List<InventoryItem>> getLowStockItems(String salonId) async {
    try {
      final data = await _client
          .from('inventory')
          .select()
          .eq('salon_id', salonId);

      final items = (data as List)
          .map((json) => InventoryItem.fromJson(json))
          .toList();

      // Filter items where quantity <= reorder_level
      return items.where((item) {
        if (item.reorderLevel == null) return false;
        return item.quantity <= item.reorderLevel!;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch low stock items: $e');
    }
  }

  /// Get low inventory items with threshold
  Future<List<dynamic>> getLowInventoryItems(String salonId, {int threshold = 5}) async {
    try {
      final data = await _client
          .from('inventory')
          .select()
          .eq('salon_id', salonId)
          .lte('quantity', threshold);

      return data as List;
    } catch (e) {
      throw Exception('Failed to fetch low inventory items: $e');
    }
  }

  /// Create inventory item
  Future<InventoryItem> createItem({
    required String salonId,
    required String productName,
    required int quantity,
    required double unitPrice,
    String? supplierId,
    int? reorderLevel,
    String? description,
  }) async {
    try {
      final data = await _client.from('inventory').insert({
        'salon_id': salonId,
        'product_name': productName,
        'quantity': quantity,
        'unit_price': unitPrice,
        'supplier_id': supplierId,
        'reorder_level': reorderLevel,
        'description': description,
      }).select().single();

      return InventoryItem.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create inventory item: $e');
    }
  }

  /// Update inventory quantity
  Future<void> updateQuantity({
    required String inventoryId,
    required int newQuantity,
  }) async {
    try {
      await _client
          .from('inventory')
          .update({'quantity': newQuantity})
          .eq('id', inventoryId);
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }

  /// Add inventory transaction (adjust stock)
  Future<InventoryTransaction> addTransaction({
    required String inventoryId,
    required int quantity,
    required String transactionType, // 'in', 'out', 'adjustment'
    required String reason,
    String? notes,
    String? userId,
  }) async {
    try {
      // First, get inventory to update quantity
      final inventory = await _client
          .from('inventory')
          .select()
          .eq('id', inventoryId)
          .single();

      final currentQty = inventory['quantity'] as int;
      int newQty = currentQty;

      if (transactionType == 'in') {
        newQty = currentQty + quantity;
      } else if (transactionType == 'out') {
        newQty = currentQty - quantity;
      } else if (transactionType == 'adjustment') {
        newQty = quantity; // Set to exact value for adjustments
      }

      // Update inventory quantity
      await _client
          .from('inventory')
          .update({'quantity': newQty})
          .eq('id', inventoryId);

      // Create transaction record
      final data = await _client.from('inventory_transactions').insert({
        'inventory_id': inventoryId,
        'transaction_type': transactionType,
        'quantity': quantity,
        'reason': reason,
        'notes': notes,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      return InventoryTransaction.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  /// Get inventory transactions
  Future<List<InventoryTransaction>> getTransactions({
    required String inventoryId,
    int limit = 100,
  }) async {
    try {
      final data = await _client
          .from('inventory_transactions')
          .select()
          .eq('inventory_id', inventoryId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (data as List)
          .map((json) => InventoryTransaction.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  /// Get suppliers for salon
  Future<List<Supplier>> getSalonSuppliers(String salonId) async {
    try {
      final data = await _client
          .from('suppliers')
          .select()
          .eq('salon_id', salonId);

      return (data as List)
          .map((json) => Supplier.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch suppliers: $e');
    }
  }

  /// Create supplier
  Future<Supplier> createSupplier({
    required String salonId,
    required String name,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
  }) async {
    try {
      final data = await _client.from('suppliers').insert({
        'salon_id': salonId,
        'name': name,
        'contact_person': contactPerson,
        'phone': phone,
        'email': email,
        'address': address,
      }).select().single();

      return Supplier.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create supplier: $e');
    }
  }

  /// Get inventory value (total cost of all items)
  Future<double> getInventoryValue(String salonId) async {
    try {
      final data = await _client
          .from('inventory')
          .select()
          .eq('salon_id', salonId);

      double totalValue = 0.0;
      for (final item in (data as List)) {
        final qty = item['quantity'] as int;
        final price = (item['unit_price'] as num).toDouble();
        totalValue += qty * price;
      }

      return totalValue;
    } catch (e) {
      throw Exception('Failed to calculate inventory value: $e');
    }
  }
}

/// Inventory item model
class InventoryItem {
  final String id;
  final String salonId;
  final String? supplierId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final int? reorderLevel;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  InventoryItem({
    required this.id,
    required this.salonId,
    this.supplierId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.reorderLevel,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  double get totalValue => quantity * unitPrice;
  bool get isLowStock => reorderLevel != null && quantity <= reorderLevel!;

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      supplierId: json['supplier_id'] as String?,
      productName: json['product_name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      reorderLevel: json['reorder_level'] as int?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
}

/// Inventory transaction model
class InventoryTransaction {
  final String id;
  final String inventoryId;
  final String transactionType;
  final int quantity;
  final String reason;
  final String? notes;
  final String? userId;
  final DateTime createdAt;

  InventoryTransaction({
    required this.id,
    required this.inventoryId,
    required this.transactionType,
    required this.quantity,
    required this.reason,
    this.notes,
    this.userId,
    required this.createdAt,
  });

  bool get isInbound => transactionType == 'in';
  bool get isOutbound => transactionType == 'out';
  bool get isAdjustment => transactionType == 'adjustment';

  factory InventoryTransaction.fromJson(Map<String, dynamic> json) {
    return InventoryTransaction(
      id: json['id'] as String,
      inventoryId: json['inventory_id'] as String? ?? '',
      transactionType: json['transaction_type'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      reason: json['reason'] as String? ?? '',
      notes: json['notes'] as String?,
      userId: json['user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}

/// Supplier model
class Supplier {
  final String id;
  final String salonId;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final DateTime createdAt;

  Supplier({
    required this.id,
    required this.salonId,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    required this.createdAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      contactPerson: json['contact_person'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}
