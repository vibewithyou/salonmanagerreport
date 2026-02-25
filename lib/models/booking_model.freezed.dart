// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Appointment _$AppointmentFromJson(Map<String, dynamic> json) {
  return _Appointment.fromJson(json);
}

/// @nodoc
mixin _$Appointment {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  String get stylistId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  DateTime get appointmentDate => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  bool? get termsAccepted => throw _privateConstructorUsedError;
  bool? get privacyAccepted => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get bookingReference => throw _privateConstructorUsedError;

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentCopyWith<Appointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentCopyWith<$Res> {
  factory $AppointmentCopyWith(
    Appointment value,
    $Res Function(Appointment) then,
  ) = _$AppointmentCopyWithImpl<$Res, Appointment>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String serviceId,
    String stylistId,
    String customerId,
    DateTime appointmentDate,
    int durationMinutes,
    double price,
    String? notes,
    List<String>? images,
    BookingStatus status,
    bool? termsAccepted,
    bool? privacyAccepted,
    DateTime createdAt,
    DateTime? updatedAt,
    String? bookingReference,
  });
}

/// @nodoc
class _$AppointmentCopyWithImpl<$Res, $Val extends Appointment>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? serviceId = null,
    Object? stylistId = null,
    Object? customerId = null,
    Object? appointmentDate = null,
    Object? durationMinutes = null,
    Object? price = null,
    Object? notes = freezed,
    Object? images = freezed,
    Object? status = null,
    Object? termsAccepted = freezed,
    Object? privacyAccepted = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? bookingReference = freezed,
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
            serviceId: null == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            stylistId: null == stylistId
                ? _value.stylistId
                : stylistId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            appointmentDate: null == appointmentDate
                ? _value.appointmentDate
                : appointmentDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BookingStatus,
            termsAccepted: freezed == termsAccepted
                ? _value.termsAccepted
                : termsAccepted // ignore: cast_nullable_to_non_nullable
                      as bool?,
            privacyAccepted: freezed == privacyAccepted
                ? _value.privacyAccepted
                : privacyAccepted // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            bookingReference: freezed == bookingReference
                ? _value.bookingReference
                : bookingReference // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentImplCopyWith<$Res>
    implements $AppointmentCopyWith<$Res> {
  factory _$$AppointmentImplCopyWith(
    _$AppointmentImpl value,
    $Res Function(_$AppointmentImpl) then,
  ) = __$$AppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String serviceId,
    String stylistId,
    String customerId,
    DateTime appointmentDate,
    int durationMinutes,
    double price,
    String? notes,
    List<String>? images,
    BookingStatus status,
    bool? termsAccepted,
    bool? privacyAccepted,
    DateTime createdAt,
    DateTime? updatedAt,
    String? bookingReference,
  });
}

