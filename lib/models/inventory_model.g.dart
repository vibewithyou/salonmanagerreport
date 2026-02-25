// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemImpl _$$InventoryItemImplFromJson(Map<String, dynamic> json) =>
    _$InventoryItemImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String?,
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt(),
      lastRestocked: json['lastRestocked'] == null
          ? null
          : DateTime.parse(json['lastRestocked'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$InventoryItemImplToJson(_$InventoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
      'category': instance.category,
      'lowStockThreshold': instance.lowStockThreshold,
      'lastRestocked': instance.lastRestocked?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
