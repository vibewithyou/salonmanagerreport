// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReportData _$ReportDataFromJson(Map<String, dynamic> json) {
  return _ReportData.fromJson(json);
}

/// @nodoc
mixin _$ReportData {
  int get totalEmployees => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  int get totalBookings => throw _privateConstructorUsedError;
  int get totalCustomers => throw _privateConstructorUsedError;
  double get avgBookingValue => throw _privateConstructorUsedError;
  List<ChartData> get revenueByMonth => throw _privateConstructorUsedError;
  List<ChartData> get bookingsByService => throw _privateConstructorUsedError;

  /// Serializes this ReportData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportDataCopyWith<ReportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDataCopyWith<$Res> {
  factory $ReportDataCopyWith(
    ReportData value,
    $Res Function(ReportData) then,
  ) = _$ReportDataCopyWithImpl<$Res, ReportData>;
  @useResult
  $Res call({
    int totalEmployees,
    double totalRevenue,
    int totalBookings,
    int totalCustomers,
    double avgBookingValue,
    List<ChartData> revenueByMonth,
    List<ChartData> bookingsByService,
  });
}

/// @nodoc
class _$ReportDataCopyWithImpl<$Res, $Val extends ReportData>
    implements $ReportDataCopyWith<$Res> {
  _$ReportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEmployees = null,
    Object? totalRevenue = null,
    Object? totalBookings = null,
    Object? totalCustomers = null,
    Object? avgBookingValue = null,
    Object? revenueByMonth = null,
    Object? bookingsByService = null,
  }) {
    return _then(
      _value.copyWith(
            totalEmployees: null == totalEmployees
                ? _value.totalEmployees
                : totalEmployees // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            totalBookings: null == totalBookings
                ? _value.totalBookings
                : totalBookings // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCustomers: null == totalCustomers
                ? _value.totalCustomers
                : totalCustomers // ignore: cast_nullable_to_non_nullable
                      as int,
            avgBookingValue: null == avgBookingValue
                ? _value.avgBookingValue
                : avgBookingValue // ignore: cast_nullable_to_non_nullable
                      as double,
            revenueByMonth: null == revenueByMonth
                ? _value.revenueByMonth
                : revenueByMonth // ignore: cast_nullable_to_non_nullable
                      as List<ChartData>,
            bookingsByService: null == bookingsByService
                ? _value.bookingsByService
                : bookingsByService // ignore: cast_nullable_to_non_nullable
                      as List<ChartData>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportDataImplCopyWith<$Res>
    implements $ReportDataCopyWith<$Res> {
  factory _$$ReportDataImplCopyWith(
    _$ReportDataImpl value,
    $Res Function(_$ReportDataImpl) then,
  ) = __$$ReportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalEmployees,
    double totalRevenue,
    int totalBookings,
    int totalCustomers,
    double avgBookingValue,
    List<ChartData> revenueByMonth,
    List<ChartData> bookingsByService,
  });
}

/// @nodoc
class __$$ReportDataImplCopyWithImpl<$Res>
    extends _$ReportDataCopyWithImpl<$Res, _$ReportDataImpl>
    implements _$$ReportDataImplCopyWith<$Res> {
  __$$ReportDataImplCopyWithImpl(
    _$ReportDataImpl _value,
    $Res Function(_$ReportDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEmployees = null,
    Object? totalRevenue = null,
    Object? totalBookings = null,
    Object? totalCustomers = null,
    Object? avgBookingValue = null,
    Object? revenueByMonth = null,
    Object? bookingsByService = null,
  }) {
    return _then(
      _$ReportDataImpl(
        totalEmployees: null == totalEmployees
            ? _value.totalEmployees
            : totalEmployees // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        totalBookings: null == totalBookings
            ? _value.totalBookings
            : totalBookings // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCustomers: null == totalCustomers
            ? _value.totalCustomers
            : totalCustomers // ignore: cast_nullable_to_non_nullable
                  as int,
        avgBookingValue: null == avgBookingValue
            ? _value.avgBookingValue
            : avgBookingValue // ignore: cast_nullable_to_non_nullable
                  as double,
        revenueByMonth: null == revenueByMonth
            ? _value._revenueByMonth
            : revenueByMonth // ignore: cast_nullable_to_non_nullable
                  as List<ChartData>,
        bookingsByService: null == bookingsByService
            ? _value._bookingsByService
            : bookingsByService // ignore: cast_nullable_to_non_nullable
                  as List<ChartData>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportDataImpl implements _ReportData {
  const _$ReportDataImpl({
    required this.totalEmployees,
    required this.totalRevenue,
    required this.totalBookings,
    required this.totalCustomers,
    required this.avgBookingValue,
    required final List<ChartData> revenueByMonth,
    required final List<ChartData> bookingsByService,
  }) : _revenueByMonth = revenueByMonth,
       _bookingsByService = bookingsByService;

  factory _$ReportDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportDataImplFromJson(json);

  @override
  final int totalEmployees;
  @override
  final double totalRevenue;
  @override
  final int totalBookings;
  @override
  final int totalCustomers;
  @override
  final double avgBookingValue;
  final List<ChartData> _revenueByMonth;
  @override
  List<ChartData> get revenueByMonth {
    if (_revenueByMonth is EqualUnmodifiableListView) return _revenueByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_revenueByMonth);
  }

  final List<ChartData> _bookingsByService;
  @override
  List<ChartData> get bookingsByService {
    if (_bookingsByService is EqualUnmodifiableListView)
      return _bookingsByService;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookingsByService);
  }

  @override
  String toString() {
    return 'ReportData(totalEmployees: $totalEmployees, totalRevenue: $totalRevenue, totalBookings: $totalBookings, totalCustomers: $totalCustomers, avgBookingValue: $avgBookingValue, revenueByMonth: $revenueByMonth, bookingsByService: $bookingsByService)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportDataImpl &&
            (identical(other.totalEmployees, totalEmployees) ||
                other.totalEmployees == totalEmployees) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalBookings, totalBookings) ||
                other.totalBookings == totalBookings) &&
            (identical(other.totalCustomers, totalCustomers) ||
                other.totalCustomers == totalCustomers) &&
            (identical(other.avgBookingValue, avgBookingValue) ||
                other.avgBookingValue == avgBookingValue) &&
            const DeepCollectionEquality().equals(
              other._revenueByMonth,
              _revenueByMonth,
            ) &&
            const DeepCollectionEquality().equals(
              other._bookingsByService,
              _bookingsByService,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalEmployees,
    totalRevenue,
    totalBookings,
    totalCustomers,
    avgBookingValue,
    const DeepCollectionEquality().hash(_revenueByMonth),
    const DeepCollectionEquality().hash(_bookingsByService),
  );

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      __$$ReportDataImplCopyWithImpl<_$ReportDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportDataImplToJson(this);
  }
}

abstract class _ReportData implements ReportData {
  const factory _ReportData({
    required final int totalEmployees,
    required final double totalRevenue,
    required final int totalBookings,
    required final int totalCustomers,
    required final double avgBookingValue,
    required final List<ChartData> revenueByMonth,
    required final List<ChartData> bookingsByService,
  }) = _$ReportDataImpl;

  factory _ReportData.fromJson(Map<String, dynamic> json) =
      _$ReportDataImpl.fromJson;

  @override
  int get totalEmployees;
  @override
  double get totalRevenue;
  @override
  int get totalBookings;
  @override
  int get totalCustomers;
  @override
  double get avgBookingValue;
  @override
  List<ChartData> get revenueByMonth;
  @override
  List<ChartData> get bookingsByService;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChartData _$ChartDataFromJson(Map<String, dynamic> json) {
  return _ChartData.fromJson(json);
}

/// @nodoc
mixin _$ChartData {
  String get label => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;

  /// Serializes this ChartData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChartData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartDataCopyWith<ChartData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartDataCopyWith<$Res> {
  factory $ChartDataCopyWith(ChartData value, $Res Function(ChartData) then) =
      _$ChartDataCopyWithImpl<$Res, ChartData>;
  @useResult
  $Res call({String label, double value});
}

/// @nodoc
class _$ChartDataCopyWithImpl<$Res, $Val extends ChartData>
    implements $ChartDataCopyWith<$Res> {
  _$ChartDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChartDataImplCopyWith<$Res>
    implements $ChartDataCopyWith<$Res> {
  factory _$$ChartDataImplCopyWith(
    _$ChartDataImpl value,
    $Res Function(_$ChartDataImpl) then,
  ) = __$$ChartDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double value});
}

/// @nodoc
class __$$ChartDataImplCopyWithImpl<$Res>
    extends _$ChartDataCopyWithImpl<$Res, _$ChartDataImpl>
    implements _$$ChartDataImplCopyWith<$Res> {
  __$$ChartDataImplCopyWithImpl(
    _$ChartDataImpl _value,
    $Res Function(_$ChartDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChartData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? value = null}) {
    return _then(
      _$ChartDataImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartDataImpl implements _ChartData {
  const _$ChartDataImpl({required this.label, required this.value});

  factory _$ChartDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartDataImplFromJson(json);

  @override
  final String label;
  @override
  final double value;

  @override
  String toString() {
    return 'ChartData(label: $label, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartDataImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, value);

  /// Create a copy of ChartData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartDataImplCopyWith<_$ChartDataImpl> get copyWith =>
      __$$ChartDataImplCopyWithImpl<_$ChartDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartDataImplToJson(this);
  }
}

abstract class _ChartData implements ChartData {
  const factory _ChartData({
    required final String label,
    required final double value,
  }) = _$ChartDataImpl;

  factory _ChartData.fromJson(Map<String, dynamic> json) =
      _$ChartDataImpl.fromJson;

  @override
  String get label;
  @override
  double get value;

  /// Create a copy of ChartData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartDataImplCopyWith<_$ChartDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
