// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_performance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EmployeePerformance _$EmployeePerformanceFromJson(Map<String, dynamic> json) {
  return _EmployeePerformance.fromJson(json);
}

/// @nodoc
mixin _$EmployeePerformance {
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  String get roleId => throw _privateConstructorUsedError;
  String? get avatarUrl =>
      throw _privateConstructorUsedError; // Performance metrics
  int get appointmentsThisMonth => throw _privateConstructorUsedError;
  int get appointmentsThisWeek => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews =>
      throw _privateConstructorUsedError; // Financial metrics
  double get revenueThisMonth => throw _privateConstructorUsedError;
  double get commissionThisMonth => throw _privateConstructorUsedError;
  double get targetRevenue => throw _privateConstructorUsedError; // Status
  bool get isActive => throw _privateConstructorUsedError;
  bool get isOnLeave => throw _privateConstructorUsedError;
  DateTime? get leaveEndDate =>
      throw _privateConstructorUsedError; // Time tracking
  int get hoursWorkedThisWeek => throw _privateConstructorUsedError;
  int get scheduledHoursThisWeek =>
      throw _privateConstructorUsedError; // Attendance
  int get presentDays => throw _privateConstructorUsedError;
  int get absentDays => throw _privateConstructorUsedError;
  int get lateDays => throw _privateConstructorUsedError; // Last activity
  DateTime? get lastAppointment => throw _privateConstructorUsedError;
  DateTime? get lastLogin => throw _privateConstructorUsedError;

  /// Serializes this EmployeePerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeePerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeePerformanceCopyWith<EmployeePerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeePerformanceCopyWith<$Res> {
  factory $EmployeePerformanceCopyWith(
    EmployeePerformance value,
    $Res Function(EmployeePerformance) then,
  ) = _$EmployeePerformanceCopyWithImpl<$Res, EmployeePerformance>;
  @useResult
  $Res call({
    String employeeId,
    String employeeName,
    String roleId,
    String? avatarUrl,
    int appointmentsThisMonth,
    int appointmentsThisWeek,
    double averageRating,
    int totalReviews,
    double revenueThisMonth,
    double commissionThisMonth,
    double targetRevenue,
    bool isActive,
    bool isOnLeave,
    DateTime? leaveEndDate,
    int hoursWorkedThisWeek,
    int scheduledHoursThisWeek,
    int presentDays,
    int absentDays,
    int lateDays,
    DateTime? lastAppointment,
    DateTime? lastLogin,
  });
}

