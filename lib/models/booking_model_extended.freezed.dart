// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model_extended.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingData _$BookingDataFromJson(Map<String, dynamic> json) {
  return _BookingData.fromJson(json);
}

/// @nodoc
mixin _$BookingData {
  String? get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  String get stylistId => throw _privateConstructorUsedError;
  DateTime get appointmentDate => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, confirmed, completed, cancelled
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get reminderSentAt => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  String? get feedback => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BookingData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingDataCopyWith<BookingData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingDataCopyWith<$Res> {
  factory $BookingDataCopyWith(
    BookingData value,
    $Res Function(BookingData) then,
  ) = _$BookingDataCopyWithImpl<$Res, BookingData>;
  @useResult
  $Res call({
    String? id,
    String salonId,
    String customerId,
    String serviceId,
    String stylistId,
    DateTime appointmentDate,
    int durationMinutes,
    double totalPrice,
    String status,
    String? notes,
    DateTime? reminderSentAt,
    double? rating,
    String? feedback,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$BookingDataCopyWithImpl<$Res, $Val extends BookingData>
    implements $BookingDataCopyWith<$Res> {
  _$BookingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? salonId = null,
    Object? customerId = null,
    Object? serviceId = null,
    Object? stylistId = null,
    Object? appointmentDate = null,
    Object? durationMinutes = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? notes = freezed,
    Object? reminderSentAt = freezed,
    Object? rating = freezed,
    Object? feedback = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            serviceId: null == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            stylistId: null == stylistId
                ? _value.stylistId
                : stylistId // ignore: cast_nullable_to_non_nullable
                      as String,
            appointmentDate: null == appointmentDate
                ? _value.appointmentDate
                : appointmentDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            reminderSentAt: freezed == reminderSentAt
                ? _value.reminderSentAt
                : reminderSentAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            feedback: freezed == feedback
                ? _value.feedback
                : feedback // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingDataImplCopyWith<$Res>
    implements $BookingDataCopyWith<$Res> {
  factory _$$BookingDataImplCopyWith(
    _$BookingDataImpl value,
    $Res Function(_$BookingDataImpl) then,
  ) = __$$BookingDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String salonId,
    String customerId,
    String serviceId,
    String stylistId,
    DateTime appointmentDate,
    int durationMinutes,
    double totalPrice,
    String status,
    String? notes,
    DateTime? reminderSentAt,
    double? rating,
    String? feedback,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$BookingDataImplCopyWithImpl<$Res>
    extends _$BookingDataCopyWithImpl<$Res, _$BookingDataImpl>
    implements _$$BookingDataImplCopyWith<$Res> {
  __$$BookingDataImplCopyWithImpl(
    _$BookingDataImpl _value,
    $Res Function(_$BookingDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? salonId = null,
    Object? customerId = null,
    Object? serviceId = null,
    Object? stylistId = null,
    Object? appointmentDate = null,
    Object? durationMinutes = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? notes = freezed,
    Object? reminderSentAt = freezed,
    Object? rating = freezed,
    Object? feedback = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$BookingDataImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceId: null == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        stylistId: null == stylistId
            ? _value.stylistId
            : stylistId // ignore: cast_nullable_to_non_nullable
                  as String,
        appointmentDate: null == appointmentDate
            ? _value.appointmentDate
            : appointmentDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminderSentAt: freezed == reminderSentAt
            ? _value.reminderSentAt
            : reminderSentAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        feedback: freezed == feedback
            ? _value.feedback
            : feedback // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingDataImpl implements _BookingData {
  const _$BookingDataImpl({
    this.id,
    required this.salonId,
    required this.customerId,
    required this.serviceId,
    required this.stylistId,
    required this.appointmentDate,
    required this.durationMinutes,
    required this.totalPrice,
    required this.status,
    this.notes,
    this.reminderSentAt,
    this.rating,
    this.feedback,
    this.createdAt,
    this.updatedAt,
  });

  factory _$BookingDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingDataImplFromJson(json);

  @override
  final String? id;
  @override
  final String salonId;
  @override
  final String customerId;
  @override
  final String serviceId;
  @override
  final String stylistId;
  @override
  final DateTime appointmentDate;
  @override
  final int durationMinutes;
  @override
  final double totalPrice;
  @override
  final String status;
  // pending, confirmed, completed, cancelled
  @override
  final String? notes;
  @override
  final DateTime? reminderSentAt;
  @override
  final double? rating;
  @override
  final String? feedback;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BookingData(id: $id, salonId: $salonId, customerId: $customerId, serviceId: $serviceId, stylistId: $stylistId, appointmentDate: $appointmentDate, durationMinutes: $durationMinutes, totalPrice: $totalPrice, status: $status, notes: $notes, reminderSentAt: $reminderSentAt, rating: $rating, feedback: $feedback, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.stylistId, stylistId) ||
                other.stylistId == stylistId) &&
            (identical(other.appointmentDate, appointmentDate) ||
                other.appointmentDate == appointmentDate) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.reminderSentAt, reminderSentAt) ||
                other.reminderSentAt == reminderSentAt) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    customerId,
    serviceId,
    stylistId,
    appointmentDate,
    durationMinutes,
    totalPrice,
    status,
    notes,
    reminderSentAt,
    rating,
    feedback,
    createdAt,
    updatedAt,
  );

  /// Create a copy of BookingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingDataImplCopyWith<_$BookingDataImpl> get copyWith =>
      __$$BookingDataImplCopyWithImpl<_$BookingDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingDataImplToJson(this);
  }
}

abstract class _BookingData implements BookingData {
  const factory _BookingData({
    final String? id,
    required final String salonId,
    required final String customerId,
    required final String serviceId,
    required final String stylistId,
    required final DateTime appointmentDate,
    required final int durationMinutes,
    required final double totalPrice,
    required final String status,
    final String? notes,
    final DateTime? reminderSentAt,
    final double? rating,
    final String? feedback,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$BookingDataImpl;

  factory _BookingData.fromJson(Map<String, dynamic> json) =
      _$BookingDataImpl.fromJson;

  @override
  String? get id;
  @override
  String get salonId;
  @override
  String get customerId;
  @override
  String get serviceId;
  @override
  String get stylistId;
  @override
  DateTime get appointmentDate;
  @override
  int get durationMinutes;
  @override
  double get totalPrice;
  @override
  String get status; // pending, confirmed, completed, cancelled
  @override
  String? get notes;
  @override
  DateTime? get reminderSentAt;
  @override
  double? get rating;
  @override
  String? get feedback;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of BookingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingDataImplCopyWith<_$BookingDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalonService _$SalonServiceFromJson(Map<String, dynamic> json) {
  return _SalonService.fromJson(json);
}

/// @nodoc
mixin _$SalonService {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SalonService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonServiceCopyWith<SalonService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonServiceCopyWith<$Res> {
  factory $SalonServiceCopyWith(
    SalonService value,
    $Res Function(SalonService) then,
  ) = _$SalonServiceCopyWithImpl<$Res, SalonService>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String? description,
    double price,
    int durationMinutes,
    String? category,
    bool? isActive,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$SalonServiceCopyWithImpl<$Res, $Val extends SalonService>
    implements $SalonServiceCopyWith<$Res> {
  _$SalonServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? durationMinutes = null,
    Object? category = freezed,
    Object? isActive = freezed,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
abstract class _$$SalonServiceImplCopyWith<$Res>
    implements $SalonServiceCopyWith<$Res> {
  factory _$$SalonServiceImplCopyWith(
    _$SalonServiceImpl value,
    $Res Function(_$SalonServiceImpl) then,
  ) = __$$SalonServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String? description,
    double price,
    int durationMinutes,
    String? category,
    bool? isActive,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$SalonServiceImplCopyWithImpl<$Res>
    extends _$SalonServiceCopyWithImpl<$Res, _$SalonServiceImpl>
    implements _$$SalonServiceImplCopyWith<$Res> {
  __$$SalonServiceImplCopyWithImpl(
    _$SalonServiceImpl _value,
    $Res Function(_$SalonServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? durationMinutes = null,
    Object? category = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SalonServiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: freezed == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
class _$SalonServiceImpl implements _SalonService {
  const _$SalonServiceImpl({
    required this.id,
    required this.salonId,
    required this.name,
    this.description,
    required this.price,
    required this.durationMinutes,
    this.category,
    this.isActive,
    this.createdAt,
  });

  factory _$SalonServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  final int durationMinutes;
  @override
  final String? category;
  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SalonService(id: $id, salonId: $salonId, name: $name, description: $description, price: $price, durationMinutes: $durationMinutes, category: $category, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    name,
    description,
    price,
    durationMinutes,
    category,
    isActive,
    createdAt,
  );

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonServiceImplCopyWith<_$SalonServiceImpl> get copyWith =>
      __$$SalonServiceImplCopyWithImpl<_$SalonServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonServiceImplToJson(this);
  }
}

abstract class _SalonService implements SalonService {
  const factory _SalonService({
    required final String id,
    required final String salonId,
    required final String name,
    final String? description,
    required final double price,
    required final int durationMinutes,
    final String? category,
    final bool? isActive,
    final DateTime? createdAt,
  }) = _$SalonServiceImpl;

  factory _SalonService.fromJson(Map<String, dynamic> json) =
      _$SalonServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  int get durationMinutes;
  @override
  String? get category;
  @override
  bool? get isActive;
  @override
  DateTime? get createdAt;

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonServiceImplCopyWith<_$SalonServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Stylist _$StylistFromJson(Map<String, dynamic> json) {
  return _Stylist.fromJson(json);
}

/// @nodoc
mixin _$Stylist {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  List<String> get specialties => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Stylist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StylistCopyWith<Stylist> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StylistCopyWith<$Res> {
  factory $StylistCopyWith(Stylist value, $Res Function(Stylist) then) =
      _$StylistCopyWithImpl<$Res, Stylist>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String? email,
    String? phone,
    String? avatar,
    List<String> specialties,
    bool? isActive,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$StylistCopyWithImpl<$Res, $Val extends Stylist>
    implements $StylistCopyWith<$Res> {
  _$StylistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatar = freezed,
    Object? specialties = null,
    Object? isActive = freezed,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            specialties: null == specialties
                ? _value.specialties
                : specialties // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isActive: freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
abstract class _$$StylistImplCopyWith<$Res> implements $StylistCopyWith<$Res> {
  factory _$$StylistImplCopyWith(
    _$StylistImpl value,
    $Res Function(_$StylistImpl) then,
  ) = __$$StylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String? email,
    String? phone,
    String? avatar,
    List<String> specialties,
    bool? isActive,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$StylistImplCopyWithImpl<$Res>
    extends _$StylistCopyWithImpl<$Res, _$StylistImpl>
    implements _$$StylistImplCopyWith<$Res> {
  __$$StylistImplCopyWithImpl(
    _$StylistImpl _value,
    $Res Function(_$StylistImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatar = freezed,
    Object? specialties = null,
    Object? isActive = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$StylistImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        specialties: null == specialties
            ? _value._specialties
            : specialties // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isActive: freezed == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
class _$StylistImpl implements _Stylist {
  const _$StylistImpl({
    required this.id,
    required this.salonId,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    final List<String> specialties = const [],
    this.isActive,
    this.createdAt,
  }) : _specialties = specialties;

  factory _$StylistImpl.fromJson(Map<String, dynamic> json) =>
      _$$StylistImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? avatar;
  final List<String> _specialties;
  @override
  @JsonKey()
  List<String> get specialties {
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialties);
  }

  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Stylist(id: $id, salonId: $salonId, name: $name, email: $email, phone: $phone, avatar: $avatar, specialties: $specialties, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StylistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            const DeepCollectionEquality().equals(
              other._specialties,
              _specialties,
            ) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    name,
    email,
    phone,
    avatar,
    const DeepCollectionEquality().hash(_specialties),
    isActive,
    createdAt,
  );

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StylistImplCopyWith<_$StylistImpl> get copyWith =>
      __$$StylistImplCopyWithImpl<_$StylistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StylistImplToJson(this);
  }
}

abstract class _Stylist implements Stylist {
  const factory _Stylist({
    required final String id,
    required final String salonId,
    required final String name,
    final String? email,
    final String? phone,
    final String? avatar,
    final List<String> specialties,
    final bool? isActive,
    final DateTime? createdAt,
  }) = _$StylistImpl;

  factory _Stylist.fromJson(Map<String, dynamic> json) = _$StylistImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get avatar;
  @override
  List<String> get specialties;
  @override
  bool? get isActive;
  @override
  DateTime? get createdAt;

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StylistImplCopyWith<_$StylistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

/// @nodoc
mixin _$Customer {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerCopyWith<Customer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) then) =
      _$CustomerCopyWithImpl<$Res, Customer>;
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String? email,
    String? phone,
    String? avatar,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$CustomerCopyWithImpl<$Res, $Val extends Customer>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatar = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$CustomerImplCopyWith<$Res>
    implements $CustomerCopyWith<$Res> {
  factory _$$CustomerImplCopyWith(
    _$CustomerImpl value,
    $Res Function(_$CustomerImpl) then,
  ) = __$$CustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String? email,
    String? phone,
    String? avatar,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$CustomerImplCopyWithImpl<$Res>
    extends _$CustomerCopyWithImpl<$Res, _$CustomerImpl>
    implements _$$CustomerImplCopyWith<$Res> {
  __$$CustomerImplCopyWithImpl(
    _$CustomerImpl _value,
    $Res Function(_$CustomerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatar = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$CustomerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$CustomerImpl implements _Customer {
  const _$CustomerImpl({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.avatar,
    this.createdAt,
  });

  factory _$CustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? avatar;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Customer(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, avatar: $avatar, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    email,
    phone,
    avatar,
    createdAt,
  );

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      __$$CustomerImplCopyWithImpl<_$CustomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerImplToJson(this);
  }
}

abstract class _Customer implements Customer {
  const factory _Customer({
    required final String id,
    required final String firstName,
    required final String lastName,
    final String? email,
    final String? phone,
    final String? avatar,
    final DateTime? createdAt,
  }) = _$CustomerImpl;

  factory _Customer.fromJson(Map<String, dynamic> json) =
      _$CustomerImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get avatar;
  @override
  DateTime? get createdAt;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
