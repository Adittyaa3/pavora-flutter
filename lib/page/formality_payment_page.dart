import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectuasv2/order/chekout.dart'; // Untuk mengakses PaymentConfirmationWidget
import 'package:intl/intl.dart'; // Untuk format mata uang

class FormalityPaymentPage extends StatefulWidget {
  final int orderId;
  final double totalAmount;

  const FormalityPaymentPage({
    Key? key,
    required this.orderId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _FormalityPaymentPageState createState() => _FormalityPaymentPageState();
}

class _FormalityPaymentPageState extends State<FormalityPaymentPage> {
  bool _isProcessingPayment = false;
  final String _paymentMethodName =
      "Transfer Bank "; // Nama metode pembayaran formalitas
  final NumberFormat _currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  Future<void> _processFormalityPayment() async {
    if (!mounted) return;
    setState(() {
      _isProcessingPayment = true;
    });

    final supabase = Supabase.instance.client;

    try {
      // 1. Catat pembayaran di tabel 'payments'
      // Status langsung 'approved' untuk memicu trigger stok
      await supabase.from('payments').insert({
        'order_id': widget.orderId,
        'amount': widget.totalAmount,
        'status': 'approved', // Ini akan memicu trigger update stok
        'payment_type': _paymentMethodName,
        'transaction_id':
            'FORMALITAS-${DateTime.now().millisecondsSinceEpoch}', // ID transaksi placeholder
        'payment_url': null, // Tidak ada URL untuk pembayaran formalitas
        'payment_date': DateTime.now().toIso8601String(),
      });

      // 2. Tampilkan dialog konfirmasi pembayaran
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible:
              false, // Pengguna harus menekan tombol untuk menutup
          builder: (BuildContext dialogContext) {
            return PaymentConfirmationWidget(
              orderId: widget.orderId.toString(),
              totalAmount: _currencyFormatter.format(widget.totalAmount),
              paymentMethod: _paymentMethodName,
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal memproses pembayaran formalitas: ${e.toString()}')),
        );
      }
      print('Error processing formality payment: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Konfirmasi Pembayaran',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A2E35))),
        backgroundColor: Colors.white,
        elevation: 0.8,
        centerTitle: true,
        automaticallyImplyLeading: false, // Hapus tombol back agar alur jelas
        iconTheme: const IconThemeData(color: Color(0xFF205781)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/pay.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Detail Pesanan Anda',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF333333)),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Mohon konfirmasi detail di bawah ini untuk melanjutkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Poppins',
                    color: Colors.grey[600]),
              ),
              const SizedBox(height: 24.0),
              Card(
                elevation: 0, // Minimalis tanpa bayangan
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: const Color(0xFF205781), width: 3),
                ),
                color: const Color(0xFF205781),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('ID Pesanan:', '#${widget.orderId}'),
                      const SizedBox(height: 12),
                      _buildDetailRow('Total Pembayaran:',
                          _currencyFormatter.format(widget.totalAmount)),
                      const SizedBox(height: 12),
                      _buildDetailRow('Metode:', _paymentMethodName),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Text(
                'Dengan menekan tombol "Konfirmasi Pembayaran", pesanan Anda akan ditandai sebagai telah dibayar dan stok produk akan diperbarui.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Poppins',
                    color: Colors.grey[500],
                    height: 1.4),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF205781),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 2.0,
                ),
                onPressed:
                    _isProcessingPayment ? null : _processFormalityPayment,
                child: _isProcessingPayment
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('Konfirmasi Pembayaran'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 15,
              fontFamily: 'Poppins',
              color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ],
    );
  }
}
