// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportDataImpl _$$ReportDataImplFromJson(Map<String, dynamic> json) =>
    _$ReportDataImpl(
      totalEmployees: (json['totalEmployees'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalBookings: (json['totalBookings'] as num).toInt(),
      totalCustomers: (json['totalCustomers'] as num).toInt(),
      avgBookingValue: (json['avgBookingValue'] as num).toDouble(),
      revenueByMonth: (json['revenueByMonth'] as List<dynamic>)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookingsByService: (json['bookingsByService'] as List<dynamic>)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ReportDataImplToJson(_$ReportDataImpl instance) =>
    <String, dynamic>{
      'totalEmployees': instance.totalEmployees,
      'totalRevenue': instance.totalRevenue,
      'totalBookings': instance.totalBookings,
      'totalCustomers': instance.totalCustomers,
      'avgBookingValue': instance.avgBookingValue,
      'revenueByMonth': instance.revenueByMonth,
      'bookingsByService': instance.bookingsByService,
    };

_$ChartDataImpl _$$ChartDataImplFromJson(Map<String, dynamic> json) =>
    _$ChartDataImpl(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$$ChartDataImplToJson(_$ChartDataImpl instance) =>
    <String, dynamic>{'label': instance.label, 'value': instance.value};