/// @nodoc
class _$EmployeePerformanceCopyWithImpl<$Res, $Val extends EmployeePerformance>
    implements $EmployeePerformanceCopyWith<$Res> {
  _$EmployeePerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeePerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? roleId = null,
    Object? avatarUrl = freezed,
    Object? appointmentsThisMonth = null,
    Object? appointmentsThisWeek = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? revenueThisMonth = null,
    Object? commissionThisMonth = null,
    Object? targetRevenue = null,
    Object? isActive = null,
    Object? isOnLeave = null,
    Object? leaveEndDate = freezed,
    Object? hoursWorkedThisWeek = null,
    Object? scheduledHoursThisWeek = null,
    Object? presentDays = null,
    Object? absentDays = null,
    Object? lateDays = null,
    Object? lastAppointment = freezed,
    Object? lastLogin = freezed,
  }) {
    return _then(
      _value.copyWith(
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            employeeName: null == employeeName
                ? _value.employeeName
                : employeeName // ignore: cast_nullable_to_non_nullable
                      as String,
            roleId: null == roleId
                ? _value.roleId
                : roleId // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            appointmentsThisMonth: null == appointmentsThisMonth
                ? _value.appointmentsThisMonth
                : appointmentsThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            appointmentsThisWeek: null == appointmentsThisWeek
                ? _value.appointmentsThisWeek
                : appointmentsThisWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            averageRating: null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            revenueThisMonth: null == revenueThisMonth
                ? _value.revenueThisMonth
                : revenueThisMonth // ignore: cast_nullable_to_non_nullable
                      as double,
            commissionThisMonth: null == commissionThisMonth
                ? _value.commissionThisMonth
                : commissionThisMonth // ignore: cast_nullable_to_non_nullable
                      as double,
            targetRevenue: null == targetRevenue
                ? _value.targetRevenue
                : targetRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isOnLeave: null == isOnLeave
                ? _value.isOnLeave
                : isOnLeave // ignore: cast_nullable_to_non_nullable
                      as bool,
            leaveEndDate: freezed == leaveEndDate
                ? _value.leaveEndDate
                : leaveEndDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            hoursWorkedThisWeek: null == hoursWorkedThisWeek
                ? _value.hoursWorkedThisWeek
                : hoursWorkedThisWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            scheduledHoursThisWeek: null == scheduledHoursThisWeek
                ? _value.scheduledHoursThisWeek
                : scheduledHoursThisWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            presentDays: null == presentDays
                ? _value.presentDays
                : presentDays // ignore: cast_nullable_to_non_nullable
                      as int,
            absentDays: null == absentDays
                ? _value.absentDays
                : absentDays // ignore: cast_nullable_to_non_nullable
                      as int,
            lateDays: null == lateDays
                ? _value.lateDays
                : lateDays // ignore: cast_nullable_to_non_nullable
                      as int,
            lastAppointment: freezed == lastAppointment
                ? _value.lastAppointment
                : lastAppointment // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastLogin: freezed == lastLogin
                ? _value.lastLogin
                : lastLogin // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeePerformanceImplCopyWith<$Res>
    implements $EmployeePerformanceCopyWith<$Res> {
  factory _$$EmployeePerformanceImplCopyWith(
    _$EmployeePerformanceImpl value,
    $Res Function(_$EmployeePerformanceImpl) then,
  ) = __$$EmployeePerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String employeeId,
    String employeeName,
    String roleId,
    String? avatarUrl,
    int appointmentsThisMonth,
    int appointmentsThisWeek,
    double averageRating,
    int totalReviews,
    double revenueThisMonth,
    double commissionThisMonth,
    double targetRevenue,
    bool isActive,
    bool isOnLeave,
    DateTime? leaveEndDate,
    int hoursWorkedThisWeek,
    int scheduledHoursThisWeek,
    int presentDays,
    int absentDays,
    int lateDays,
    DateTime? lastAppointment,
    DateTime? lastLogin,
  });
}

/// @nodoc
class __$$EmployeePerformanceImplCopyWithImpl<$Res>
    extends _$EmployeePerformanceCopyWithImpl<$Res, _$EmployeePerformanceImpl>
    implements _$$EmployeePerformanceImplCopyWith<$Res> {
  __$$EmployeePerformanceImplCopyWithImpl(
    _$EmployeePerformanceImpl _value,
    $Res Function(_$EmployeePerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeePerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? roleId = null,
    Object? avatarUrl = freezed,
    Object? appointmentsThisMonth = null,
    Object? appointmentsThisWeek = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? revenueThisMonth = null,
    Object? commissionThisMonth = null,
    Object? targetRevenue = null,
    Object? isActive = null,
    Object? isOnLeave = null,
    Object? leaveEndDate = freezed,
    Object? hoursWorkedThisWeek = null,
    Object? scheduledHoursThisWeek = null,
    Object? presentDays = null,
    Object? absentDays = null,
    Object? lateDays = null,
    Object? lastAppointment = freezed,
    Object? lastLogin = freezed,
  }) {
    return _then(
      _$EmployeePerformanceImpl(
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeName: null == employeeName
            ? _value.employeeName
            : employeeName // ignore: cast_nullable_to_non_nullable
                  as String,
        roleId: null == roleId
            ? _value.roleId
            : roleId // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        appointmentsThisMonth: null == appointmentsThisMonth
            ? _value.appointmentsThisMonth
            : appointmentsThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        appointmentsThisWeek: null == appointmentsThisWeek
            ? _value.appointmentsThisWeek
            : appointmentsThisWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        averageRating: null == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        revenueThisMonth: null == revenueThisMonth
            ? _value.revenueThisMonth
            : revenueThisMonth // ignore: cast_nullable_to_non_nullable
                  as double,
        commissionThisMonth: null == commissionThisMonth
            ? _value.commissionThisMonth
            : commissionThisMonth // ignore: cast_nullable_to_non_nullable
                  as double,
        targetRevenue: null == targetRevenue
            ? _value.targetRevenue
            : targetRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isOnLeave: null == isOnLeave
            ? _value.isOnLeave
            : isOnLeave // ignore: cast_nullable_to_non_nullable
                  as bool,
        leaveEndDate: freezed == leaveEndDate
            ? _value.leaveEndDate
            : leaveEndDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        hoursWorkedThisWeek: null == hoursWorkedThisWeek
            ? _value.hoursWorkedThisWeek
            : hoursWorkedThisWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        scheduledHoursThisWeek: null == scheduledHoursThisWeek
            ? _value.scheduledHoursThisWeek
            : scheduledHoursThisWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        presentDays: null == presentDays
            ? _value.presentDays
            : presentDays // ignore: cast_nullable_to_non_nullable
                  as int,
        absentDays: null == absentDays
            ? _value.absentDays
            : absentDays // ignore: cast_nullable_to_non_nullable
                  as int,
        lateDays: null == lateDays
            ? _value.lateDays
            : lateDays // ignore: cast_nullable_to_non_nullable
                  as int,
        lastAppointment: freezed == lastAppointment
            ? _value.lastAppointment
            : lastAppointment // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastLogin: freezed == lastLogin
            ? _value.lastLogin
            : lastLogin // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeePerformanceImpl implements _EmployeePerformance {
  const _$EmployeePerformanceImpl({
    required this.employeeId,
    required this.employeeName,
    required this.roleId,
    this.avatarUrl,
    required this.appointmentsThisMonth,
    required this.appointmentsThisWeek,
    required this.averageRating,
    required this.totalReviews,
    required this.revenueThisMonth,
    required this.commissionThisMonth,
    required this.targetRevenue,
    required this.isActive,
    required this.isOnLeave,
    required this.leaveEndDate,
    required this.hoursWorkedThisWeek,
    required this.scheduledHoursThisWeek,
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
    this.lastAppointment,
    this.lastLogin,
  });

  factory _$EmployeePerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeePerformanceImplFromJson(json);

  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final String roleId;
  @override
  final String? avatarUrl;
  // Performance metrics
  @override
  final int appointmentsThisMonth;
  @override
  final int appointmentsThisWeek;
  @override
  final double averageRating;
  @override
  final int totalReviews;
  // Financial metrics
  @override
  final double revenueThisMonth;
  @override
  final double commissionThisMonth;
  @override
  final double targetRevenue;
  // Status
  @override
  final bool isActive;
  @override
  final bool isOnLeave;
  @override
  final DateTime? leaveEndDate;
  // Time tracking
  @override
  final int hoursWorkedThisWeek;
  @override
  final int scheduledHoursThisWeek;
  // Attendance
  @override
  final int presentDays;
  @override
  final int absentDays;
  @override
  final int lateDays;
  // Last activity
  @override
  final DateTime? lastAppointment;
  @override
  final DateTime? lastLogin;

  @override
  String toString() {
    return 'EmployeePerformance(employeeId: $employeeId, employeeName: $employeeName, roleId: $roleId, avatarUrl: $avatarUrl, appointmentsThisMonth: $appointmentsThisMonth, appointmentsThisWeek: $appointmentsThisWeek, averageRating: $averageRating, totalReviews: $totalReviews, revenueThisMonth: $revenueThisMonth, commissionThisMonth: $commissionThisMonth, targetRevenue: $targetRevenue, isActive: $isActive, isOnLeave: $isOnLeave, leaveEndDate: $leaveEndDate, hoursWorkedThisWeek: $hoursWorkedThisWeek, scheduledHoursThisWeek: $scheduledHoursThisWeek, presentDays: $presentDays, absentDays: $absentDays, lateDays: $lateDays, lastAppointment: $lastAppointment, lastLogin: $lastLogin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeePerformanceImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.appointmentsThisMonth, appointmentsThisMonth) ||
                other.appointmentsThisMonth == appointmentsThisMonth) &&
            (identical(other.appointmentsThisWeek, appointmentsThisWeek) ||
                other.appointmentsThisWeek == appointmentsThisWeek) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.revenueThisMonth, revenueThisMonth) ||
                other.revenueThisMonth == revenueThisMonth) &&
            (identical(other.commissionThisMonth, commissionThisMonth) ||
                other.commissionThisMonth == commissionThisMonth) &&
            (identical(other.targetRevenue, targetRevenue) ||
                other.targetRevenue == targetRevenue) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isOnLeave, isOnLeave) ||
                other.isOnLeave == isOnLeave) &&
            (identical(other.leaveEndDate, leaveEndDate) ||
                other.leaveEndDate == leaveEndDate) &&
            (identical(other.hoursWorkedThisWeek, hoursWorkedThisWeek) ||
                other.hoursWorkedThisWeek == hoursWorkedThisWeek) &&
            (identical(other.scheduledHoursThisWeek, scheduledHoursThisWeek) ||
                other.scheduledHoursThisWeek == scheduledHoursThisWeek) &&
            (identical(other.presentDays, presentDays) ||
                other.presentDays == presentDays) &&
            (identical(other.absentDays, absentDays) ||
                other.absentDays == absentDays) &&
            (identical(other.lateDays, lateDays) ||
                other.lateDays == lateDays) &&
            (identical(other.lastAppointment, lastAppointment) ||
                other.lastAppointment == lastAppointment) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    employeeId,
    employeeName,
    roleId,
    avatarUrl,
    appointmentsThisMonth,
    appointmentsThisWeek,
    averageRating,
    totalReviews,
    revenueThisMonth,
    commissionThisMonth,
    targetRevenue,
    isActive,
    isOnLeave,
    leaveEndDate,
    hoursWorkedThisWeek,
    scheduledHoursThisWeek,
    presentDays,
    absentDays,
    lateDays,
    lastAppointment,
    lastLogin,
  ]);

  /// Create a copy of EmployeePerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeePerformanceImplCopyWith<_$EmployeePerformanceImpl> get copyWith =>
      __$$EmployeePerformanceImplCopyWithImpl<_$EmployeePerformanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeePerformanceImplToJson(this);
  }
}

