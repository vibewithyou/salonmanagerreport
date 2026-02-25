// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      totalVisits: (json['totalVisits'] as num?)?.toInt(),
      totalSpent: (json['totalSpent'] as num?)?.toDouble(),
      lastVisit: json['lastVisit'] == null
          ? null
          : DateTime.parse(json['lastVisit'] as String),
      preferredStylist: json['preferredStylist'] as String?,
      preferredServices: (json['preferredServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isVIP: json['isVIP'] as bool?,
      birthDate: json['birthDate'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'notes': instance.notes,
      'totalVisits': instance.totalVisits,
      'totalSpent': instance.totalSpent,
      'lastVisit': instance.lastVisit?.toIso8601String(),
      'preferredStylist': instance.preferredStylist,
      'preferredServices': instance.preferredServices,
      'isVIP': instance.isVIP,
      'birthDate': instance.birthDate,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CustomerSummaryImpl _$$CustomerSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerSummaryImpl(
  totalCustomers: (json['totalCustomers'] as num).toInt(),
  vipCustomers: (json['vipCustomers'] as num).toInt(),
  newCustomersThisMonth: (json['newCustomersThisMonth'] as num).toInt(),
  avgVisitsPerCustomer: (json['avgVisitsPerCustomer'] as num).toDouble(),
  avgMonthlySpend: (json['avgMonthlySpend'] as num).toDouble(),
);

Map<String, dynamic> _$$CustomerSummaryImplToJson(
  _$CustomerSummaryImpl instance,
) => <String, dynamic>{
  'totalCustomers': instance.totalCustomers,
  'vipCustomers': instance.vipCustomers,
  'newCustomersThisMonth': instance.newCustomersThisMonth,
  'avgVisitsPerCustomer': instance.avgVisitsPerCustomer,
  'avgMonthlySpend': instance.avgMonthlySpend,
};

_$CustomerTransactionImpl _$$CustomerTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerTransactionImpl(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  salonId: json['salonId'] as String,
  amount: (json['amount'] as num).toDouble(),
  type: json['type'] as String,
  description: json['description'] as String,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CustomerTransactionImplToJson(
  _$CustomerTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'customerId': instance.customerId,
  'salonId': instance.salonId,
  'amount': instance.amount,
  'type': instance.type,
  'description': instance.description,
  'date': instance.date?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
