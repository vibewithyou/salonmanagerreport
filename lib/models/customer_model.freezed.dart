// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

/// @nodoc
mixin _$Customer {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get totalVisits => throw _privateConstructorUsedError;
  double? get totalSpent => throw _privateConstructorUsedError;
  DateTime? get lastVisit => throw _privateConstructorUsedError;
  String? get preferredStylist => throw _privateConstructorUsedError;
  List<String>? get preferredServices => throw _privateConstructorUsedError;
  bool? get isVIP => throw _privateConstructorUsedError;
  String? get birthDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

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
    String salonId,
    String firstName,
    String lastName,
    String phone,
    String email,
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
    Object? salonId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = null,
    Object? email = null,
    Object? address = freezed,
    Object? notes = freezed,
    Object? totalVisits = freezed,
    Object? totalSpent = freezed,
    Object? lastVisit = freezed,
    Object? preferredStylist = freezed,
    Object? preferredServices = freezed,
    Object? isVIP = freezed,
    Object? birthDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalVisits: freezed == totalVisits
                ? _value.totalVisits
                : totalVisits // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalSpent: freezed == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                      as double?,
            lastVisit: freezed == lastVisit
                ? _value.lastVisit
                : lastVisit // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            preferredStylist: freezed == preferredStylist
                ? _value.preferredStylist
                : preferredStylist // ignore: cast_nullable_to_non_nullable
                      as String?,
            preferredServices: freezed == preferredServices
                ? _value.preferredServices
                : preferredServices // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            isVIP: freezed == isVIP
                ? _value.isVIP
                : isVIP // ignore: cast_nullable_to_non_nullable
                      as bool?,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
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
    String salonId,
    String firstName,
    String lastName,
    String phone,
    String email,
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
    Object? salonId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = null,
    Object? email = null,
    Object? address = freezed,
    Object? notes = freezed,
    Object? totalVisits = freezed,
    Object? totalSpent = freezed,
    Object? lastVisit = freezed,
    Object? preferredStylist = freezed,
    Object? preferredServices = freezed,
    Object? isVIP = freezed,
    Object? birthDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CustomerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalVisits: freezed == totalVisits
            ? _value.totalVisits
            : totalVisits // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalSpent: freezed == totalSpent
            ? _value.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as double?,
        lastVisit: freezed == lastVisit
            ? _value.lastVisit
            : lastVisit // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        preferredStylist: freezed == preferredStylist
            ? _value.preferredStylist
            : preferredStylist // ignore: cast_nullable_to_non_nullable
                  as String?,
        preferredServices: freezed == preferredServices
            ? _value._preferredServices
            : preferredServices // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        isVIP: freezed == isVIP
            ? _value.isVIP
            : isVIP // ignore: cast_nullable_to_non_nullable
                  as bool?,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
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
class _$CustomerImpl implements _Customer {
  const _$CustomerImpl({
    required this.id,
    required this.salonId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    this.address,
    this.notes,
    this.totalVisits,
    this.totalSpent,
    this.lastVisit,
    this.preferredStylist,
    final List<String>? preferredServices,
    this.isVIP,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
  }) : _preferredServices = preferredServices;

  factory _$CustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String phone;
  @override
  final String email;
  @override
  final String? address;
  @override
  final String? notes;
  @override
  final int? totalVisits;
  @override
  final double? totalSpent;
  @override
  final DateTime? lastVisit;
  @override
  final String? preferredStylist;
  final List<String>? _preferredServices;
  @override
  List<String>? get preferredServices {
    final value = _preferredServices;
    if (value == null) return null;
    if (_preferredServices is EqualUnmodifiableListView)
      return _preferredServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? isVIP;
  @override
  final String? birthDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Customer(id: $id, salonId: $salonId, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, address: $address, notes: $notes, totalVisits: $totalVisits, totalSpent: $totalSpent, lastVisit: $lastVisit, preferredStylist: $preferredStylist, preferredServices: $preferredServices, isVIP: $isVIP, birthDate: $birthDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.totalVisits, totalVisits) ||
                other.totalVisits == totalVisits) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.lastVisit, lastVisit) ||
                other.lastVisit == lastVisit) &&
            (identical(other.preferredStylist, preferredStylist) ||
                other.preferredStylist == preferredStylist) &&
            const DeepCollectionEquality().equals(
              other._preferredServices,
              _preferredServices,
            ) &&
            (identical(other.isVIP, isVIP) || other.isVIP == isVIP) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
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
    firstName,
    lastName,
    phone,
    email,
    address,
    notes,
    totalVisits,
    totalSpent,
    lastVisit,
    preferredStylist,
    const DeepCollectionEquality().hash(_preferredServices),
    isVIP,
    birthDate,
    createdAt,
    updatedAt,
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
    required final String salonId,
    required final String firstName,
    required final String lastName,
    required final String phone,
    required final String email,
    final String? address,
    final String? notes,
    final int? totalVisits,
    final double? totalSpent,
    final DateTime? lastVisit,
    final String? preferredStylist,
    final List<String>? preferredServices,
    final bool? isVIP,
    final String? birthDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CustomerImpl;

  factory _Customer.fromJson(Map<String, dynamic> json) =
      _$CustomerImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get phone;
  @override
  String get email;
  @override
  String? get address;
  @override
  String? get notes;
  @override
  int? get totalVisits;
  @override
  double? get totalSpent;
  @override
  DateTime? get lastVisit;
  @override
  String? get preferredStylist;
  @override
  List<String>? get preferredServices;
  @override
  bool? get isVIP;
  @override
  String? get birthDate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerSummary _$CustomerSummaryFromJson(Map<String, dynamic> json) {
  return _CustomerSummary.fromJson(json);
}

