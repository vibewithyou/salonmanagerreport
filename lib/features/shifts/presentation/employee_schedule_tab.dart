import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../time_tracking/application/providers/time_tracking_providers.dart';
import '../application/providers/shifts_providers.dart';
import '../domain/shift.dart';

class EmployeeScheduleTab extends ConsumerStatefulWidget {
  const EmployeeScheduleTab({super.key});

  @override
  ConsumerState<EmployeeScheduleTab> createState() => _EmployeeScheduleTabState();
}

class _EmployeeScheduleTabState extends ConsumerState<EmployeeScheduleTab> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final scope = ref.watch(activeTimeTrackingScopeProvider);
    if (scope == null) {
      return const Center(child: Text('Salon oder Benutzerkontext fehlt.'));
    }

    final query = ShiftRangeQuery(scope: scope, focusedDay: _focusedDay);
    final shiftsAsync = ref.watch(shiftsForMonthProvider(query));

    return shiftsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Fehler: $error', style: const TextStyle(color: Colors.white70))),
      data: (shifts) {
        final eventsByDay = <DateTime, List<Shift>>{};
        for (final shift in shifts) {
          final key = DateTime(shift.startAt.year, shift.startAt.month, shift.startAt.day);
          eventsByDay.putIfAbsent(key, () => []).add(shift);
        }
        final selectedKey = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
        final selected = eventsByDay[selectedKey] ?? const <Shift>[];

        return Container(
          color: Colors.black,
          child: Column(
            children: [
              TableCalendar<Shift>(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                eventLoader: (day) => eventsByDay[DateTime(day.year, day.month, day.day)] ?? const [],
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                },
              ),
              Expanded(
                child: selected.isEmpty
                    ? const Center(child: Text('Keine Schichten am gewählten Tag', style: TextStyle(color: Colors.white54)))
                    : ListView.builder(
                        itemCount: selected.length,
                        itemBuilder: (context, index) {
                          final shift = selected[index];
                          return ListTile(
                            title: Text('${DateFormat('HH:mm').format(shift.startAt.toLocal())} - ${DateFormat('HH:mm').format(shift.endAt.toLocal())}', style: const TextStyle(color: Colors.white)),
                            subtitle: Text('${shift.type}${shift.note == null ? '' : ' • ${shift.note}'}', style: const TextStyle(color: Colors.white70)),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
