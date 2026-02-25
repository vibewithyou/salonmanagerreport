import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// POS Terminal Screen
class POSTerminalScreen extends StatefulWidget {
  const POSTerminalScreen({super.key});

  @override
  State<POSTerminalScreen> createState() => _POSTerminalScreenState();
}

class _POSTerminalScreenState extends State<POSTerminalScreen> {
  List<CartItem> cartItems = [];
  List<POSProduct> products = [
    POSProduct(
      id: '1',
      name: 'Premium Hair Shampoo',
      price: 25.99,
      category: 'Products',
      image: 'assets/pos/shampoo.jpg',
    ),
    POSProduct(
      id: '2',
      name: 'Hair Conditioner',
      price: 22.99,
      category: 'Products',
      image: 'assets/pos/conditioner.jpg',
    ),
    POSProduct(
      id: '3',
      name: 'Styling Gel',
      price: 15.99,
      category: 'Styling',
      image: 'assets/pos/gel.jpg',
    ),
    POSProduct(
      id: '4',
      name: 'Hair Mask',
      price: 32.99,
      category: 'Treatments',
      image: 'assets/pos/mask.jpg',
    ),
    POSProduct(
      id: '5',
      name: 'Blow Dry Spray',
      price: 18.99,
      category: 'Styling',
      image: 'assets/pos/spray.jpg',
    ),
    POSProduct(
      id: '6',
      name: 'Color Treatment',
      price: 45.99,
      category: 'Treatments',
      image: 'assets/pos/color.jpg',
    ),
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _paymentMethod = 'card';

  List<POSProduct> get filteredProducts {
    return products.where((product) {
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get tax {
    return subtotal * 0.1; // 10% tax
  }

  double get total {
    return subtotal + tax;
  }

  void _addToCart(POSProduct product) {
    setState(() {
      final existingItem =
          cartItems.firstWhere((item) => item.product.id == product.id,
              orElse: () => CartItem(product: product, quantity: 0));

      if (existingItem.quantity > 0) {
        existingItem.quantity++;
      } else {
        cartItems.add(CartItem(product: product, quantity: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1200;

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: Text('pos_terminal'.tr()),
        ),
        body: Column(
          children: [
            Expanded(child: _buildProductGrid()),
            Expanded(child: _buildCart()),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildProductArea(),
          ),
          Expanded(
            flex: 1,
            child: _buildCartArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductArea() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Category Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Products'),
                _buildCategoryChip('Styling'),
                _buildCategoryChip('Treatments'),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.lg),

        // Product Grid
        Expanded(child: _buildProductGrid()),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        margin: EdgeInsets.only(right: AppSpacing.md),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.gray200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.gray900,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return _ProductTile(
          product: filteredProducts[index],
          onTap: () => _addToCart(filteredProducts[index]),
        );
      },
    );
  }

  Widget _buildCartArea() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.gray900 : AppColors.gray50,
      child: Column(
        children: [
          // Cart Header
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.gray200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'cart'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${cartItems.length} items',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Cart Items
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 48, color: AppColors.gray400),
                        SizedBox(height: AppSpacing.md),
                        Text('cart_empty'.tr()),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return _CartItemTile(
                        item: cartItems[index],
                        onQuantityChanged: (quantity) {
                          setState(() {
                            if (quantity <= 0) {
                              cartItems.removeAt(index);
                            } else {
                              cartItems[index].quantity = quantity;
                            }
                          });
                        },
                      );
                    },
                  ),
          ),

          // Summary
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.gray200),
              ),
            ),
            child: Column(
              children: [
                _SummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                SizedBox(height: AppSpacing.sm),
                _SummaryRow('Tax (10%)', '\$${tax.toStringAsFixed(2)}',
                    color: AppColors.warning),
                SizedBox(height: AppSpacing.md),
                Container(
                  height: 1,
                  color: AppColors.gray200,
                ),
                SizedBox(height: AppSpacing.md),
                _SummaryRow('Total', '\$${total.toStringAsFixed(2)}',
                    fontSize: 18, fontWeight: FontWeight.bold,
                    color: AppColors.primary),
                SizedBox(height: AppSpacing.lg),

                // Payment Method
                Text('payment_method'.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                SizedBox(height: AppSpacing.md),
                _buildPaymentMethodSelector(),
                SizedBox(height: AppSpacing.lg),

                // Checkout Button
                GestureDetector(
                  onTap: () => _showCheckoutDialog(context),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'checkout'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                // Clear Cart Button
                SizedBox(height: AppSpacing.md),
                GestureDetector(
                  onTap: () => setState(() => cartItems.clear()),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.error),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'clear_cart'.tr(),
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCart() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('cart'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          SizedBox(height: AppSpacing.lg),
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Text('cart_empty'.tr()),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return _CartItemTile(
                        item: cartItems[index],
                        onQuantityChanged: (quantity) {
                          setState(() {
                            if (quantity <= 0) {
                              cartItems.removeAt(index);
                            } else {
                              cartItems[index].quantity = quantity;
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
          SizedBox(height: AppSpacing.lg),
          Column(
            children: [
              _SummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
              _SummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
              SizedBox(height: AppSpacing.md),
              _SummaryRow('Total', '\$${total.toStringAsFixed(2)}',
                  fontSize: 18, fontWeight: FontWeight.bold),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          GestureDetector(
            onTap: () => _showCheckoutDialog(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'checkout'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildPaymentOption('card', 'Card', Icons.credit_card),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildPaymentOption('cash', 'Cash', Icons.money),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
    final isSelected = _paymentMethod == value;

    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.gray200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.gray600,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.gray600,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _SummaryRow(String label, String value,
      {double fontSize = 14,
      FontWeight fontWeight = FontWeight.normal,
      Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('checkout_confirmation'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Items: ${cartItems.length}'),
            Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
            Text('Tax: \$${tax.toStringAsFixed(2)}'),
            SizedBox(height: AppSpacing.md),
            Text('Total: \$${total.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completeTransaction();
            },
            child: Text('confirm_payment'.tr()),
          ),
        ],
      ),
    );
  }

  void _completeTransaction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'transaction_completed'.tr() + ' - \$${total.toStringAsFixed(2)}'),
      ),
    );
    setState(() => cartItems.clear());
  }
}

/// Product Tile
class _ProductTile extends StatefulWidget {
  final POSProduct product;
  final VoidCallback onTap;

  const _ProductTile({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<_ProductTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? AppColors.primary : AppColors.gray200,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: AppColors.gray200,
                  child: Image.asset(
                    widget.product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Center(
                          child: Icon(Icons.image, size: 48),
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cart Item Tile
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;

  const _CartItemTile({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => onQuantityChanged(item.quantity - 1),
                child: Icon(Icons.remove_circle_outline, size: 20),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                item.quantity.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: () => onQuantityChanged(item.quantity + 1),
                child: Icon(Icons.add_circle_outline, size: 20),
              ),
            ],
          ),
          SizedBox(width: AppSpacing.md),
          Text(
            '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
        ],
      ),
    );
  }
}

/// POS Product Model
class POSProduct {
  final String id;
  final String name;
  final double price;
  final String category;
  final String image;

  POSProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });
}

/// Cart Item Model
class CartItem {
  final POSProduct product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get price => product.price;
}