/// @nodoc
mixin _$CustomerSummary {
  int get totalCustomers => throw _privateConstructorUsedError;
  int get vipCustomers => throw _privateConstructorUsedError;
  int get newCustomersThisMonth => throw _privateConstructorUsedError;
  double get avgVisitsPerCustomer => throw _privateConstructorUsedError;
  double get avgMonthlySpend => throw _privateConstructorUsedError;

  /// Serializes this CustomerSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerSummaryCopyWith<CustomerSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerSummaryCopyWith<$Res> {
  factory $CustomerSummaryCopyWith(
    CustomerSummary value,
    $Res Function(CustomerSummary) then,
  ) = _$CustomerSummaryCopyWithImpl<$Res, CustomerSummary>;
  @useResult
  $Res call({
    int totalCustomers,
    int vipCustomers,
    int newCustomersThisMonth,
    double avgVisitsPerCustomer,
    double avgMonthlySpend,
  });
}

/// @nodoc
class _$CustomerSummaryCopyWithImpl<$Res, $Val extends CustomerSummary>
    implements $CustomerSummaryCopyWith<$Res> {
  _$CustomerSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCustomers = null,
    Object? vipCustomers = null,
    Object? newCustomersThisMonth = null,
    Object? avgVisitsPerCustomer = null,
    Object? avgMonthlySpend = null,
  }) {
    return _then(
      _value.copyWith(
            totalCustomers: null == totalCustomers
                ? _value.totalCustomers
                : totalCustomers // ignore: cast_nullable_to_non_nullable
                      as int,
            vipCustomers: null == vipCustomers
                ? _value.vipCustomers
                : vipCustomers // ignore: cast_nullable_to_non_nullable
                      as int,
            newCustomersThisMonth: null == newCustomersThisMonth
                ? _value.newCustomersThisMonth
                : newCustomersThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            avgVisitsPerCustomer: null == avgVisitsPerCustomer
                ? _value.avgVisitsPerCustomer
                : avgVisitsPerCustomer // ignore: cast_nullable_to_non_nullable
                      as double,
            avgMonthlySpend: null == avgMonthlySpend
                ? _value.avgMonthlySpend
                : avgMonthlySpend // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerSummaryImplCopyWith<$Res>
    implements $CustomerSummaryCopyWith<$Res> {
  factory _$$CustomerSummaryImplCopyWith(
    _$CustomerSummaryImpl value,
    $Res Function(_$CustomerSummaryImpl) then,
  ) = __$$CustomerSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalCustomers,
    int vipCustomers,
    int newCustomersThisMonth,
    double avgVisitsPerCustomer,
    double avgMonthlySpend,
  });
}

/// @nodoc
class __$$CustomerSummaryImplCopyWithImpl<$Res>
    extends _$CustomerSummaryCopyWithImpl<$Res, _$CustomerSummaryImpl>
    implements _$$CustomerSummaryImplCopyWith<$Res> {
  __$$CustomerSummaryImplCopyWithImpl(
    _$CustomerSummaryImpl _value,
    $Res Function(_$CustomerSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCustomers = null,
    Object? vipCustomers = null,
    Object? newCustomersThisMonth = null,
    Object? avgVisitsPerCustomer = null,
    Object? avgMonthlySpend = null,
  }) {
    return _then(
      _$CustomerSummaryImpl(
        totalCustomers: null == totalCustomers
            ? _value.totalCustomers
            : totalCustomers // ignore: cast_nullable_to_non_nullable
                  as int,
        vipCustomers: null == vipCustomers
            ? _value.vipCustomers
            : vipCustomers // ignore: cast_nullable_to_non_nullable
                  as int,
        newCustomersThisMonth: null == newCustomersThisMonth
            ? _value.newCustomersThisMonth
            : newCustomersThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        avgVisitsPerCustomer: null == avgVisitsPerCustomer
            ? _value.avgVisitsPerCustomer
            : avgVisitsPerCustomer // ignore: cast_nullable_to_non_nullable
                  as double,
        avgMonthlySpend: null == avgMonthlySpend
            ? _value.avgMonthlySpend
            : avgMonthlySpend // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerSummaryImpl implements _CustomerSummary {
  const _$CustomerSummaryImpl({
    required this.totalCustomers,
    required this.vipCustomers,
    required this.newCustomersThisMonth,
    required this.avgVisitsPerCustomer,
    required this.avgMonthlySpend,
  });

  factory _$CustomerSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerSummaryImplFromJson(json);

  @override
  final int totalCustomers;
  @override
  final int vipCustomers;
  @override
  final int newCustomersThisMonth;
  @override
  final double avgVisitsPerCustomer;
  @override
  final double avgMonthlySpend;

  @override
  String toString() {
    return 'CustomerSummary(totalCustomers: $totalCustomers, vipCustomers: $vipCustomers, newCustomersThisMonth: $newCustomersThisMonth, avgVisitsPerCustomer: $avgVisitsPerCustomer, avgMonthlySpend: $avgMonthlySpend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerSummaryImpl &&
            (identical(other.totalCustomers, totalCustomers) ||
                other.totalCustomers == totalCustomers) &&
            (identical(other.vipCustomers, vipCustomers) ||
                other.vipCustomers == vipCustomers) &&
            (identical(other.newCustomersThisMonth, newCustomersThisMonth) ||
                other.newCustomersThisMonth == newCustomersThisMonth) &&
            (identical(other.avgVisitsPerCustomer, avgVisitsPerCustomer) ||
                other.avgVisitsPerCustomer == avgVisitsPerCustomer) &&
            (identical(other.avgMonthlySpend, avgMonthlySpend) ||
                other.avgMonthlySpend == avgMonthlySpend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCustomers,
    vipCustomers,
    newCustomersThisMonth,
    avgVisitsPerCustomer,
    avgMonthlySpend,
  );

  /// Create a copy of CustomerSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerSummaryImplCopyWith<_$CustomerSummaryImpl> get copyWith =>
      __$$CustomerSummaryImplCopyWithImpl<_$CustomerSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerSummaryImplToJson(this);
  }
}

abstract class _CustomerSummary implements CustomerSummary {
  const factory _CustomerSummary({
    required final int totalCustomers,
    required final int vipCustomers,
    required final int newCustomersThisMonth,
    required final double avgVisitsPerCustomer,
    required final double avgMonthlySpend,
  }) = _$CustomerSummaryImpl;

  factory _CustomerSummary.fromJson(Map<String, dynamic> json) =
      _$CustomerSummaryImpl.fromJson;

  @override
  int get totalCustomers;
  @override
  int get vipCustomers;
  @override
  int get newCustomersThisMonth;
  @override
  double get avgVisitsPerCustomer;
  @override
  double get avgMonthlySpend;

  /// Create a copy of CustomerSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerSummaryImplCopyWith<_$CustomerSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerTransaction _$CustomerTransactionFromJson(Map<String, dynamic> json) {
  return _CustomerTransaction.fromJson(json);
}

/// @nodoc
mixin _$CustomerTransaction {
  String get id => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // booking, product, service
  String get description => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CustomerTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerTransactionCopyWith<CustomerTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerTransactionCopyWith<$Res> {
  factory $CustomerTransactionCopyWith(
    CustomerTransaction value,
    $Res Function(CustomerTransaction) then,
  ) = _$CustomerTransactionCopyWithImpl<$Res, CustomerTransaction>;
  @useResult
  $Res call({
    String id,
    String customerId,
    String salonId,
    double amount,
    String type,
    String description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CustomerTransactionCopyWithImpl<$Res, $Val extends CustomerTransaction>
    implements $CustomerTransactionCopyWith<$Res> {
  _$CustomerTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? salonId = null,
    Object? amount = null,
    Object? type = null,
    Object? description = null,
    Object? date = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$CustomerTransactionImplCopyWith<$Res>
    implements $CustomerTransactionCopyWith<$Res> {
  factory _$$CustomerTransactionImplCopyWith(
    _$CustomerTransactionImpl value,
    $Res Function(_$CustomerTransactionImpl) then,
  ) = __$$CustomerTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String customerId,
    String salonId,
    double amount,
    String type,
    String description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CustomerTransactionImplCopyWithImpl<$Res>
    extends _$CustomerTransactionCopyWithImpl<$Res, _$CustomerTransactionImpl>
    implements _$$CustomerTransactionImplCopyWith<$Res> {
  __$$CustomerTransactionImplCopyWithImpl(
    _$CustomerTransactionImpl _value,
    $Res Function(_$CustomerTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? salonId = null,
    Object? amount = null,
    Object? type = null,
    Object? description = null,
    Object? date = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CustomerTransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$CustomerTransactionImpl implements _CustomerTransaction {
  const _$CustomerTransactionImpl({
    required this.id,
    required this.customerId,
    required this.salonId,
    required this.amount,
    required this.type,
    required this.description,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory _$CustomerTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String customerId;
  @override
  final String salonId;
  @override
  final double amount;
  @override
  final String type;
  // booking, product, service
  @override
  final String description;
  @override
  final DateTime? date;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CustomerTransaction(id: $id, customerId: $customerId, salonId: $salonId, amount: $amount, type: $type, description: $description, date: $date, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
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
    customerId,
    salonId,
    amount,
    type,
    description,
    date,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerTransactionImplCopyWith<_$CustomerTransactionImpl> get copyWith =>
      __$$CustomerTransactionImplCopyWithImpl<_$CustomerTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerTransactionImplToJson(this);
  }
}

abstract class _CustomerTransaction implements CustomerTransaction {
  const factory _CustomerTransaction({
    required final String id,
    required final String customerId,
    required final String salonId,
    required final double amount,
    required final String type,
    required final String description,
    final DateTime? date,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CustomerTransactionImpl;

  factory _CustomerTransaction.fromJson(Map<String, dynamic> json) =
      _$CustomerTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get customerId;
  @override
  String get salonId;
  @override
  double get amount;
  @override
  String get type; // booking, product, service
  @override
  String get description;
  @override
  DateTime? get date;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerTransactionImplCopyWith<_$CustomerTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
