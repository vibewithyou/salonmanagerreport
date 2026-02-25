// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_dashboard_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalonServiceDtoImpl _$$SalonServiceDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SalonServiceDtoImpl(
  id: json['id'] as String,
  salonId: json['salonId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 30,
  price: (json['price'] as num).toDouble(),
  category: json['category'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  bufferBefore: (json['bufferBefore'] as num?)?.toInt() ?? 0,
  bufferAfter: (json['bufferAfter'] as num?)?.toInt() ?? 0,
  depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$$SalonServiceDtoImplToJson(
  _$SalonServiceDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'salonId': instance.salonId,
  'name': instance.name,
  'description': instance.description,
  'durationMinutes': instance.durationMinutes,
  'price': instance.price,
  'category': instance.category,
  'isActive': instance.isActive,
  'bufferBefore': instance.bufferBefore,
  'bufferAfter': instance.bufferAfter,
  'depositAmount': instance.depositAmount,
};

_$SalonCustomerDtoImpl _$$SalonCustomerDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SalonCustomerDtoImpl(
  id: json['id'] as String,
  salonId: json['salonId'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  appointments:
      (json['appointments'] as List<dynamic>?)
          ?.map(
            (e) => AppointmentSummaryDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  totalSpending: (json['totalSpending'] as num?)?.toDouble() ?? 0,
  lastVisitDate: json['lastVisitDate'] == null
      ? null
      : DateTime.parse(json['lastVisitDate'] as String),
);

Map<String, dynamic> _$$SalonCustomerDtoImplToJson(
  _$SalonCustomerDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'salonId': instance.salonId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phone': instance.phone,
  'email': instance.email,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'appointments': instance.appointments,
  'totalSpending': instance.totalSpending,
  'lastVisitDate': instance.lastVisitDate?.toIso8601String(),
};

_$AppointmentSummaryDtoImpl _$$AppointmentSummaryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentSummaryDtoImpl(
  id: json['id'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  status: json['status'] as String,
  price: (json['price'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$AppointmentSummaryDtoImplToJson(
  _$AppointmentSummaryDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'startTime': instance.startTime.toIso8601String(),
  'status': instance.status,
  'price': instance.price,
};

_$EmployeePortfolioImageDtoImpl _$$EmployeePortfolioImageDtoImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeePortfolioImageDtoImpl(
  id: json['id'] as String,
  employeeId: json['employeeId'] as String,
  imageUrl: json['imageUrl'] as String,
  caption: json['caption'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  color: json['color'] as String?,
  hairstyle: json['hairstyle'] as String?,
  mimeType: json['mimeType'] as String?,
  fileSize: (json['fileSize'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  width: (json['width'] as num?)?.toInt(),
);

Map<String, dynamic> _$$EmployeePortfolioImageDtoImplToJson(
  _$EmployeePortfolioImageDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'imageUrl': instance.imageUrl,
  'caption': instance.caption,
  'createdAt': instance.createdAt.toIso8601String(),
  'color': instance.color,
  'hairstyle': instance.hairstyle,
  'mimeType': instance.mimeType,
  'fileSize': instance.fileSize,
  'height': instance.height,
  'width': instance.width,
};

_$PastAppointmentDtoImpl _$$PastAppointmentDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PastAppointmentDtoImpl(
  id: json['id'] as String,
  customerProfileId: json['customerProfileId'] as String?,
  guestName: json['guestName'] as String?,
  guestEmail: json['guestEmail'] as String?,
  serviceId: json['serviceId'] as String?,
  startTime: DateTime.parse(json['startTime'] as String),
  status: json['status'] as String,
  price: (json['price'] as num?)?.toDouble(),
  appointmentNumber: json['appointmentNumber'] as String?,
);

Map<String, dynamic> _$$PastAppointmentDtoImplToJson(
  _$PastAppointmentDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'customerProfileId': instance.customerProfileId,
  'guestName': instance.guestName,
  'guestEmail': instance.guestEmail,
  'serviceId': instance.serviceId,
  'startTime': instance.startTime.toIso8601String(),
  'status': instance.status,
  'price': instance.price,
  'appointmentNumber': instance.appointmentNumber,
};

_$AppointmentStatisticsDtoImpl _$$AppointmentStatisticsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentStatisticsDtoImpl(
  totalAppointments: (json['totalAppointments'] as num).toInt(),
  totalCompleted: (json['totalCompleted'] as num).toInt(),
  totalCancelled: (json['totalCancelled'] as num).toInt(),
  totalRevenue: (json['totalRevenue'] as num).toDouble(),
  completionRate: (json['completionRate'] as num).toDouble(),
);

Map<String, dynamic> _$$AppointmentStatisticsDtoImplToJson(
  _$AppointmentStatisticsDtoImpl instance,
) => <String, dynamic>{
  'totalAppointments': instance.totalAppointments,
  'totalCompleted': instance.totalCompleted,
  'totalCancelled': instance.totalCancelled,
  'totalRevenue': instance.totalRevenue,
  'completionRate': instance.completionRate,
};

_$CustomerWithHistoryDtoImpl _$$CustomerWithHistoryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerWithHistoryDtoImpl(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  address: json['address'] as String?,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  appointments:
      (json['appointments'] as List<dynamic>?)
          ?.map(
            (e) => AppointmentSummaryDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerWithHistoryDtoImplToJson(
  _$CustomerWithHistoryDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'appointments': instance.appointments,
};
