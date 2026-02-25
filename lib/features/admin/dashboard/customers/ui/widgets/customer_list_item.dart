import 'package:flutter/material.dart';
import '../../data/models/customer_profile.dart';

class CustomerListItem extends StatelessWidget {
  final CustomerProfile customer;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CustomerListItem({
    super.key,
    required this.customer,
    required this.onTap,
    required this.onDelete,
  });

  bool _isBirthdayToday() {
    if (customer.birthdate == null) return false;
    final now = DateTime.now();
    final birthdate = customer.birthdate!;
    return birthdate.day == now.day && birthdate.month == now.month;
  }

  bool _isBirthdayThisMonth() {
    if (customer.birthdate == null) return false;
    final now = DateTime.now();
    final birthdate = customer.birthdate!;
    return birthdate.month == now.month && 
           !(birthdate.day == now.day); // Not today
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBirthdayToday = _isBirthdayToday();
    final isBirthdayThisMonth = _isBirthdayThisMonth();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isBirthdayToday ? 3 : 1,
      color: isBirthdayToday 
          ? Colors.pink.shade50 
          : (isBirthdayThisMonth ? Colors.amber.shade50 : null),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isBirthdayToday
              ? Colors.pink.shade100
              : theme.primaryColor.withOpacity(0.1),
          child: Text(
            customer.firstName[0].toUpperCase() +
                customer.lastName[0].toUpperCase(),
            style: TextStyle(
              color: isBirthdayToday ? Colors.pink : theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                customer.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isBirthdayToday) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cake, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Heute Geburtstag!',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (isBirthdayThisMonth) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cake_outlined, size: 14, color: Colors.black87),
                    SizedBox(width: 4),
                    Text(
                      'Geburtstag',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (customer.email != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.email, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      customer.email!,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (customer.phone != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.phone, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    customer.phone!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
            if (customer.displayAddress.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      customer.displayAddress,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (customer.customerNumber != null) ...[
              const SizedBox(height: 4),
              Text(
                'Nr: ${customer.customerNumber}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Löschen', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
