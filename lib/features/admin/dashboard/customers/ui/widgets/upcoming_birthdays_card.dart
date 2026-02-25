import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/customer_profile.dart';

class UpcomingBirthdaysCard extends StatelessWidget {
  final List<CustomerProfile> customers;
  final int weeksAhead;

  const UpcomingBirthdaysCard({
    super.key,
    required this.customers,
    this.weeksAhead = 4,
  });

  List<_BirthdayInfo> _getUpcomingBirthdays() {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: weeksAhead * 7));

    final birthdays = <_BirthdayInfo>[];

    for (final customer in customers) {
      if (customer.birthdate == null) continue;

      // Calculate this year's birthday
      final birthdayThisYear = DateTime(
        now.year,
        customer.birthdate!.month,
        customer.birthdate!.day,
      );

      // Calculate next year's birthday if needed
      final birthdayNextYear = DateTime(
        now.year + 1,
        customer.birthdate!.month,
        customer.birthdate!.day,
      );

      DateTime upcomingBirthday;
      if (birthdayThisYear.isAfter(now.subtract(const Duration(days: 1)))) {
        upcomingBirthday = birthdayThisYear;
      } else {
        upcomingBirthday = birthdayNextYear;
      }

      // Check if within range
      if (upcomingBirthday.isBefore(endDate) ||
          upcomingBirthday.isAtSameMomentAs(endDate)) {
        final daysUntil = upcomingBirthday.difference(now).inDays;
        final turningAge = upcomingBirthday.year - customer.birthdate!.year;

        birthdays.add(
          _BirthdayInfo(
            customer: customer,
            upcomingBirthday: upcomingBirthday,
            daysUntil: daysUntil,
            turningAge: turningAge,
          ),
        );
      }
    }

    // Sort by upcoming date
    birthdays.sort((a, b) => a.upcomingBirthday.compareTo(b.upcomingBirthday));

    return birthdays;
  }

  @override
  Widget build(BuildContext context) {
    final birthdays = _getUpcomingBirthdays();

    if (birthdays.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.cake, color: Colors.grey[400]),
                  const SizedBox(width: 8),
                  Text(
                    'Anstehende Geburtstage (${weeksAhead} Wochen)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Keine Geburtstage in den nächsten Wochen',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cake, color: Colors.pink),
                const SizedBox(width: 8),
                Text(
                  'Anstehende Geburtstage (${weeksAhead} Wochen)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${birthdays.length} Geburtstag${birthdays.length == 1 ? "" : "e"}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...birthdays.map((info) => _BirthdayListItem(info: info)),
          ],
        ),
      ),
    );
  }
}

class _BirthdayInfo {
  final CustomerProfile customer;
  final DateTime upcomingBirthday;
  final int daysUntil;
  final int turningAge;

  _BirthdayInfo({
    required this.customer,
    required this.upcomingBirthday,
    required this.daysUntil,
    required this.turningAge,
  });
}

class _BirthdayListItem extends StatelessWidget {
  final _BirthdayInfo info;

  const _BirthdayListItem({required this.info});

  String _getDaysUntilText() {
    if (info.daysUntil == 0) return 'Heute! 🎉';
    if (info.daysUntil == 1) return 'Morgen';
    if (info.daysUntil < 7) return 'In ${info.daysUntil} Tagen';
    final weeks = (info.daysUntil / 7).floor();
    return 'In $weeks Woche${weeks == 1 ? "" : "n"}';
  }

  Color _getUrgencyColor() {
    if (info.daysUntil == 0) return Colors.red;
    if (info.daysUntil <= 3) return Colors.orange;
    if (info.daysUntil <= 7) return Colors.amber;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: info.daysUntil == 0
            ? Colors.pink.withOpacity(0.05)
            : Colors.transparent,
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: _getUrgencyColor().withOpacity(0.2),
            child: Text(
              info.customer.firstName[0].toUpperCase() +
                  info.customer.lastName[0].toUpperCase(),
              style: TextStyle(
                color: _getUrgencyColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Customer Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.customer.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.cake, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd.MM.yyyy').format(info.upcomingBirthday),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(wird ${info.turningAge} Jahre alt)',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Days Until
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getUrgencyColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getUrgencyColor()),
            ),
            child: Text(
              _getDaysUntilText(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _getUrgencyColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