abstract class _EmployeePerformance implements EmployeePerformance {
  const factory _EmployeePerformance({
    required final String employeeId,
    required final String employeeName,
    required final String roleId,
    final String? avatarUrl,
    required final int appointmentsThisMonth,
    required final int appointmentsThisWeek,
    required final double averageRating,
    required final int totalReviews,
    required final double revenueThisMonth,
    required final double commissionThisMonth,
    required final double targetRevenue,
    required final bool isActive,
    required final bool isOnLeave,
    required final DateTime? leaveEndDate,
    required final int hoursWorkedThisWeek,
    required final int scheduledHoursThisWeek,
    required final int presentDays,
    required final int absentDays,
    required final int lateDays,
    final DateTime? lastAppointment,
    final DateTime? lastLogin,
  }) = _$EmployeePerformanceImpl;

  factory _EmployeePerformance.fromJson(Map<String, dynamic> json) =
      _$EmployeePerformanceImpl.fromJson;

  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  String get roleId;
  @override
  String? get avatarUrl; // Performance metrics
  @override
  int get appointmentsThisMonth;
  @override
  int get appointmentsThisWeek;
  @override
  double get averageRating;
  @override
  int get totalReviews; // Financial metrics
  @override
  double get revenueThisMonth;
  @override
  double get commissionThisMonth;
  @override
  double get targetRevenue; // Status
  @override
  bool get isActive;
  @override
  bool get isOnLeave;
  @override
  DateTime? get leaveEndDate; // Time tracking
  @override
  int get hoursWorkedThisWeek;
  @override
  int get scheduledHoursThisWeek; // Attendance
  @override
  int get presentDays;
  @override
  int get absentDays;
  @override
  int get lateDays; // Last activity
  @override
  DateTime? get lastAppointment;
  @override
  DateTime? get lastLogin;

  /// Create a copy of EmployeePerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeePerformanceImplCopyWith<_$EmployeePerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PerformanceMetrics _$PerformanceMetricsFromJson(Map<String, dynamic> json) {
  return _PerformanceMetrics.fromJson(json);
}

/// @nodoc
mixin _$PerformanceMetrics {
  String get metricName => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get target => throw _privateConstructorUsedError;
  double get percentage =>
      throw _privateConstructorUsedError; // value/target * 100
  String get status =>
      throw _privateConstructorUsedError; // "on-track", "below-target", "exceeding"
  String? get trend =>
      throw _privateConstructorUsedError; // "up", "down", "stable"
  double? get previousValue => throw _privateConstructorUsedError;

  /// Serializes this PerformanceMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerformanceMetricsCopyWith<PerformanceMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceMetricsCopyWith<$Res> {
  factory $PerformanceMetricsCopyWith(
    PerformanceMetrics value,
    $Res Function(PerformanceMetrics) then,
  ) = _$PerformanceMetricsCopyWithImpl<$Res, PerformanceMetrics>;
  @useResult
  $Res call({
    String metricName,
    double value,
    double target,
    double percentage,
    String status,
    String? trend,
    double? previousValue,
  });
}

