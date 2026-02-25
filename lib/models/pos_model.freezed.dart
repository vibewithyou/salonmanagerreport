// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pos_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

POSTransaction _$POSTransactionFromJson(Map<String, dynamic> json) {
  return _POSTransaction.fromJson(json);
}

/// @nodoc
mixin _$POSTransaction {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get paymentMethod =>
      throw _privateConstructorUsedError; // cash, card, digital
  String get status =>
      throw _privateConstructorUsedError; // completed, pending, cancelled
  List<POSItem>? get items => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this POSTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of POSTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $POSTransactionCopyWith<POSTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $POSTransactionCopyWith<$Res> {
  factory $POSTransactionCopyWith(
    POSTransaction value,
    $Res Function(POSTransaction) then,
  ) = _$POSTransactionCopyWithImpl<$Res, POSTransaction>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String customerId,
    double amount,
    String paymentMethod,
    String status,
    List<POSItem>? items,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$POSTransactionCopyWithImpl<$Res, $Val extends POSTransaction>
    implements $POSTransactionCopyWith<$Res> {
  _$POSTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of POSTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? customerId = null,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? items = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            items: freezed == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<POSItem>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$POSTransactionImplCopyWith<$Res>
    implements $POSTransactionCopyWith<$Res> {
  factory _$$POSTransactionImplCopyWith(
    _$POSTransactionImpl value,
    $Res Function(_$POSTransactionImpl) then,
  ) = __$$POSTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String customerId,
    double amount,
    String paymentMethod,
    String status,
    List<POSItem>? items,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$POSTransactionImplCopyWithImpl<$Res>
    extends _$POSTransactionCopyWithImpl<$Res, _$POSTransactionImpl>
    implements _$$POSTransactionImplCopyWith<$Res> {
  __$$POSTransactionImplCopyWithImpl(
    _$POSTransactionImpl _value,
    $Res Function(_$POSTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of POSTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? customerId = null,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? items = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$POSTransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        items: freezed == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<POSItem>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$POSTransactionImpl implements _POSTransaction {
  const _$POSTransactionImpl({
    required this.id,
    required this.salonId,
    required this.customerId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    final List<POSItem>? items,
    this.createdAt,
  }) : _items = items;

  factory _$POSTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$POSTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String customerId;
  @override
  final double amount;
  @override
  final String paymentMethod;
  // cash, card, digital
  @override
  final String status;
  // completed, pending, cancelled
  final List<POSItem>? _items;
  // completed, pending, cancelled
  @override
  List<POSItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'POSTransaction(id: $id, salonId: $salonId, customerId: $customerId, amount: $amount, paymentMethod: $paymentMethod, status: $status, items: $items, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$POSTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    customerId,
    amount,
    paymentMethod,
    status,
    const DeepCollectionEquality().hash(_items),
    createdAt,
  );

  /// Create a copy of POSTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$POSTransactionImplCopyWith<_$POSTransactionImpl> get copyWith =>
      __$$POSTransactionImplCopyWithImpl<_$POSTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$POSTransactionImplToJson(this);
  }
}

abstract class _POSTransaction implements POSTransaction {
  const factory _POSTransaction({
    required final String id,
    required final String salonId,
    required final String customerId,
    required final double amount,
    required final String paymentMethod,
    required final String status,
    final List<POSItem>? items,
    final DateTime? createdAt,
  }) = _$POSTransactionImpl;

  factory _POSTransaction.fromJson(Map<String, dynamic> json) =
      _$POSTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get customerId;
  @override
  double get amount;
  @override
  String get paymentMethod; // cash, card, digital
  @override
  String get status; // completed, pending, cancelled
  @override
  List<POSItem>? get items;
  @override
  DateTime? get createdAt;

  /// Create a copy of POSTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$POSTransactionImplCopyWith<_$POSTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

POSItem _$POSItemFromJson(Map<String, dynamic> json) {
  return _POSItem.fromJson(json);
}

/// @nodoc
mixin _$POSItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Serializes this POSItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of POSItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $POSItemCopyWith<POSItem> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $POSItemCopyWith<$Res> {
  factory $POSItemCopyWith(POSItem value, $Res Function(POSItem) then) =
      _$POSItemCopyWithImpl<$Res, POSItem>;
  @useResult
  $Res call({String id, String name, int quantity, double price});
}

/// @nodoc
class _$POSItemCopyWithImpl<$Res, $Val extends POSItem>
    implements $POSItemCopyWith<$Res> {
  _$POSItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of POSItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$POSItemImplCopyWith<$Res> implements $POSItemCopyWith<$Res> {
  factory _$$POSItemImplCopyWith(
    _$POSItemImpl value,
    $Res Function(_$POSItemImpl) then,
  ) = __$$POSItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int quantity, double price});
}

/// @nodoc
class __$$POSItemImplCopyWithImpl<$Res>
    extends _$POSItemCopyWithImpl<$Res, _$POSItemImpl>
    implements _$$POSItemImplCopyWith<$Res> {
  __$$POSItemImplCopyWithImpl(
    _$POSItemImpl _value,
    $Res Function(_$POSItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of POSItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(
      _$POSItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$POSItemImpl implements _POSItem {
  const _$POSItemImpl({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory _$POSItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$POSItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final double price;

  @override
  String toString() {
    return 'POSItem(id: $id, name: $name, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$POSItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, price);

  /// Create a copy of POSItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$POSItemImplCopyWith<_$POSItemImpl> get copyWith =>
      __$$POSItemImplCopyWithImpl<_$POSItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$POSItemImplToJson(this);
  }
}

abstract class _POSItem implements POSItem {
  const factory _POSItem({
    required final String id,
    required final String name,
    required final int quantity,
    required final double price,
  }) = _$POSItemImpl;

  factory _POSItem.fromJson(Map<String, dynamic> json) = _$POSItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get quantity;
  @override
  double get price;

  /// Create a copy of POSItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$POSItemImplCopyWith<_$POSItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