/// @nodoc
class __$$AppointmentImplCopyWithImpl<$Res>
    extends _$AppointmentCopyWithImpl<$Res, _$AppointmentImpl>
    implements _$$AppointmentImplCopyWith<$Res> {
  __$$AppointmentImplCopyWithImpl(
    _$AppointmentImpl _value,
    $Res Function(_$AppointmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? serviceId = null,
    Object? stylistId = null,
    Object? customerId = null,
    Object? appointmentDate = null,
    Object? durationMinutes = null,
    Object? price = null,
    Object? notes = freezed,
    Object? images = freezed,
    Object? status = null,
    Object? termsAccepted = freezed,
    Object? privacyAccepted = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? bookingReference = freezed,
  }) {
    return _then(
      _$AppointmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceId: null == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        stylistId: null == stylistId
            ? _value.stylistId
            : stylistId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        appointmentDate: null == appointmentDate
            ? _value.appointmentDate
            : appointmentDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: freezed == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BookingStatus,
        termsAccepted: freezed == termsAccepted
            ? _value.termsAccepted
            : termsAccepted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        privacyAccepted: freezed == privacyAccepted
            ? _value.privacyAccepted
            : privacyAccepted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        bookingReference: freezed == bookingReference
            ? _value.bookingReference
            : bookingReference // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentImpl implements _Appointment {
  const _$AppointmentImpl({
    required this.id,
    required this.salonId,
    required this.serviceId,
    required this.stylistId,
    required this.customerId,
    required this.appointmentDate,
    required this.durationMinutes,
    required this.price,
    required this.notes,
    required final List<String>? images,
    required this.status,
    required this.termsAccepted,
    required this.privacyAccepted,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingReference,
  }) : _images = images;

  factory _$AppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String serviceId;
  @override
  final String stylistId;
  @override
  final String customerId;
  @override
  final DateTime appointmentDate;
  @override
  final int durationMinutes;
  @override
  final double price;
  @override
  final String? notes;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final BookingStatus status;
  @override
  final bool? termsAccepted;
  @override
  final bool? privacyAccepted;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? bookingReference;

  @override
  String toString() {
    return 'Appointment(id: $id, salonId: $salonId, serviceId: $serviceId, stylistId: $stylistId, customerId: $customerId, appointmentDate: $appointmentDate, durationMinutes: $durationMinutes, price: $price, notes: $notes, images: $images, status: $status, termsAccepted: $termsAccepted, privacyAccepted: $privacyAccepted, createdAt: $createdAt, updatedAt: $updatedAt, bookingReference: $bookingReference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.stylistId, stylistId) ||
                other.stylistId == stylistId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.appointmentDate, appointmentDate) ||
                other.appointmentDate == appointmentDate) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.termsAccepted, termsAccepted) ||
                other.termsAccepted == termsAccepted) &&
            (identical(other.privacyAccepted, privacyAccepted) ||
                other.privacyAccepted == privacyAccepted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.bookingReference, bookingReference) ||
                other.bookingReference == bookingReference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    serviceId,
    stylistId,
    customerId,
    appointmentDate,
    durationMinutes,
    price,
    notes,
    const DeepCollectionEquality().hash(_images),
    status,
    termsAccepted,
    privacyAccepted,
    createdAt,
    updatedAt,
    bookingReference,
  );

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      __$$AppointmentImplCopyWithImpl<_$AppointmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentImplToJson(this);
  }
}

abstract class _Appointment implements Appointment {
  const factory _Appointment({
    required final String id,
    required final String salonId,
    required final String serviceId,
    required final String stylistId,
    required final String customerId,
    required final DateTime appointmentDate,
    required final int durationMinutes,
    required final double price,
    required final String? notes,
    required final List<String>? images,
    required final BookingStatus status,
    required final bool? termsAccepted,
    required final bool? privacyAccepted,
    required final DateTime createdAt,
    required final DateTime? updatedAt,
    required final String? bookingReference,
  }) = _$AppointmentImpl;

