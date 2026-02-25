import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../providers/employee_provider.dart';

class AddEmployeeDialog extends ConsumerStatefulWidget {
  const AddEmployeeDialog({super.key});

  @override
  ConsumerState<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends ConsumerState<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedRole = 'stylist';
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(employeeNotifierProvider.notifier).createEmployee({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'role': _selectedRole,
        'specialties': [],
      });
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('employee.created'.tr()), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('employee.creation_failed'.tr()), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('employee.add_new'.tr()),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'employee.first_name'.tr(), border: const OutlineInputBorder()),
                validator: (value) => (value?.isEmpty ?? true) ? 'employee.first_name_required'.tr() : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'employee.last_name'.tr(), border: const OutlineInputBorder()),
                validator: (value) => (value?.isEmpty ?? true) ? 'employee.last_name_required'.tr() : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'employee.email'.tr(), border: const OutlineInputBorder()),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'employee.email_required'.tr();
                  if (!value!.contains('@')) return 'employee.invalid_email'.tr();
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'employee.phone'.tr(), border: const OutlineInputBorder()),
                validator: (value) => (value?.isEmpty ?? true) ? 'employee.phone_required'.tr() : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: InputDecoration(labelText: 'employee.role'.tr(), border: const OutlineInputBorder()),
                items: ['stylist', 'manager', 'receptionist', 'other']
                    .map((role) => DropdownMenuItem(value: role, child: Text(role.toUpperCase())))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRole = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _isLoading ? null : () => Navigator.pop(context), child: Text('common.cancel'.tr())),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('common.save'.tr()),
        ),
      ],
    );
  }
}
