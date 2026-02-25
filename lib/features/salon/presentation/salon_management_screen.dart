import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/app_widgets.dart';

class SalonManagementScreen extends StatefulWidget {
  const SalonManagementScreen({super.key});

  @override
  State<SalonManagementScreen> createState() => _SalonManagementScreenState();
}

class _SalonManagementScreenState extends State<SalonManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Info'),
            Tab(icon: Icon(Icons.people), text: 'Staff'),
            Tab(icon: Icon(Icons.shopping_bag), text: 'Services'),
            Tab(icon: Icon(Icons.image), text: 'Gallery'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSalonInfoTab(),
          _buildStaffTab(),
          _buildServicesTab(),
          _buildGalleryTab(),
        ],
      ),
    );
  }

  Widget _buildSalonInfoTab() {
    return ResponsiveContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Salon Information'),
                const SizedBox(height: AppSizes.md),
                _infoRow('Name', 'My Salon'),
                _infoRow('Address', '123 Main St'),
                _infoRow('Phone', '+1 (555) 123-4567'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffTab() {
    return ResponsiveContainer(
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Staff'),
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.lg),
          const AppEmptyWidget(
            message: 'No staff members',
            subMessage: 'Add your first staff member to get started',
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return ResponsiveContainer(
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Service'),
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.lg),
          const AppEmptyWidget(
            message: 'No services',
            subMessage: 'Add your first service to get started',
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryTab() {
    return ResponsiveContainer(
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.upload),
            label: const Text('Upload Photos'),
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.lg),
          const AppEmptyWidget(
            message: 'No photos',
            subMessage: 'Upload your first photo to get started',
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: ResponsiveContainer(
        child: const AppEmptyWidget(
          message: 'No gallery items',
          subMessage: 'Upload your first photo to get started',
          actionText: 'Upload Photo',
        ),
      ),
    );
  }
}

class InspirationScreen extends StatelessWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inspiration')),
      body: ResponsiveContainer(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search inspiration...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            const AppEmptyWidget(
              message: 'No inspiration items yet',
              subMessage: 'Search for styles and techniques to inspire you',
            ),
          ],
        ),
      ),
    );
  }
}

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: ResponsiveContainer(
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              onPressed: () {},
            ),
            const SizedBox(height: AppSizes.lg),
            const AppEmptyWidget(
              message: 'No inventory items',
              subMessage: 'Add your first item to track inventory',
            ),
          ],
        ),
      ),
    );
  }
}

class LoyaltyProgramScreen extends StatelessWidget {
  const LoyaltyProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loyalty Program')),
      body: ResponsiveContainer(
        child: Column(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Loyalty Settings'),
                  const SizedBox(height: AppSizes.md),
                  SwitchListTile(
                    title: const Text('Enable Loyalty Program'),
                    value: false,
                    onChanged: (value) {},
                  ),
                  SwitchListTile(
                    title: const Text('Points per Purchase'),
                    value: false,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coupons')),
      body: ResponsiveContainer(
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create Coupon'),
              onPressed: () {},
            ),
            const SizedBox(height: AppSizes.lg),
            const AppEmptyWidget(
              message: 'No coupons',
              subMessage: 'Create your first coupon to attract customers',
            ),
          ],
        ),
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Revenue'),
                  const SizedBox(height: AppSizes.md),
                  const Text(
                    '€0.00',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Appointments'),
                  const SizedBox(height: AppSizes.md),
                  const Text(
                    '0',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
