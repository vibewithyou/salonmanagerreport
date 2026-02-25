// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$POSTransactionImpl _$$POSTransactionImplFromJson(Map<String, dynamic> json) =>
    _$POSTransactionImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      customerId: json['customerId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => POSItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$POSTransactionImplToJson(
  _$POSTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'salonId': instance.salonId,
  'customerId': instance.customerId,
  'amount': instance.amount,
  'paymentMethod': instance.paymentMethod,
  'status': instance.status,
  'items': instance.items,
  'createdAt': instance.createdAt?.toIso8601String(),
};

_$POSItemImpl _$$POSItemImplFromJson(Map<String, dynamic> json) =>
    _$POSItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$POSItemImplToJson(_$POSItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
    };