/// @nodoc
class _$PerformanceMetricsCopyWithImpl<$Res, $Val extends PerformanceMetrics>
    implements $PerformanceMetricsCopyWith<$Res> {
  _$PerformanceMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metricName = null,
    Object? value = null,
    Object? target = null,
    Object? percentage = null,
    Object? status = null,
    Object? trend = freezed,
    Object? previousValue = freezed,
  }) {
    return _then(
      _value.copyWith(
            metricName: null == metricName
                ? _value.metricName
                : metricName // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            target: null == target
                ? _value.target
                : target // ignore: cast_nullable_to_non_nullable
                      as double,
            percentage: null == percentage
                ? _value.percentage
                : percentage // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            trend: freezed == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as String?,
            previousValue: freezed == previousValue
                ? _value.previousValue
                : previousValue // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PerformanceMetricsImplCopyWith<$Res>
    implements $PerformanceMetricsCopyWith<$Res> {
  factory _$$PerformanceMetricsImplCopyWith(
    _$PerformanceMetricsImpl value,
    $Res Function(_$PerformanceMetricsImpl) then,
  ) = __$$PerformanceMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String metricName,
    double value,
    double target,
    double percentage,
    String status,
    String? trend,
    double? previousValue,
  });
}

/// @nodoc
class __$$PerformanceMetricsImplCopyWithImpl<$Res>
    extends _$PerformanceMetricsCopyWithImpl<$Res, _$PerformanceMetricsImpl>
    implements _$$PerformanceMetricsImplCopyWith<$Res> {
  __$$PerformanceMetricsImplCopyWithImpl(
    _$PerformanceMetricsImpl _value,
    $Res Function(_$PerformanceMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metricName = null,
    Object? value = null,
    Object? target = null,
    Object? percentage = null,
    Object? status = null,
    Object? trend = freezed,
    Object? previousValue = freezed,
  }) {
    return _then(
      _$PerformanceMetricsImpl(
        metricName: null == metricName
            ? _value.metricName
            : metricName // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        target: null == target
            ? _value.target
            : target // ignore: cast_nullable_to_non_nullable
                  as double,
        percentage: null == percentage
            ? _value.percentage
            : percentage // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        trend: freezed == trend
            ? _value.trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as String?,
        previousValue: freezed == previousValue
            ? _value.previousValue
            : previousValue // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformanceMetricsImpl implements _PerformanceMetrics {
  const _$PerformanceMetricsImpl({
    required this.metricName,
    required this.value,
    required this.target,
    required this.percentage,
    required this.status,
    this.trend,
    this.previousValue,
  });

  factory _$PerformanceMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformanceMetricsImplFromJson(json);

  @override
  final String metricName;
  @override
  final double value;
  @override
  final double target;
  @override
  final double percentage;
  // value/target * 100
  @override
  final String status;
  // "on-track", "below-target", "exceeding"
  @override
  final String? trend;
  // "up", "down", "stable"
  @override
  final double? previousValue;

  @override
  String toString() {
    return 'PerformanceMetrics(metricName: $metricName, value: $value, target: $target, percentage: $percentage, status: $status, trend: $trend, previousValue: $previousValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceMetricsImpl &&
            (identical(other.metricName, metricName) ||
                other.metricName == metricName) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            (identical(other.previousValue, previousValue) ||
                other.previousValue == previousValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    metricName,
    value,
    target,
    percentage,
    status,
    trend,
    previousValue,
  );

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      __$$PerformanceMetricsImplCopyWithImpl<_$PerformanceMetricsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PerformanceMetricsImplToJson(this);
  }
}

abstract class _PerformanceMetrics implements PerformanceMetrics {
  const factory _PerformanceMetrics({
    required final String metricName,
    required final double value,
    required final double target,
    required final double percentage,
    required final String status,
    final String? trend,
    final double? previousValue,
  }) = _$PerformanceMetricsImpl;

  factory _PerformanceMetrics.fromJson(Map<String, dynamic> json) =
      _$PerformanceMetricsImpl.fromJson;

  @override
  String get metricName;
  @override
  double get value;
  @override
  double get target;
  @override
  double get percentage; // value/target * 100
  @override
  String get status; // "on-track", "below-target", "exceeding"
  @override
  String? get trend; // "up", "down", "stable"
  @override
  double? get previousValue;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeSchedule _$EmployeeScheduleFromJson(Map<String, dynamic> json) {
  return _EmployeeSchedule.fromJson(json);
}

/// @nodoc
mixin _$EmployeeSchedule {
  String get employeeId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get dayName =>
      throw _privateConstructorUsedError; // "Montag", "Dienstag", etc.
  double get scheduledHours => throw _privateConstructorUsedError;
  double get workedHours => throw _privateConstructorUsedError;
  int get appointmentCount => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  bool get isWorkDay => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this EmployeeSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeScheduleCopyWith<EmployeeSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeScheduleCopyWith<$Res> {
  factory $EmployeeScheduleCopyWith(
    EmployeeSchedule value,
    $Res Function(EmployeeSchedule) then,
  ) = _$EmployeeScheduleCopyWithImpl<$Res, EmployeeSchedule>;
  @useResult
  $Res call({
    String employeeId,
    DateTime date,
    String dayName,
    double scheduledHours,
    double workedHours,
    int appointmentCount,
    double totalRevenue,
    bool isWorkDay,
    String? notes,
  });
}

/// @nodoc
class _$EmployeeScheduleCopyWithImpl<$Res, $Val extends EmployeeSchedule>
    implements $EmployeeScheduleCopyWith<$Res> {
  _$EmployeeScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? date = null,
    Object? dayName = null,
    Object? scheduledHours = null,
    Object? workedHours = null,
    Object? appointmentCount = null,
    Object? totalRevenue = null,
    Object? isWorkDay = null,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dayName: null == dayName
                ? _value.dayName
                : dayName // ignore: cast_nullable_to_non_nullable
                      as String,
            scheduledHours: null == scheduledHours
                ? _value.scheduledHours
                : scheduledHours // ignore: cast_nullable_to_non_nullable
                      as double,
            workedHours: null == workedHours
                ? _value.workedHours
                : workedHours // ignore: cast_nullable_to_non_nullable
                      as double,
            appointmentCount: null == appointmentCount
                ? _value.appointmentCount
                : appointmentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            isWorkDay: null == isWorkDay
                ? _value.isWorkDay
                : isWorkDay // ignore: cast_nullable_to_non_nullable
                      as bool,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeScheduleImplCopyWith<$Res>
    implements $EmployeeScheduleCopyWith<$Res> {
  factory _$$EmployeeScheduleImplCopyWith(
    _$EmployeeScheduleImpl value,
    $Res Function(_$EmployeeScheduleImpl) then,
  ) = __$$EmployeeScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String employeeId,
    DateTime date,
    String dayName,
    double scheduledHours,
    double workedHours,
    int appointmentCount,
    double totalRevenue,
    bool isWorkDay,
    String? notes,
  });
}

/// @nodoc
class __$$EmployeeScheduleImplCopyWithImpl<$Res>
    extends _$EmployeeScheduleCopyWithImpl<$Res, _$EmployeeScheduleImpl>
    implements _$$EmployeeScheduleImplCopyWith<$Res> {
  __$$EmployeeScheduleImplCopyWithImpl(
    _$EmployeeScheduleImpl _value,
    $Res Function(_$EmployeeScheduleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? date = null,
    Object? dayName = null,
    Object? scheduledHours = null,
    Object? workedHours = null,
    Object? appointmentCount = null,
    Object? totalRevenue = null,
    Object? isWorkDay = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$EmployeeScheduleImpl(
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dayName: null == dayName
            ? _value.dayName
            : dayName // ignore: cast_nullable_to_non_nullable
                  as String,
        scheduledHours: null == scheduledHours
            ? _value.scheduledHours
            : scheduledHours // ignore: cast_nullable_to_non_nullable
                  as double,
        workedHours: null == workedHours
            ? _value.workedHours
            : workedHours // ignore: cast_nullable_to_non_nullable
                  as double,
        appointmentCount: null == appointmentCount
            ? _value.appointmentCount
            : appointmentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        isWorkDay: null == isWorkDay
            ? _value.isWorkDay
            : isWorkDay // ignore: cast_nullable_to_non_nullable
                  as bool,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeScheduleImpl implements _EmployeeSchedule {
  const _$EmployeeScheduleImpl({
    required this.employeeId,
    required this.date,
    required this.dayName,
    required this.scheduledHours,
    required this.workedHours,
    required this.appointmentCount,
    required this.totalRevenue,
    required this.isWorkDay,
    this.notes,
  });

  factory _$EmployeeScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeScheduleImplFromJson(json);

  @override
  final String employeeId;
  @override
  final DateTime date;
  @override
  final String dayName;
  // "Montag", "Dienstag", etc.
  @override
  final double scheduledHours;
  @override
  final double workedHours;
  @override
  final int appointmentCount;
  @override
  final double totalRevenue;
  @override
  final bool isWorkDay;
  @override
  final String? notes;

  @override
  String toString() {
    return 'EmployeeSchedule(employeeId: $employeeId, date: $date, dayName: $dayName, scheduledHours: $scheduledHours, workedHours: $workedHours, appointmentCount: $appointmentCount, totalRevenue: $totalRevenue, isWorkDay: $isWorkDay, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeScheduleImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dayName, dayName) || other.dayName == dayName) &&
            (identical(other.scheduledHours, scheduledHours) ||
                other.scheduledHours == scheduledHours) &&
            (identical(other.workedHours, workedHours) ||
                other.workedHours == workedHours) &&
            (identical(other.appointmentCount, appointmentCount) ||
                other.appointmentCount == appointmentCount) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.isWorkDay, isWorkDay) ||
                other.isWorkDay == isWorkDay) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeeId,
    date,
    dayName,
    scheduledHours,
    workedHours,
    appointmentCount,
    totalRevenue,
    isWorkDay,
    notes,
  );

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeScheduleImplCopyWith<_$EmployeeScheduleImpl> get copyWith =>
      __$$EmployeeScheduleImplCopyWithImpl<_$EmployeeScheduleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeScheduleImplToJson(this);
  }
}

abstract class _EmployeeSchedule implements EmployeeSchedule {
  const factory _EmployeeSchedule({
    required final String employeeId,
    required final DateTime date,
    required final String dayName,
    required final double scheduledHours,
    required final double workedHours,
    required final int appointmentCount,
    required final double totalRevenue,
    required final bool isWorkDay,
    final String? notes,
  }) = _$EmployeeScheduleImpl;

  factory _EmployeeSchedule.fromJson(Map<String, dynamic> json) =
      _$EmployeeScheduleImpl.fromJson;

  @override
  String get employeeId;
  @override
  DateTime get date;
  @override
  String get dayName; // "Montag", "Dienstag", etc.
  @override
  double get scheduledHours;
  @override
  double get workedHours;
  @override
  int get appointmentCount;
  @override
  double get totalRevenue;
  @override
  bool get isWorkDay;
  @override
  String? get notes;

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeScheduleImplCopyWith<_$EmployeeScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AttendanceRecord _$AttendanceRecordFromJson(Map<String, dynamic> json) {
  return _AttendanceRecord.fromJson(json);
}

/// @nodoc
mixin _$AttendanceRecord {
  String get employeeId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // "present", "absent", "late", "early-leave", "on-leave"
  DateTime? get checkInTime => throw _privateConstructorUsedError;
  DateTime? get checkOutTime => throw _privateConstructorUsedError;
  double? get hoursWorked => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this AttendanceRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceRecordCopyWith<AttendanceRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceRecordCopyWith<$Res> {
  factory $AttendanceRecordCopyWith(
    AttendanceRecord value,
    $Res Function(AttendanceRecord) then,
  ) = _$AttendanceRecordCopyWithImpl<$Res, AttendanceRecord>;
  @useResult
  $Res call({
    String employeeId,
    DateTime date,
    String status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? hoursWorked,
    String? notes,
  });
}

/// @nodoc
class _$AttendanceRecordCopyWithImpl<$Res, $Val extends AttendanceRecord>
    implements $AttendanceRecordCopyWith<$Res> {
  _$AttendanceRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? date = null,
    Object? status = null,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? hoursWorked = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            checkInTime: freezed == checkInTime
                ? _value.checkInTime
                : checkInTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            checkOutTime: freezed == checkOutTime
                ? _value.checkOutTime
                : checkOutTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            hoursWorked: freezed == hoursWorked
                ? _value.hoursWorked
                : hoursWorked // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttendanceRecordImplCopyWith<$Res>
    implements $AttendanceRecordCopyWith<$Res> {
  factory _$$AttendanceRecordImplCopyWith(
    _$AttendanceRecordImpl value,
    $Res Function(_$AttendanceRecordImpl) then,
  ) = __$$AttendanceRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String employeeId,
    DateTime date,
    String status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? hoursWorked,
    String? notes,
  });
}

/// @nodoc
class __$$AttendanceRecordImplCopyWithImpl<$Res>
    extends _$AttendanceRecordCopyWithImpl<$Res, _$AttendanceRecordImpl>
    implements _$$AttendanceRecordImplCopyWith<$Res> {
  __$$AttendanceRecordImplCopyWithImpl(
    _$AttendanceRecordImpl _value,
    $Res Function(_$AttendanceRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? date = null,
    Object? status = null,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? hoursWorked = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$AttendanceRecordImpl(
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        checkInTime: freezed == checkInTime
            ? _value.checkInTime
            : checkInTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        checkOutTime: freezed == checkOutTime
            ? _value.checkOutTime
            : checkOutTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        hoursWorked: freezed == hoursWorked
            ? _value.hoursWorked
            : hoursWorked // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceRecordImpl implements _AttendanceRecord {
  const _$AttendanceRecordImpl({
    required this.employeeId,
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.hoursWorked,
    this.notes,
  });

  factory _$AttendanceRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceRecordImplFromJson(json);

  @override
  final String employeeId;
  @override
  final DateTime date;
  @override
  final String status;
  // "present", "absent", "late", "early-leave", "on-leave"
  @override
  final DateTime? checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final double? hoursWorked;
  @override
  final String? notes;

  @override
  String toString() {
    return 'AttendanceRecord(employeeId: $employeeId, date: $date, status: $status, checkInTime: $checkInTime, checkOutTime: $checkOutTime, hoursWorked: $hoursWorked, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceRecordImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.hoursWorked, hoursWorked) ||
                other.hoursWorked == hoursWorked) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeeId,
    date,
    status,
    checkInTime,
    checkOutTime,
    hoursWorked,
    notes,
  );

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceRecordImplCopyWith<_$AttendanceRecordImpl> get copyWith =>
      __$$AttendanceRecordImplCopyWithImpl<_$AttendanceRecordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceRecordImplToJson(this);
  }
}

abstract class _AttendanceRecord implements AttendanceRecord {
  const factory _AttendanceRecord({
    required final String employeeId,
    required final DateTime date,
    required final String status,
    final DateTime? checkInTime,
    final DateTime? checkOutTime,
    final double? hoursWorked,
    final String? notes,
  }) = _$AttendanceRecordImpl;

  factory _AttendanceRecord.fromJson(Map<String, dynamic> json) =
      _$AttendanceRecordImpl.fromJson;

  @override
  String get employeeId;
  @override
  DateTime get date;
  @override
  String get status; // "present", "absent", "late", "early-leave", "on-leave"
  @override
  DateTime? get checkInTime;
  @override
  DateTime? get checkOutTime;
  @override
  double? get hoursWorked;
  @override
  String? get notes;

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceRecordImplCopyWith<_$AttendanceRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeSkill _$EmployeeSkillFromJson(Map<String, dynamic> json) {
  return _EmployeeSkill.fromJson(json);
}

/// @nodoc
mixin _$EmployeeSkill {
  String get skillId => throw _privateConstructorUsedError;
  String get skillName => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // "service", "tool", "language", "certification"
  int get proficiencyLevel => throw _privateConstructorUsedError; // 1-5
  DateTime? get acquiredDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String? get certification => throw _privateConstructorUsedError;

  /// Serializes this EmployeeSkill to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeSkill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeSkillCopyWith<EmployeeSkill> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeSkillCopyWith<$Res> {
  factory $EmployeeSkillCopyWith(
    EmployeeSkill value,
    $Res Function(EmployeeSkill) then,
  ) = _$EmployeeSkillCopyWithImpl<$Res, EmployeeSkill>;
  @useResult
  $Res call({
    String skillId,
    String skillName,
    String category,
    int proficiencyLevel,
    DateTime? acquiredDate,
    DateTime? expiryDate,
    String? certification,
  });
}

/// @nodoc
class _$EmployeeSkillCopyWithImpl<$Res, $Val extends EmployeeSkill>
    implements $EmployeeSkillCopyWith<$Res> {
  _$EmployeeSkillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeSkill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skillId = null,
    Object? skillName = null,
    Object? category = null,
    Object? proficiencyLevel = null,
    Object? acquiredDate = freezed,
    Object? expiryDate = freezed,
    Object? certification = freezed,
  }) {
    return _then(
      _value.copyWith(
            skillId: null == skillId
                ? _value.skillId
                : skillId // ignore: cast_nullable_to_non_nullable
                      as String,
            skillName: null == skillName
                ? _value.skillName
                : skillName // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            proficiencyLevel: null == proficiencyLevel
                ? _value.proficiencyLevel
                : proficiencyLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            acquiredDate: freezed == acquiredDate
                ? _value.acquiredDate
                : acquiredDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            certification: freezed == certification
                ? _value.certification
                : certification // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeSkillImplCopyWith<$Res>
    implements $EmployeeSkillCopyWith<$Res> {
  factory _$$EmployeeSkillImplCopyWith(
    _$EmployeeSkillImpl value,
    $Res Function(_$EmployeeSkillImpl) then,
  ) = __$$EmployeeSkillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String skillId,
    String skillName,
    String category,
    int proficiencyLevel,
    DateTime? acquiredDate,
    DateTime? expiryDate,
    String? certification,
  });
}

/// @nodoc
class __$$EmployeeSkillImplCopyWithImpl<$Res>
    extends _$EmployeeSkillCopyWithImpl<$Res, _$EmployeeSkillImpl>
    implements _$$EmployeeSkillImplCopyWith<$Res> {
  __$$EmployeeSkillImplCopyWithImpl(
    _$EmployeeSkillImpl _value,
    $Res Function(_$EmployeeSkillImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeSkill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skillId = null,
    Object? skillName = null,
    Object? category = null,
    Object? proficiencyLevel = null,
    Object? acquiredDate = freezed,
    Object? expiryDate = freezed,
    Object? certification = freezed,
  }) {
    return _then(
      _$EmployeeSkillImpl(
        skillId: null == skillId
            ? _value.skillId
            : skillId // ignore: cast_nullable_to_non_nullable
                  as String,
        skillName: null == skillName
            ? _value.skillName
            : skillName // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        proficiencyLevel: null == proficiencyLevel
            ? _value.proficiencyLevel
            : proficiencyLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        acquiredDate: freezed == acquiredDate
            ? _value.acquiredDate
            : acquiredDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        certification: freezed == certification
            ? _value.certification
            : certification // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeSkillImpl implements _EmployeeSkill {
  const _$EmployeeSkillImpl({
    required this.skillId,
    required this.skillName,
    required this.category,
    required this.proficiencyLevel,
    this.acquiredDate,
    this.expiryDate,
    this.certification,
  });

  factory _$EmployeeSkillImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeSkillImplFromJson(json);

  @override
  final String skillId;
  @override
  final String skillName;
  @override
  final String category;
  // "service", "tool", "language", "certification"
  @override
  final int proficiencyLevel;
  // 1-5
  @override
  final DateTime? acquiredDate;
  @override
  final DateTime? expiryDate;
  @override
  final String? certification;

  @override
  String toString() {
    return 'EmployeeSkill(skillId: $skillId, skillName: $skillName, category: $category, proficiencyLevel: $proficiencyLevel, acquiredDate: $acquiredDate, expiryDate: $expiryDate, certification: $certification)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeSkillImpl &&
            (identical(other.skillId, skillId) || other.skillId == skillId) &&
            (identical(other.skillName, skillName) ||
                other.skillName == skillName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.proficiencyLevel, proficiencyLevel) ||
                other.proficiencyLevel == proficiencyLevel) &&
            (identical(other.acquiredDate, acquiredDate) ||
                other.acquiredDate == acquiredDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.certification, certification) ||
                other.certification == certification));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    skillId,
    skillName,
    category,
    proficiencyLevel,
    acquiredDate,
    expiryDate,
    certification,
  );

  /// Create a copy of EmployeeSkill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeSkillImplCopyWith<_$EmployeeSkillImpl> get copyWith =>
      __$$EmployeeSkillImplCopyWithImpl<_$EmployeeSkillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeSkillImplToJson(this);
  }
}

abstract class _EmployeeSkill implements EmployeeSkill {
  const factory _EmployeeSkill({
    required final String skillId,
    required final String skillName,
    required final String category,
    required final int proficiencyLevel,
    final DateTime? acquiredDate,
    final DateTime? expiryDate,
    final String? certification,
  }) = _$EmployeeSkillImpl;

  factory _EmployeeSkill.fromJson(Map<String, dynamic> json) =
      _$EmployeeSkillImpl.fromJson;

  @override
  String get skillId;
  @override
  String get skillName;
  @override
  String get category; // "service", "tool", "language", "certification"
  @override
  int get proficiencyLevel; // 1-5
  @override
  DateTime? get acquiredDate;
  @override
  DateTime? get expiryDate;
  @override
  String? get certification;

  /// Create a copy of EmployeeSkill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeSkillImplCopyWith<_$EmployeeSkillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeStats _$EmployeeStatsFromJson(Map<String, dynamic> json) {
  return _EmployeeStats.fromJson(json);
}

/// @nodoc
mixin _$EmployeeStats {
  int get totalEmployees => throw _privateConstructorUsedError;
  int get activeEmployees => throw _privateConstructorUsedError;
  int get onLeaveCount => throw _privateConstructorUsedError;
  int get newEmployeesThisMonth => throw _privateConstructorUsedError;
  double get averageSalonRating => throw _privateConstructorUsedError;
  double get totalRevenueThisMonth => throw _privateConstructorUsedError;
  double get averageRevenuePerEmployee => throw _privateConstructorUsedError;
  int get totalAppointmentsThisMonth => throw _privateConstructorUsedError;

  /// Serializes this EmployeeStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeStatsCopyWith<EmployeeStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeStatsCopyWith<$Res> {
  factory $EmployeeStatsCopyWith(
    EmployeeStats value,
    $Res Function(EmployeeStats) then,
  ) = _$EmployeeStatsCopyWithImpl<$Res, EmployeeStats>;
  @useResult
  $Res call({
    int totalEmployees,
    int activeEmployees,
    int onLeaveCount,
    int newEmployeesThisMonth,
    double averageSalonRating,
    double totalRevenueThisMonth,
    double averageRevenuePerEmployee,
    int totalAppointmentsThisMonth,
  });
}

/// @nodoc
class _$EmployeeStatsCopyWithImpl<$Res, $Val extends EmployeeStats>
    implements $EmployeeStatsCopyWith<$Res> {
  _$EmployeeStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEmployees = null,
    Object? activeEmployees = null,
    Object? onLeaveCount = null,
    Object? newEmployeesThisMonth = null,
    Object? averageSalonRating = null,
    Object? totalRevenueThisMonth = null,
    Object? averageRevenuePerEmployee = null,
    Object? totalAppointmentsThisMonth = null,
  }) {
    return _then(
      _value.copyWith(
            totalEmployees: null == totalEmployees
                ? _value.totalEmployees
                : totalEmployees // ignore: cast_nullable_to_non_nullable
                      as int,
            activeEmployees: null == activeEmployees
                ? _value.activeEmployees
                : activeEmployees // ignore: cast_nullable_to_non_nullable
                      as int,
            onLeaveCount: null == onLeaveCount
                ? _value.onLeaveCount
                : onLeaveCount // ignore: cast_nullable_to_non_nullable
                      as int,
            newEmployeesThisMonth: null == newEmployeesThisMonth
                ? _value.newEmployeesThisMonth
                : newEmployeesThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            averageSalonRating: null == averageSalonRating
                ? _value.averageSalonRating
                : averageSalonRating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalRevenueThisMonth: null == totalRevenueThisMonth
                ? _value.totalRevenueThisMonth
                : totalRevenueThisMonth // ignore: cast_nullable_to_non_nullable
                      as double,
            averageRevenuePerEmployee: null == averageRevenuePerEmployee
                ? _value.averageRevenuePerEmployee
                : averageRevenuePerEmployee // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAppointmentsThisMonth: null == totalAppointmentsThisMonth
                ? _value.totalAppointmentsThisMonth
                : totalAppointmentsThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeStatsImplCopyWith<$Res>
    implements $EmployeeStatsCopyWith<$Res> {
  factory _$$EmployeeStatsImplCopyWith(
    _$EmployeeStatsImpl value,
    $Res Function(_$EmployeeStatsImpl) then,
  ) = __$$EmployeeStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalEmployees,
    int activeEmployees,
    int onLeaveCount,
    int newEmployeesThisMonth,
    double averageSalonRating,
    double totalRevenueThisMonth,
    double averageRevenuePerEmployee,
    int totalAppointmentsThisMonth,
  });
}

/// @nodoc
class __$$EmployeeStatsImplCopyWithImpl<$Res>
    extends _$EmployeeStatsCopyWithImpl<$Res, _$EmployeeStatsImpl>
    implements _$$EmployeeStatsImplCopyWith<$Res> {
  __$$EmployeeStatsImplCopyWithImpl(
    _$EmployeeStatsImpl _value,
    $Res Function(_$EmployeeStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEmployees = null,
    Object? activeEmployees = null,
    Object? onLeaveCount = null,
    Object? newEmployeesThisMonth = null,
    Object? averageSalonRating = null,
    Object? totalRevenueThisMonth = null,
    Object? averageRevenuePerEmployee = null,
    Object? totalAppointmentsThisMonth = null,
  }) {
    return _then(
      _$EmployeeStatsImpl(
        totalEmployees: null == totalEmployees
            ? _value.totalEmployees
            : totalEmployees // ignore: cast_nullable_to_non_nullable
                  as int,
        activeEmployees: null == activeEmployees
            ? _value.activeEmployees
            : activeEmployees // ignore: cast_nullable_to_non_nullable
                  as int,
        onLeaveCount: null == onLeaveCount
            ? _value.onLeaveCount
            : onLeaveCount // ignore: cast_nullable_to_non_nullable
                  as int,
        newEmployeesThisMonth: null == newEmployeesThisMonth
            ? _value.newEmployeesThisMonth
            : newEmployeesThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        averageSalonRating: null == averageSalonRating
            ? _value.averageSalonRating
            : averageSalonRating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalRevenueThisMonth: null == totalRevenueThisMonth
            ? _value.totalRevenueThisMonth
            : totalRevenueThisMonth // ignore: cast_nullable_to_non_nullable
                  as double,
        averageRevenuePerEmployee: null == averageRevenuePerEmployee
            ? _value.averageRevenuePerEmployee
            : averageRevenuePerEmployee // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAppointmentsThisMonth: null == totalAppointmentsThisMonth
            ? _value.totalAppointmentsThisMonth
            : totalAppointmentsThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeStatsImpl implements _EmployeeStats {
  const _$EmployeeStatsImpl({
    required this.totalEmployees,
    required this.activeEmployees,
    required this.onLeaveCount,
    required this.newEmployeesThisMonth,
    required this.averageSalonRating,
    required this.totalRevenueThisMonth,
    required this.averageRevenuePerEmployee,
    required this.totalAppointmentsThisMonth,
  });

  factory _$EmployeeStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeStatsImplFromJson(json);

  @override
  final int totalEmployees;
  @override
  final int activeEmployees;
  @override
  final int onLeaveCount;
  @override
  final int newEmployeesThisMonth;
  @override
  final double averageSalonRating;
  @override
  final double totalRevenueThisMonth;
  @override
  final double averageRevenuePerEmployee;
  @override
  final int totalAppointmentsThisMonth;

  @override
  String toString() {
    return 'EmployeeStats(totalEmployees: $totalEmployees, activeEmployees: $activeEmployees, onLeaveCount: $onLeaveCount, newEmployeesThisMonth: $newEmployeesThisMonth, averageSalonRating: $averageSalonRating, totalRevenueThisMonth: $totalRevenueThisMonth, averageRevenuePerEmployee: $averageRevenuePerEmployee, totalAppointmentsThisMonth: $totalAppointmentsThisMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeStatsImpl &&
            (identical(other.totalEmployees, totalEmployees) ||
                other.totalEmployees == totalEmployees) &&
            (identical(other.activeEmployees, activeEmployees) ||
                other.activeEmployees == activeEmployees) &&
            (identical(other.onLeaveCount, onLeaveCount) ||
                other.onLeaveCount == onLeaveCount) &&
            (identical(other.newEmployeesThisMonth, newEmployeesThisMonth) ||
                other.newEmployeesThisMonth == newEmployeesThisMonth) &&
            (identical(other.averageSalonRating, averageSalonRating) ||
                other.averageSalonRating == averageSalonRating) &&
            (identical(other.totalRevenueThisMonth, totalRevenueThisMonth) ||
                other.totalRevenueThisMonth == totalRevenueThisMonth) &&
            (identical(
                  other.averageRevenuePerEmployee,
                  averageRevenuePerEmployee,
                ) ||
                other.averageRevenuePerEmployee == averageRevenuePerEmployee) &&
            (identical(
                  other.totalAppointmentsThisMonth,
                  totalAppointmentsThisMonth,
                ) ||
                other.totalAppointmentsThisMonth ==
                    totalAppointmentsThisMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalEmployees,
    activeEmployees,
    onLeaveCount,
    newEmployeesThisMonth,
    averageSalonRating,
    totalRevenueThisMonth,
    averageRevenuePerEmployee,
    totalAppointmentsThisMonth,
  );

  /// Create a copy of EmployeeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeStatsImplCopyWith<_$EmployeeStatsImpl> get copyWith =>
      __$$EmployeeStatsImplCopyWithImpl<_$EmployeeStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeStatsImplToJson(this);
  }
}

abstract class _EmployeeStats implements EmployeeStats {
  const factory _EmployeeStats({
    required final int totalEmployees,
    required final int activeEmployees,
    required final int onLeaveCount,
    required final int newEmployeesThisMonth,
    required final double averageSalonRating,
    required final double totalRevenueThisMonth,
    required final double averageRevenuePerEmployee,
    required final int totalAppointmentsThisMonth,
  }) = _$EmployeeStatsImpl;

  factory _EmployeeStats.fromJson(Map<String, dynamic> json) =
      _$EmployeeStatsImpl.fromJson;

  @override
  int get totalEmployees;
  @override
  int get activeEmployees;
  @override
  int get onLeaveCount;
  @override
  int get newEmployeesThisMonth;
  @override
  double get averageSalonRating;
  @override
  double get totalRevenueThisMonth;
  @override
  double get averageRevenuePerEmployee;
  @override
  int get totalAppointmentsThisMonth;

  /// Create a copy of EmployeeStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeStatsImplCopyWith<_$EmployeeStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
