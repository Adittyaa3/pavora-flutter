import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectuasv2/order/chekout.dart'; // Impor PaymentConfirmationWidget

class PaymentPage extends StatefulWidget {
  final int orderId;
  final double totalAmount;

  const PaymentPage({
    Key? key,
    required this.orderId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessingPayment = false;
  final String _paymentMethod = "Simulasi Pembayaran (Midtrans)"; // Nama metode pembayaran

  String _formatPriceRp(double price) {
    return 'Rp ${(price).toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    )}';
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessingPayment = true;
    });

    final supabase = Supabase.instance.client;

    try {
      // 1. Simpan data pembayaran ke tabel 'payments'
      // Untuk 'transaction_id' dan 'payment_url', ini akan diisi oleh Midtrans nantinya.
      // Untuk simulasi, kita bisa isi dengan placeholder.
      await supabase.from('payments').insert({
        'order_id': widget.orderId,
        'amount': widget.totalAmount,
        'status': 'approved', // Langsung 'approved' untuk simulasi pembayaran berhasil
        'payment_type': _paymentMethod,
        'transaction_id': 'SIMULASI-TRX-${DateTime.now().millisecondsSinceEpoch}', // ID transaksi simulasi
        'payment_url': null, // Akan diisi oleh Midtrans jika menggunakan payment URL
        'payment_date': DateTime.now().toIso8601String(),
      });

      // 2. Tampilkan dialog konfirmasi pembayaran
      // Gunakan PaymentConfirmationWidget yang sudah ada
      showDialog(
        context: context,
        barrierDismissible: false, // Pengguna harus menekan tombol untuk menutup
        builder: (BuildContext dialogContext) {
          return PaymentConfirmationWidget(
            orderId: widget.orderId.toString(),
            totalAmount: _formatPriceRp(widget.totalAmount),
            paymentMethod: _paymentMethod,
          );
        },
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses pembayaran: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF205781),
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false, // Hapus tombol back default
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ringkasan Pesanan Anda',
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF205781),
                            fontFamily: 'Poppins'
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      _buildInfoRow('ID Pesanan:', '#${widget.orderId}'),
                      const SizedBox(height: 12.0),
                      _buildInfoRow('Total Pembayaran:', _formatPriceRp(widget.totalAmount)),
                      const SizedBox(height: 12.0),
                      _buildInfoRow('Metode Pembayaran:', _paymentMethod),
                      const SizedBox(height: 24.0),
                      Text(
                        'Ini adalah halaman simulasi pembayaran. Untuk integrasi nyata dengan Midtrans, halaman ini akan menampilkan gateway pembayaran Midtrans.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF205781),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                onPressed: _isProcessingPayment ? null : _processPayment,
                child: _isProcessingPayment
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : const Text('Bayar Sekarang (Simulasi)', style: TextStyle(color: Colors.white)),
              ),
              // Tidak ada tombol batalkan di sini karena alur sudah masuk ke pembayaran
              // Jika ingin membatalkan, biasanya dilakukan sebelum masuk ke halaman ini atau via mekanisme Midtrans.
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.0, color: Colors.grey[700], fontFamily: 'Poppins'),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87, fontFamily: 'Poppins'),
        ),
      ],
    );
  }
}