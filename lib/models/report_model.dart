import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class ReportData with _$ReportData {
  const factory ReportData({
    required int totalEmployees,
    required double totalRevenue,
    required int totalBookings,
    required int totalCustomers,
    required double avgBookingValue,
    required List<ChartData> revenueByMonth,
    required List<ChartData> bookingsByService,
  }) = _ReportData;

  factory ReportData.fromJson(Map<String, dynamic> json) => _$ReportDataFromJson(json);
}

@freezed
class ChartData with _$ChartData {
  const factory ChartData({
    required String label,
    required double value,
  }) = _ChartData;

  factory ChartData.fromJson(Map<String, dynamic> json) => _$ChartDataFromJson(json);
}
