import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/customer_profile.dart';

class CustomerInfoCard extends StatelessWidget {
  final CustomerProfile customer;

  const CustomerInfoCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    customer.firstName[0].toUpperCase() +
                        customer.lastName[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (customer.customerNumber != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Kundennummer: ${customer.customerNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // Contact Information
            _buildSection(
              'Kontaktdaten',
              [
                if (customer.email != null)
                  _buildInfoRow(Icons.email, 'Email', customer.email!),
                if (customer.phone != null)
                  _buildInfoRow(Icons.phone, 'Telefon', customer.phone!),
              ],
            ),

            // Personal Information
            if (customer.birthdate != null) ...[
              const SizedBox(height: 16),
              _buildSection(
                'Persönliche Daten',
                [
                  _buildInfoRow(
                    Icons.cake,
                    'Geburtsdatum',
                    DateFormat('dd.MM.yyyy').format(customer.birthdate!),
                  ),
                ],
              ),
            ],

            // Address
            if (customer.displayAddress.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSection(
                'Adresse',
                [
                  _buildInfoRow(
                      Icons.location_on, 'Anschrift', customer.displayAddress),
                ],
              ),
            ],

            // Notes
            if (customer.notes != null && customer.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSection(
                'Notizen',
                [
                  Text(
                    customer.notes!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],

            // Preferences
            if (customer.preferences != null &&
                customer.preferences!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSection(
                'Präferenzen',
                [
                  Text(
                    customer.preferences!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],

            // Allergies
            if (customer.allergies != null &&
                customer.allergies!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSection(
                'Allergien',
                [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            customer.allergies!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            // Tags
            if (customer.tags != null && customer.tags!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSection(
                'Tags',
                [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: customer.tags!
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor:
                                  Theme.of(context).primaryColor.withOpacity(0.1),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ],

            // Dates
            const SizedBox(height: 16),
            _buildSection(
              'Zeitstempel',
              [
                _buildInfoRow(
                  Icons.access_time,
                  'Erstellt',
                  DateFormat('dd.MM.yyyy HH:mm').format(customer.createdAt),
                ),
                _buildInfoRow(
                  Icons.update,
                  'Aktualisiert',
                  DateFormat('dd.MM.yyyy HH:mm').format(customer.updatedAt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