  factory _Appointment.fromJson(Map<String, dynamic> json) =
      _$AppointmentImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get serviceId;
  @override
  String get stylistId;
  @override
  String get customerId;
  @override
  DateTime get appointmentDate;
  @override
  int get durationMinutes;
  @override
  double get price;
  @override
  String? get notes;
  @override
  List<String>? get images;
  @override
  BookingStatus get status;
  @override
  bool? get termsAccepted;
  @override
  bool? get privacyAccepted;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get bookingReference;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookingWizardState {
  int get currentStep => throw _privateConstructorUsedError;
  String? get selectedSalonId => throw _privateConstructorUsedError;
  String? get selectedServiceId => throw _privateConstructorUsedError;
  String? get selectedStylistId => throw _privateConstructorUsedError;
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  TimeOfDay? get selectedTime => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get imageUrls => throw _privateConstructorUsedError;
  bool get termsAccepted => throw _privateConstructorUsedError;
  bool get privacyAccepted => throw _privateConstructorUsedError;
  Map<String, dynamic> get validationErrors =>
      throw _privateConstructorUsedError;

  /// Create a copy of BookingWizardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingWizardStateCopyWith<BookingWizardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingWizardStateCopyWith<$Res> {
  factory $BookingWizardStateCopyWith(
    BookingWizardState value,
    $Res Function(BookingWizardState) then,
  ) = _$BookingWizardStateCopyWithImpl<$Res, BookingWizardState>;
  @useResult
  $Res call({
    int currentStep,
    String? selectedSalonId,
    String? selectedServiceId,
    String? selectedStylistId,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? notes,
    List<String>? imageUrls,
    bool termsAccepted,
    bool privacyAccepted,
    Map<String, dynamic> validationErrors,
  });
}

/// @nodoc
class _$BookingWizardStateCopyWithImpl<$Res, $Val extends BookingWizardState>
    implements $BookingWizardStateCopyWith<$Res> {
  _$BookingWizardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingWizardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? selectedSalonId = freezed,
    Object? selectedServiceId = freezed,
    Object? selectedStylistId = freezed,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? notes = freezed,
    Object? imageUrls = freezed,
    Object? termsAccepted = null,
    Object? privacyAccepted = null,
    Object? validationErrors = null,
  }) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            selectedSalonId: freezed == selectedSalonId
                ? _value.selectedSalonId
                : selectedSalonId // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedServiceId: freezed == selectedServiceId
                ? _value.selectedServiceId
                : selectedServiceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedStylistId: freezed == selectedStylistId
                ? _value.selectedStylistId
                : selectedStylistId // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedDate: freezed == selectedDate
                ? _value.selectedDate
                : selectedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            selectedTime: freezed == selectedTime
                ? _value.selectedTime
                : selectedTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrls: freezed == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            termsAccepted: null == termsAccepted
                ? _value.termsAccepted
                : termsAccepted // ignore: cast_nullable_to_non_nullable
                      as bool,
            privacyAccepted: null == privacyAccepted
                ? _value.privacyAccepted
                : privacyAccepted // ignore: cast_nullable_to_non_nullable
                      as bool,
            validationErrors: null == validationErrors
                ? _value.validationErrors
                : validationErrors // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingWizardStateImplCopyWith<$Res>
    implements $BookingWizardStateCopyWith<$Res> {
  factory _$$BookingWizardStateImplCopyWith(
    _$BookingWizardStateImpl value,
    $Res Function(_$BookingWizardStateImpl) then,
  ) = __$$BookingWizardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStep,
    String? selectedSalonId,
    String? selectedServiceId,
    String? selectedStylistId,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? notes,
    List<String>? imageUrls,
    bool termsAccepted,
    bool privacyAccepted,
    Map<String, dynamic> validationErrors,
  });
}

