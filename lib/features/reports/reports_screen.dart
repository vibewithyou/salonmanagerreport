import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/report_provider.dart';
import '../../core/theme/app_theme.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(reportDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: reportAsync.when(
        data: (report) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _StatCard(title: 'Revenue', value: '\$${report.totalRevenue.toStringAsFixed(2)}', color: AppTheme.goldColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(title: 'Bookings', value: '${report.totalBookings}', color: AppTheme.roseColor)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatCard(title: 'Customers', value: '${report.totalCustomers}', color: AppTheme.sageColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(title: 'Avg Value', value: '\$${report.avgBookingValue.toStringAsFixed(2)}', color: AppTheme.goldColor.withValues(alpha: 0.7))),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Revenue by Month', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...report.revenueByMonth.map((data) => ListTile(
                    title: Text(data.label),
                    trailing: Text('\$${data.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
              const SizedBox(height: 24),
              const Text('Bookings by Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...report.bookingsByService.map((data) => ListTile(
                    title: Text(data.label),
                    trailing: Text('${data.value} bookings', style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.liquidGlass,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
