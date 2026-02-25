import 'package:flutter/material.dart';

/// Placeholder für Employee Dashboard Tab
class EmployeeDashboardTab extends StatelessWidget {
  final String salonId;

  const EmployeeDashboardTab({
    Key? key,
    required this.salonId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Mitarbeiter Dashboard',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Wird noch implementiert',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