/// @nodoc
class __$$BookingWizardStateImplCopyWithImpl<$Res>
    extends _$BookingWizardStateCopyWithImpl<$Res, _$BookingWizardStateImpl>
    implements _$$BookingWizardStateImplCopyWith<$Res> {
  __$$BookingWizardStateImplCopyWithImpl(
    _$BookingWizardStateImpl _value,
    $Res Function(_$BookingWizardStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingWizardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? selectedSalonId = freezed,
    Object? selectedServiceId = freezed,
    Object? selectedStylistId = freezed,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? notes = freezed,
    Object? imageUrls = freezed,
    Object? termsAccepted = null,
    Object? privacyAccepted = null,
    Object? validationErrors = null,
  }) {
    return _then(
      _$BookingWizardStateImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        selectedSalonId: freezed == selectedSalonId
            ? _value.selectedSalonId
            : selectedSalonId // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedServiceId: freezed == selectedServiceId
            ? _value.selectedServiceId
            : selectedServiceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedStylistId: freezed == selectedStylistId
            ? _value.selectedStylistId
            : selectedStylistId // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedDate: freezed == selectedDate
            ? _value.selectedDate
            : selectedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        selectedTime: freezed == selectedTime
            ? _value.selectedTime
            : selectedTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrls: freezed == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        termsAccepted: null == termsAccepted
            ? _value.termsAccepted
            : termsAccepted // ignore: cast_nullable_to_non_nullable
                  as bool,
        privacyAccepted: null == privacyAccepted
            ? _value.privacyAccepted
            : privacyAccepted // ignore: cast_nullable_to_non_nullable
                  as bool,
        validationErrors: null == validationErrors
            ? _value._validationErrors
            : validationErrors // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc

class _$BookingWizardStateImpl implements _BookingWizardState {
  const _$BookingWizardStateImpl({
    this.currentStep = 0,
    this.selectedSalonId,
    this.selectedServiceId,
    this.selectedStylistId,
    this.selectedDate,
    this.selectedTime,
    this.notes,
    final List<String>? imageUrls,
    this.termsAccepted = false,
    this.privacyAccepted = false,
    final Map<String, dynamic> validationErrors = const {},
  }) : _imageUrls = imageUrls,
       _validationErrors = validationErrors;

  @override
  @JsonKey()
  final int currentStep;
  @override
  final String? selectedSalonId;
  @override
  final String? selectedServiceId;
  @override
  final String? selectedStylistId;
  @override
  final DateTime? selectedDate;
  @override
  final TimeOfDay? selectedTime;
  @override
  final String? notes;
  final List<String>? _imageUrls;
  @override
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool termsAccepted;
  @override
  @JsonKey()
  final bool privacyAccepted;
  final Map<String, dynamic> _validationErrors;
  @override
  @JsonKey()
  Map<String, dynamic> get validationErrors {
    if (_validationErrors is EqualUnmodifiableMapView) return _validationErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_validationErrors);
  }

  @override
  String toString() {
    return 'BookingWizardState(currentStep: $currentStep, selectedSalonId: $selectedSalonId, selectedServiceId: $selectedServiceId, selectedStylistId: $selectedStylistId, selectedDate: $selectedDate, selectedTime: $selectedTime, notes: $notes, imageUrls: $imageUrls, termsAccepted: $termsAccepted, privacyAccepted: $privacyAccepted, validationErrors: $validationErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingWizardStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.selectedSalonId, selectedSalonId) ||
                other.selectedSalonId == selectedSalonId) &&
            (identical(other.selectedServiceId, selectedServiceId) ||
                other.selectedServiceId == selectedServiceId) &&
            (identical(other.selectedStylistId, selectedStylistId) ||
                other.selectedStylistId == selectedStylistId) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.selectedTime, selectedTime) ||
                other.selectedTime == selectedTime) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.termsAccepted, termsAccepted) ||
                other.termsAccepted == termsAccepted) &&
            (identical(other.privacyAccepted, privacyAccepted) ||
                other.privacyAccepted == privacyAccepted) &&
            const DeepCollectionEquality().equals(
              other._validationErrors,
              _validationErrors,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStep,
    selectedSalonId,
    selectedServiceId,
    selectedStylistId,
    selectedDate,
    selectedTime,
    notes,
    const DeepCollectionEquality().hash(_imageUrls),
    termsAccepted,
    privacyAccepted,
    const DeepCollectionEquality().hash(_validationErrors),
  );

  /// Create a copy of BookingWizardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingWizardStateImplCopyWith<_$BookingWizardStateImpl> get copyWith =>
      __$$BookingWizardStateImplCopyWithImpl<_$BookingWizardStateImpl>(
        this,
        _$identity,
      );
}

abstract class _BookingWizardState implements BookingWizardState {
  const factory _BookingWizardState({
    final int currentStep,
    final String? selectedSalonId,
    final String? selectedServiceId,
    final String? selectedStylistId,
    final DateTime? selectedDate,
    final TimeOfDay? selectedTime,
    final String? notes,
    final List<String>? imageUrls,
    final bool termsAccepted,
    final bool privacyAccepted,
    final Map<String, dynamic> validationErrors,
  }) = _$BookingWizardStateImpl;

  @override
  int get currentStep;
  @override
  String? get selectedSalonId;
  @override
  String? get selectedServiceId;
  @override
  String? get selectedStylistId;
  @override
  DateTime? get selectedDate;
  @override
  TimeOfDay? get selectedTime;
  @override
  String? get notes;
  @override
  List<String>? get imageUrls;
  @override
  bool get termsAccepted;
  @override
  bool get privacyAccepted;
  @override
  Map<String, dynamic> get validationErrors;

  /// Create a copy of BookingWizardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingWizardStateImplCopyWith<_$BookingWizardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
