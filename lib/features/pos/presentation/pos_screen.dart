

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/pos_repository.dart';
import '../../../services/supabase_service.dart';


class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  final List<CartItem> cart = [];
  double subtotal = 0;
  double tax = 0;
  double total = 0;
  static const double taxRate = 0.19;
  bool isSaving = false;

  void addService() async {
    final service = await showDialog<CartItem>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Add Service'),
        children: [
          SimpleDialogOption(
            child: const Text('Haircut (30€)'),
            onPressed: () => Navigator.pop(context, CartItem('service', 'Haircut', 1, 30.0)),
          ),
          SimpleDialogOption(
            child: const Text('Coloring (50€)'),
            onPressed: () => Navigator.pop(context, CartItem('service', 'Coloring', 1, 50.0)),
          ),
        ],
      ),
    );
    if (service != null) {
      setState(() {
        cart.add(service);
        recalcTotals();
      });
    }
  }

  void recalcTotals() {
    subtotal = cart.fold(0, (sum, item) => sum + item.price * item.qty);
    tax = subtotal * taxRate;
    total = subtotal + tax;
  }

  Future<void> checkout() async {
    final method = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => PaymentMethodSheet(),
    );
    if (method != null) {
      setState(() => isSaving = true);
      try {
        final supabase = ref.read(supabaseServiceProvider);
        final repo = PosRepository(supabase.client);
        // TODO: Replace with real salonId and customerId
        final invoiceId = await repo.createInvoice(
          salonId: 1,
          customerId: null,
          subtotal: subtotal,
          tax: tax,
          total: total,
          status: 'paid',
          items: cart.map((item) => {
            'type': item.type,
            'ref_id': 0,
            'qty': item.qty,
            'price': item.price,
            'tax_rate': (taxRate * 100),
          }).toList(),
          paymentAmount: total,
          paymentMethod: method,
        );
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Rechnung erzeugt'),
            content: Text('Rechnung #$invoiceId\nZahlung: $method\nBetrag: €${total.toStringAsFixed(2)}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        setState(() {
          cart.clear();
          recalcTotals();
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Fehler'),
            content: Text('Rechnung konnte nicht gespeichert werden. $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, i) {
                final item = cart[i];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.type),
                  trailing: Text('€${(item.price * item.qty).toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Subtotal: €${subtotal.toStringAsFixed(2)}'),
                Text('Tax (19%): €${tax.toStringAsFixed(2)}'),
                Text('Total: €${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSaving ? null : addService,
                        child: const Text('Add Service'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: cart.isEmpty || isSaving ? null : checkout,
                        child: isSaving ? const CircularProgressIndicator() : const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String type; // service|product
  final String name;
  final int qty;
  final double price;
  CartItem(this.type, this.name, this.qty, this.price);
}

class PaymentMethodSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Bar'),
            onTap: () => Navigator.pop(context, 'cash'),
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('EC-Karte'),
            onTap: () => Navigator.pop(context, 'card'),
          ),
        ],
      ),
    );
  }
}
