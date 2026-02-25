import 'package:freezed_annotation/freezed_annotation.dart';

part 'pos_model.freezed.dart';
part 'pos_model.g.dart';

@freezed
class POSTransaction with _$POSTransaction {
  const factory POSTransaction({
    required String id,
    required String salonId,
    required String customerId,
    required double amount,
    required String paymentMethod, // cash, card, digital
    required String status, // completed, pending, cancelled
    List<POSItem>? items,
    DateTime? createdAt,
  }) = _POSTransaction;

  factory POSTransaction.fromJson(Map<String, dynamic> json) => _$POSTransactionFromJson(json);
}

@freezed
class POSItem with _$POSItem {
  const factory POSItem({
    required String id,
    required String name,
    required int quantity,
    required double price,
  }) = _POSItem;

  factory POSItem.fromJson(Map<String, dynamic> json) => _$POSItemFromJson(json);
}
