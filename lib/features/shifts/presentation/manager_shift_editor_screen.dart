import 'package:flutter/material.dart';

class ManagerShiftEditorScreen extends StatefulWidget {
  const ManagerShiftEditorScreen({Key? key}) : super(key: key);

  @override
  State<ManagerShiftEditorScreen> createState() => _ManagerShiftEditorScreenState();
}

class _ManagerShiftEditorScreenState extends State<ManagerShiftEditorScreen> {
  // TODO: Integrate with provider/repository
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dienstplan Editor')),
      body: Column(
        children: [
          // Monatskalender (Placeholder)
          Container(
            height: 300,
            color: Colors.grey[200],
            child: const Center(child: Text('Monatskalender')),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Schicht hinzufügen'),
            onPressed: () => _openShiftModal(),
          ),
          // TODO: List of shifts for selected month
        ],
      ),
    );
  }

  void _openShiftModal({Map<String, dynamic>? shift}) {
    showDialog(
      context: context,
      builder: (context) => ShiftModal(
        shift: shift,
        onSave: (data) {
          // TODO: upsertShift
        },
        onDelete: shift != null
            ? () {
                // TODO: deleteShift
              }
            : null,
      ),
    );
  }
}

class ShiftModal extends StatefulWidget {
  final Map<String, dynamic>? shift;
  final void Function(Map<String, dynamic>) onSave;
  final VoidCallback? onDelete;

  const ShiftModal({Key? key, this.shift, required this.onSave, this.onDelete}) : super(key: key);

  @override
  State<ShiftModal> createState() => _ShiftModalState();
}

class _ShiftModalState extends State<ShiftModal> {
  final _formKey = GlobalKey<FormState>();
  String? _staffId;
  DateTime? _startAt;
  DateTime? _endAt;
  String _type = 'work';
  String? _note;

  @override
  void initState() {
    super.initState();
    final shift = widget.shift;
    if (shift != null) {
      _staffId = shift['staff_id']?.toString();
      _startAt = shift['start_at'] as DateTime?;
      _endAt = shift['end_at'] as DateTime?;
      _type = shift['type'] ?? 'work';
      _note = shift['note'];
    }
  }

  String? _validationError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.shift == null ? 'Schicht hinzufügen' : 'Schicht bearbeiten'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_validationError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(_validationError!, style: const TextStyle(color: Colors.red)),
                ),
              // Staff Dropdown (Placeholder)
              DropdownButtonFormField<String>(
                value: _staffId,
                items: [
                  DropdownMenuItem(value: '1', child: Text('Mitarbeiter 1')),
                  DropdownMenuItem(value: '2', child: Text('Mitarbeiter 2')),
                ],
                onChanged: (v) => setState(() => _staffId = v),
                decoration: const InputDecoration(labelText: 'Mitarbeiter'),
                validator: (v) => v == null ? 'Bitte wählen' : null,
              ),
              // Start DateTime
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Startzeit'),
                controller: TextEditingController(text: _startAt?.toString() ?? ''),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startAt ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _startAt = picked);
                  }
                },
                validator: (v) => _startAt == null ? 'Bitte wählen' : null,
              ),
              // End DateTime
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Endzeit'),
                controller: TextEditingController(text: _endAt?.toString() ?? ''),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endAt ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _endAt = picked);
                  }
                },
                validator: (v) => _endAt == null ? 'Bitte wählen' : null,
              ),
              // Type Dropdown
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'work', child: Text('Arbeit')),
                  DropdownMenuItem(value: 'training', child: Text('Training')),
                  DropdownMenuItem(value: 'break', child: Text('Pause')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'work'),
                decoration: const InputDecoration(labelText: 'Typ'),
              ),
              // Note
              TextFormField(
                initialValue: _note,
                decoration: const InputDecoration(labelText: 'Notiz'),
                onChanged: (v) => _note = v,
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: widget.onDelete,
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() => _validationError = null);
            if (_formKey.currentState?.validate() ?? false) {
              // Validierung: end_at > start_at
              if (_startAt != null && _endAt != null && !_endAt!.isAfter(_startAt!)) {
                setState(() => _validationError = 'Endzeit muss nach Startzeit liegen');
                return;
              }
              // TODO: Überlappungsprüfung mit bestehenden Schichten (_staffId, _startAt, _endAt)
              // Hinweis: Hier müsste asynchron geprüft werden, z.B. per Provider oder Repository
              // setState(() => _validationError = 'Überlappung mit anderer Schicht');
              // return;
              widget.onSave({
                'staff_id': _staffId,
                'start_at': _startAt,
                'end_at': _endAt,
                'type': _type,
                'note': _note,
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
