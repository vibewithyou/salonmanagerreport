import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String salonId,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    String? address,
    String? notes,
    int? totalVisits,
    double? totalSpent,
    DateTime? lastVisit,
    String? preferredStylist,
    List<String>? preferredServices,
    bool? isVIP,
    String? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}

@freezed
class CustomerSummary with _$CustomerSummary {
  const factory CustomerSummary({
    required int totalCustomers,
    required int vipCustomers,
    required int newCustomersThisMonth,
    required double avgVisitsPerCustomer,
    required double avgMonthlySpend,
  }) = _CustomerSummary;

  factory CustomerSummary.fromJson(Map<String, dynamic> json) => _$CustomerSummaryFromJson(json);
}

@freezed
class CustomerTransaction with _$CustomerTransaction {
  const factory CustomerTransaction({
    required String id,
    required String customerId,
    required String salonId,
    required double amount,
    required String type, // booking, product, service
    required String description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CustomerTransaction;

  factory CustomerTransaction.fromJson(Map<String, dynamic> json) => _$CustomerTransactionFromJson(json);
}
