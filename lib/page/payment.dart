import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;
  final String shippingAddress;
  final String shippingMethod;

  const PaymentPage({
    Key? key,
    required this.totalAmount,
    required this.cartItems,
    required this.shippingAddress,
    required this.shippingMethod,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = 'Bank Transfer';
  bool _isProcessing = false;
  final _supabase = Supabase.instance.client;

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // 1. Create order
      final orderResponse = await _supabase
          .from('orders')
          .insert({
            'user_id': _supabase.auth.currentUser!.id,
            'total_amount': widget.totalAmount,
            'status': 'pending',
            'shipping_address': widget.shippingAddress,
            'shipping_method': widget.shippingMethod,
          })
          .select()
          .single();

      final orderId = orderResponse['id'];

      // 2. Create order items
      for (var item in widget.cartItems) {
        await _supabase.from('order_items').insert({
          'order_id': orderId,
          'product_id': item['product_id'],
          'quantity': item['quantity'],
          'price': item['price'],
        });
      }

      // 3. Create payment record
      await _supabase.from('payments').insert({
        'order_id': orderId,
        'transaction_id': 'TRX-${DateTime.now().millisecondsSinceEpoch}',
        'payment_type': _selectedPaymentMethod,
        'amount': widget.totalAmount,
        'status': 'approved',
        'payment_date': DateTime.now().toIso8601String(),
      });

      // 4. Update order status
      await _supabase
          .from('orders')
          .update({'status': 'processing'})
          .eq('id', orderId);

      // 5. Clear cart
      final cartResponse = await _supabase
          .from('carts')
          .select('id')
          .eq('user_id', _supabase.auth.currentUser!.id)
          .single();

      await _supabase
          .from('cart_items')
          .delete()
          .eq('cart_id', cartResponse['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/history');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text('Total Amount: ${currencyFormat.format(widget.totalAmount)}'),
                      Text('Shipping Address: ${widget.shippingAddress}'),
                      Text('Shipping Method: ${widget.shippingMethod}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Bank Transfer'),
                      value: 'Bank Transfer',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('E-Wallet'),
                      value: 'E-Wallet',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Credit Card'),
                      value: 'Credit Card',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 