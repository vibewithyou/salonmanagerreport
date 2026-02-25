import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

/// PHASE 7: CUSTOMER MANAGEMENT (CRM & LOYALTY)
/// 
/// Features:
/// - Erweiterte Kundenprofile mit Avatar & Tags
/// - Loyalty-System mit Treuepunkten & Tiers (Bronze, Silber, Gold, Platin)
/// - Visit Tracking & Service-Präferenzen
/// - Automatische Segmentierung (Neukunden, Stammkunden, VIPs, Inactive)
/// - CRM-Dashboard mit Stats & Analytics
/// - Marketing-Integration (E-Mail, SMS, Push)

class CRMDashboardScreen extends ConsumerStatefulWidget {
  const CRMDashboardScreen({super.key});

  @override
  ConsumerState<CRMDashboardScreen> createState() => _CRMDashboardScreenState();
}

class _CRMDashboardScreenState extends ConsumerState<CRMDashboardScreen> {
  String _selectedSegment = 'Alle';
  String _searchQuery = '';
  String _sortBy = 'Letzter Besuch';

  List<Map<String, dynamic>> get _filteredCustomers {
    var filtered = _mockCustomers.where((customer) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final name = '${customer['firstName']} ${customer['lastName']}'.toLowerCase();
        final email = (customer['email'] as String).toLowerCase();
        if (!name.contains(query) && !email.contains(query)) {
          return false;
        }
      }

      // Segment filter
      if (_selectedSegment != 'Alle') {
        if (_selectedSegment == 'Neukunden' && customer['segment'] != 'new') return false;
        if (_selectedSegment == 'Stammkunden' && customer['segment'] != 'regular') return false;
        if (_selectedSegment == 'VIP' && customer['segment'] != 'vip') return false;
        if (_selectedSegment == 'Inaktiv' && customer['segment'] != 'inactive') return false;
      }

      return true;
    }).toList();

    // Sort
    filtered.sort((a, b) {
      if (_sortBy == 'Letzter Besuch') {
        return (b['lastVisit'] as DateTime).compareTo(a['lastVisit'] as DateTime);
      } else if (_sortBy == 'Umsatz') {
        return (b['totalSpent'] as num).compareTo(a['totalSpent'] as num);
      } else if (_sortBy == 'Name') {
        return (a['firstName'] as String).compareTo(b['firstName'] as String);
      }
      return 0;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gold, Colors.amber.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'CRM & Kundenverwaltung',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kundendaten exportiert'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(LucideIcons.download, color: Colors.white),
          ),
          IconButton(
            onPressed: _showMarketingOptions,
            icon: const Icon(LucideIcons.mail, color: AppColors.gold),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // KPI Cards
                Row(
                  children: [
                    Expanded(child: _buildKPICard('Gesamt', '${_mockCustomers.length}', LucideIcons.users, Colors.blue)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildKPICard('⌀ Wert', '€${_calculateAverageValue().toStringAsFixed(0)}', LucideIcons.euro, Colors.green)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildKPICard('Retention', '${_calculateRetention()}%', LucideIcons.trendingUp, Colors.orange)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildKPICard('Churn', '${_calculateChurn()}%', LucideIcons.trendingDown, Colors.red)),
                  ],
                ),

                const SizedBox(height: 16),

                // Segment Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSegmentChip('Alle', _mockCustomers.length),
                      _buildSegmentChip('Neukunden', _countSegment('new')),
                      _buildSegmentChip('Stammkunden', _countSegment('regular')),
                      _buildSegmentChip('VIP', _countSegment('vip')),
                      _buildSegmentChip('Inaktiv', _countSegment('inactive')),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search & Sort Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Suche nach Name oder E-Mail...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(LucideIcons.search, color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                PopupMenuButton<String>(
                  onSelected: (value) => setState(() => _sortBy = value),
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.arrowUpDown, color: Colors.black),
                  ),
                  color: Colors.grey[900],
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Letzter Besuch',
                      child: Text('Letzter Besuch', style: TextStyle(color: Colors.white)),
                    ),
                    const PopupMenuItem(
                      value: 'Umsatz',
                      child: Text('Umsatz', style: TextStyle(color: Colors.white)),
                    ),
                    const PopupMenuItem(
                      value: 'Name',
                      child: Text('Name', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Customer List
          Expanded(
            child: _filteredCustomers.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.userX, size: 64, color: Colors.white24),
                        SizedBox(height: 16),
                        Text(
                          'Keine Kunden gefunden',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
                      return _buildCustomerCard(customer);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Neuer Kunde hinzufügen'),
              backgroundColor: Colors.green,
            ),
          );
        },
        backgroundColor: AppColors.gold,
        icon: const Icon(LucideIcons.userPlus, color: Colors.black),
        label: const Text(
          'Neu',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildKPICard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentChip(String label, int count) {
    final isSelected = _selectedSegment == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedSegment = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold : Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.gold : Colors.white24,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: customer['segment'] == 'vip' ? AppColors.gold : Colors.white24,
          width: customer['segment'] == 'vip' ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showCustomerDetails(customer),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getSegmentColor(customer['segment']).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getSegmentColor(customer['segment']),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${customer['firstName'][0]}${customer['lastName'][0]}',
                        style: TextStyle(
                          color: _getSegmentColor(customer['segment']),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${customer['firstName']} ${customer['lastName']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildSegmentBadge(customer['segment']),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer['email'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildLoyaltyTier(customer['loyaltyTier'], customer['loyaltyPoints']),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(color: Colors.white12, height: 24),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(
                    '${customer['visitCount']}',
                    'Besuche',
                    LucideIcons.calendar,
                  ),
                  _buildStatColumn(
                    '€${customer['totalSpent'].toStringAsFixed(0)}',
                    'Umsatz',
                    LucideIcons.euro,
                  ),
                  _buildStatColumn(
                    _formatDate(customer['lastVisit']),
                    'Letzter Besuch',
                    LucideIcons.clock,
                  ),
                ],
              ),

              if (customer['tags'].isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (customer['tags'] as List<String>)
                      .map((tag) => _buildTag(tag))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentBadge(String segment) {
    final color = _getSegmentColor(segment);
    final label = _getSegmentLabel(segment);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoyaltyTier(String tier, int points) {
    final tierData = _getTierData(tier);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: tierData['colors'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            tierData['icon'] as IconData,
            size: 14,
            color: Colors.black,
          ),
          const SizedBox(width: 6),
          Text(
            '$tier • $points Punkte',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.gold),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 10,
        ),
      ),
    );
  }

  void _showCustomerDetails(Map<String, dynamic> customer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: AppColors.gold, width: 2)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: _getSegmentColor(customer['segment']).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getSegmentColor(customer['segment']),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${customer['firstName'][0]}${customer['lastName'][0]}',
                        style: TextStyle(
                          color: _getSegmentColor(customer['segment']),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${customer['firstName']} ${customer['lastName']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildSegmentBadge(customer['segment']),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, color: Colors.white54),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white12),

            // Content with Tabs
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: AppColors.gold,
                      unselectedLabelColor: Colors.white54,
                      indicatorColor: AppColors.gold,
                      tabs: const [
                        Tab(text: 'Übersicht'),
                        Tab(text: 'Historie'),
                        Tab(text: 'Loyalty'),
                        Tab(text: 'Notizen'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildOverviewTab(customer),
                          _buildHistoryTab(customer),
                          _buildLoyaltyTab(customer),
                          _buildNotesTab(customer),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> customer) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Info
          const Text(
            'Kontaktdaten',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoCard([
            _buildInfoRow(LucideIcons.mail, customer['email']),
            _buildInfoRow(LucideIcons.phone, customer['phone']),
            _buildInfoRow(LucideIcons.cake, _formatDate(customer['birthday'])),
          ]),

          const SizedBox(height: 16),

          // Stats
          const Text(
            'Statistiken',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '${customer['visitCount']}',
                  'Gesamte Besuche',
                  LucideIcons.calendar,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '€${customer['totalSpent'].toStringAsFixed(0)}',
                  'Gesamtumsatz',
                  LucideIcons.euro,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '€${customer['averageSpend'].toStringAsFixed(0)}',
                  '⌀ pro Besuch',
                  LucideIcons.trendingUp,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  _formatDate(customer['lastVisit']),
                  'Letzter Besuch',
                  LucideIcons.clock,
                  Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Preferences
          const Text(
            'Präferenzen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoCard([
            _buildInfoRow(LucideIcons.scissors, customer['favoriteService']),
            _buildInfoRow(LucideIcons.user, customer['favoriteStylist']),
          ]),

          const SizedBox(height: 16),

          // Tags
          const Text(
            'Tags',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (customer['tags'] as List<String>)
                .map((tag) => _buildEditableTag(tag))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(Map<String, dynamic> customer) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: customer['visitHistory'].length,
      itemBuilder: (context, index) {
        final visit = customer['visitHistory'][index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(visit['date']),
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '€${visit['amount'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                visit['service'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'mit ${visit['stylist']}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoyaltyTab(Map<String, dynamic> customer) {
    final tierData = _getTierData(customer['loyaltyTier']);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Current Tier
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: tierData['colors'] as List<Color>,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  tierData['icon'] as IconData,
                  size: 48,
                  color: Colors.black,
                ),
                const SizedBox(height: 12),
                Text(
                  customer['loyaltyTier'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${customer['loyaltyPoints']} Punkte',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tier Benefits
          const Text(
            'Ihre Vorteile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...( tierData['benefits'] as List<String>).map((benefit) => 
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(LucideIcons.checkCircle, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      benefit,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Progress to Next Tier
          const Text(
            'Fortschritt zum nächsten Level',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${customer['loyaltyPoints']} / ${tierData['nextTierPoints']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Nächstes Level: ${tierData['nextTier']}',
                      style: const TextStyle(color: AppColors.gold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: customer['loyaltyPoints'] / (tierData['nextTierPoints'] as int),
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(Map<String, dynamic> customer) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            maxLines: 10,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Notizen zu diesem Kunden hinzufügen...',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notiz gespeichert'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(LucideIcons.save),
              label: const Text('Notiz speichern'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (customer['notes'] != null && customer['notes'].isNotEmpty)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  customer['notes'],
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(LucideIcons.x, size: 14, color: Colors.white54),
        ],
      ),
    );
  }

  void _showMarketingOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: AppColors.gold, width: 2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Marketing-Aktionen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildMarketingOption(
              LucideIcons.mail,
              'E-Mail Kampagne',
              'Sende Newsletter an Kunden',
            ),
            _buildMarketingOption(
              LucideIcons.messageSquare,
              'SMS Erinnerungen',
              'Versende Termin-Erinnerungen',
            ),
            _buildMarketingOption(
              LucideIcons.bell,
              'Push Benachrichtigungen',
              'Benachrichtige Stammkunden',
            ),
            _buildMarketingOption(
              LucideIcons.cake,
              'Geburtstags-Grüße',
              'Automatische Birthday-Nachrichten',
            ),
            _buildMarketingOption(
              LucideIcons.users,
              'Re-Engagement',
              'Inactive Kunden reaktivieren',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketingOption(IconData icon, String title, String description) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title gestartet'),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.gold),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  Color _getSegmentColor(String segment) {
    switch (segment) {
      case 'vip':
        return AppColors.gold;
      case 'regular':
        return Colors.green;
      case 'new':
        return Colors.blue;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getSegmentLabel(String segment) {
    switch (segment) {
      case 'vip':
        return 'VIP';
      case 'regular':
        return 'Stammkunde';
      case 'new':
        return 'Neukunde';
      case 'inactive':
        return 'Inaktiv';
      default:
        return segment;
    }
  }

  Map<String, dynamic> _getTierData(String tier) {
    switch (tier) {
      case 'Platin':
        return {
          'colors': [Colors.grey.shade300, Colors.white],
          'icon': LucideIcons.crown,
          'benefits': [
            '20% Rabatt auf alle Leistungen',
            'Kostenlose Premium-Behandlung pro Monat',
            'Bevorzugte Terminvergabe',
            'Exklusive Event-Einladungen',
          ],
          'nextTier': 'Maximum',
          'nextTierPoints': 10000,
        };
      case 'Gold':
        return {
          'colors': [AppColors.gold, Colors.amber],
          'icon': LucideIcons.award,
          'benefits': [
            '15% Rabatt auf alle Leistungen',
            'Kostenlose Behandlung alle 2 Monate',
            'Priority Booking',
          ],
          'nextTier': 'Platin',
          'nextTierPoints': 2000,
        };
      case 'Silber':
        return {
          'colors': [Colors.grey.shade400, Colors.grey.shade300],
          'icon': LucideIcons.medal,
          'benefits': [
            '10% Rabatt auf alle Leistungen',
            'Geburtstags-Geschenk',
          ],
          'nextTier': 'Gold',
          'nextTierPoints': 1000,
        };
      case 'Bronze':
      default:
        return {
          'colors': [Colors.brown.shade400, Colors.brown.shade300],
          'icon': LucideIcons.star,
          'benefits': [
            '5% Rabatt auf alle Leistungen',
            'Treuepunkte sammeln',
          ],
          'nextTier': 'Silber',
          'nextTierPoints': 500,
        };
    }
  }

  int _countSegment(String segment) {
    return _mockCustomers.where((c) => c['segment'] == segment).length;
  }

  double _calculateAverageValue() {
    if (_mockCustomers.isEmpty) return 0;
    final total = _mockCustomers.fold<double>(0, (sum, c) => sum + (c['totalSpent'] as num).toDouble());
    return total / _mockCustomers.length;
  }

  int _calculateRetention() {
    final active = _mockCustomers.where((c) => c['segment'] != 'inactive').length;
    return ((active / _mockCustomers.length) * 100).round();
  }

  int _calculateChurn() {
    final inactive = _countSegment('inactive');
    return ((inactive / _mockCustomers.length) * 100).round();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Heute';
    if (difference == 1) return 'Gestern';
    if (difference < 7) return 'Vor $difference Tagen';
    if (difference < 30) return 'Vor ${(difference / 7).round()} Wochen';
    
    return DateFormat('dd.MM.yyyy').format(date);
  }
}

// ============================================================================
// MOCK DATA
// ============================================================================

final _mockCustomers = [
  {
    'id': '1',
    'firstName': 'Anna',
    'lastName': 'Müller',
    'email': 'anna.mueller@example.com',
    'phone': '+49 171 1234567',
    'birthday': DateTime(1990, 5, 15),
    'segment': 'vip',
    'visitCount': 24,
    'totalSpent': 2450.0,
    'averageSpend': 102.08,
    'lastVisit': DateTime.now().subtract(const Duration(days: 5)),
    'loyaltyTier': 'Platin',
    'loyaltyPoints': 2450,
    'favoriteService': 'Balayage',
    'favoriteStylist': 'Sophie Klein',
    'tags': ['VIP', 'Stammkunde', 'Empfehlung'],
    'visitHistory': [
      {'date': DateTime.now().subtract(const Duration(days: 5)), 'service': 'Balayage', 'stylist': 'Sophie Klein', 'amount': 120.0},
      {'date': DateTime.now().subtract(const Duration(days: 35)), 'service': 'Schnitt', 'stylist': 'Sophie Klein', 'amount': 45.0},
      {'date': DateTime.now().subtract(const Duration(days: 65)), 'service': 'Färben', 'stylist': 'Anna Müller', 'amount': 80.0},
    ],
    'notes': 'Bevorzugt Termine am Samstag. Allergisch gegen Ammoniak.',
  },
  {
    'id': '2',
    'firstName': 'Max',
    'lastName': 'Schmidt',
    'email': 'max.schmidt@example.com',
    'phone': '+49 172 2345678',
    'birthday': DateTime(1985, 8, 22),
    'segment': 'regular',
    'visitCount': 12,
    'totalSpent': 540.0,
    'averageSpend': 45.0,
    'lastVisit': DateTime.now().subtract(const Duration(days: 15)),
    'loyaltyTier': 'Gold',
    'loyaltyPoints': 540,
    'favoriteService': 'Herrenschnitt',
    'favoriteStylist': 'Lisa Wagner',
    'tags': ['Stammkunde'],
     'visitHistory': [
      {'date': DateTime.now().subtract(const Duration(days: 15)), 'service': 'Herrenschnitt', 'stylist': 'Lisa Wagner', 'amount': 35.0},
      {'date': DateTime.now().subtract(const Duration(days: 45)), 'service': 'Herrenschnitt', 'stylist': 'Lisa Wagner', 'amount': 35.0},
    ],
    'notes': '',
  },
  {
    'id': '3',
    'firstName': 'Sarah',
    'lastName': 'Wagner',
    'email': 'sarah.wagner@example.com',
    'phone': '+49 173 3456789',
    'birthday': DateTime(1995, 3, 10),
    'segment': 'new',
    'visitCount': 2,
    'totalSpent': 150.0,
    'averageSpend': 75.0,
    'lastVisit': DateTime.now().subtract(const Duration(days: 8)),
    'loyaltyTier': 'Bronze',
    'loyaltyPoints': 150,
    'favoriteService': 'Schnitt & Föhnen',
    'favoriteStylist': 'Anna Müller',
    'tags': ['Neukunde', 'Instagram'],
    'visitHistory': [
      {'date': DateTime.now().subtract(const Duration(days: 8)), 'service': 'Schnitt & Föhnen', 'stylist': 'Anna Müller', 'amount': 75.0},
      {'date': DateTime.now().subtract(const Duration(days: 38)), 'service': 'Beratung', 'stylist': 'Anna Müller', 'amount': 0.0},
    ],
    'notes': 'Kam über Instagram-Werbung.',
  },
  {
    'id': '4',
    'firstName': 'Thomas',
    'lastName': 'Becker',
    'email': 'thomas.becker@example.com',
    'phone': '+49 174 4567890',
    'birthday': DateTime(1978, 11, 5),
    'segment': 'inactive',
    'visitCount': 8,
    'totalSpent': 320.0,
    'averageSpend': 40.0,
    'lastVisit': DateTime.now().subtract(const Duration(days: 245)),
    'loyaltyTier': 'Silber',
    'loyaltyPoints': 320,
    'favoriteService': 'Herrenschnitt',
    'favoriteStylist': 'Lisa Wagner',
    'tags': ['Inaktiv', 'Re-Engagement'],
    'visitHistory': [
      {'date': DateTime.now().subtract(const Duration(days: 245)), 'service': 'Herrenschnitt', 'stylist': 'Lisa Wagner', 'amount': 40.0},
    ],
    'notes': 'Lange nicht mehr da gewesen. Re-Engagement-Kampagne starten.',
  },
  {
    'id': '5',
    'firstName': 'Julia',
    'lastName': 'Fischer',
    'email': 'julia.fischer@example.com',
    'phone': '+49 175 5678901',
    'birthday': DateTime(1992, 7, 18),
    'segment': 'vip',
    'visitCount': 18,
    'totalSpent': 1890.0,
    'averageSpend': 105.0,
    'lastVisit': DateTime.now().subtract(const Duration(days: 12)),
    'loyaltyTier': 'Gold',
    'loyaltyPoints': 1890,
    'favoriteService': 'Strähnchen',
    'favoriteStylist': 'Sophie Klein',
    'tags': ['VIP', 'Stammkunde', 'Geburtstag'],
    'visitHistory': [
      {'date': DateTime.now().subtract(const Duration(days: 12)), 'service': 'Strähnchen', 'stylist': 'Sophie Klein', 'amount': 95.0},
      {'date': DateTime.now().subtract(const Duration(days: 42)), 'service': 'Schnitt', 'stylist': 'Sophie Klein', 'amount': 50.0},
    ],
    'notes': 'Geburtstag nächsten Monat - Gutschein vorbereiten.',
  },
  {
    'id': '6',
    'firstName': 'Michael',
    'lastName': 'Weber',
    'email': 'michael.weber@example.com',
    'phone': '+49 176 6789012',
    'birthday': DateTime(1988, 2, 28),
    'segment': 'regular',
    'visitCount': 15,
    'totalSpent': 675.0,
    'averageSpend': 45.0,
    'lastVisit': DateTime.now().subtract(const Duration(days: 20)),
    'loyaltyTier': 'Silber',
    'loyaltyPoints': 675,
    'favoriteService': 'Bart-Styling',
    'favoriteStylist': 'Lisa Wagner',
    'tags': ['Stammkunde', 'Bart'],
    'visitHistory': [
      {'date': DateTime.now().subtract(const Duration(days: 20)), 'service': 'Herrenschnitt + Bart', 'stylist': 'Lisa Wagner', 'amount': 50.0},
    ],
    'notes': '',
  },
];
