import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk Clipboard
import 'package:supabase_flutter/supabase_flutter.dart'; // Impor Supabase
// Pastikan Anda membuat file ini di langkah berikutnya
import 'package:projectuasv2/page/payment_page.dart';
import 'package:projectuasv2/page/formality_payment_page.dart';

// --- [BAGIAN 1: WIDGET KONFIRMASI PEMBAYARAN (TETAP SAMA)] ---
class PaymentConfirmationWidget extends StatelessWidget {
  final String orderId;
  final String totalAmount;
  final String paymentMethod;

  const PaymentConfirmationWidget({
    Key? key,
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
  }) : super(key: key);

  static String _formatCurrency(double price) {
    return 'Rp ${(price).toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green,
              size: 70.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Pembayaran Berhasil!",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12.0),
            const Text(
              "Terima kasih! Pesananmu sedang kami proses.",
              style: TextStyle(fontSize: 15.0, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            _buildDetailRow("No. Pesanan:", "#$orderId"),
            _buildDetailRow("Total Bayar:", totalAmount),
            _buildDetailRow("Metode Bayar:", paymentMethod),
            const SizedBox(height: 28.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF205781),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
                // Arahkan pengguna kembali ke halaman utama atau daftar pesanan
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
              },
              child: const Text("Selesai"),
            ),
            TextButton(
              onPressed: (){
                Clipboard.setData(ClipboardData(text: "No. Pesanan: #$orderId\nTotal Bayar: $totalAmount\nMetode Bayar: $paymentMethod"));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Detail transaksi disalin!")),
                );
              },
              child: const Text("Salin Detail", style: TextStyle(color: Color(0xFF205781))),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[700], fontFamily: 'Poppins'),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87, fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }
}


// --- [BAGIAN 2: HALAMAN CHECKOUT YANG DIMODIFIKASI] ---
class CheckoutPage extends StatefulWidget { // Diubah menjadi StatefulWidget
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isProcessingOrder = false; // State untuk loading

  String _formatPriceK(double price) {
    if (price < 1000) return price.toStringAsFixed(0);
    return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K';
  }

  String _formatPriceRp(double price) {
    return 'Rp ${(price).toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    )}';
  }

  // Fungsi untuk memproses pesanan dan navigasi ke pembayaran
  Future<void> _processOrderAndNavigateToPayment(BuildContext context) async {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang Anda kosong. Tidak dapat melanjutkan.')),
      );
      return;
    }

    setState(() {
      _isProcessingOrder = true;
    });

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus login untuk membuat pesanan.')),
      );
      setState(() {
        _isProcessingOrder = false;
      });
      return;
    }

    try {
      // 1. Buat entri baru di tabel 'orders'
      final orderResponse = await supabase.from('orders').insert({
        'user_id': user.id,
        'total_amount': widget.totalPrice,
        'status': 'pending', // Status awal pesanan
        'shipping_address': 'Alamat Pengiriman Default', // Ganti dengan data alamat sebenarnya jika ada
        'shipping_method': 'Metode Pengiriman Default', // Ganti dengan metode pengiriman sebenarnya jika ada
      }).select('id').single(); // Ambil ID pesanan yang baru dibuat

      final orderId = orderResponse['id'] as int;

      // 2. Buat entri baru di tabel 'order_items' untuk setiap item di keranjang
      List<Map<String, dynamic>> orderItemsData = [];
      for (var item in widget.cartItems) {
        // Pastikan semua key yang dibutuhkan ada di 'item'
        // 'product_id', 'quantity', 'price' adalah yang utama untuk 'order_items'
        if (item['product_id'] == null || item['quantity'] == null || item['price'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data item keranjang tidak lengkap untuk produk: ${item['title'] ?? 'Tidak diketahui'}')),
          );
          setState(() { _isProcessingOrder = false; });
          return; // Hentikan proses jika data item tidak lengkap
        }
        orderItemsData.add({
          'order_id': orderId,
          'product_id': item['product_id'],
          'quantity': item['quantity'],
          'price': item['price'],
        });
      }
      await supabase.from('order_items').insert(orderItemsData);

      // 3. Bersihkan keranjang belanja (cart_items) untuk pengguna ini
      // Pertama, dapatkan cart_id pengguna
      final cartData = await supabase
          .from('carts')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (cartData != null) {
        final cartId = cartData['id'] as int;
        // Hapus semua item dari cart_items yang terkait dengan cart_id ini
        await supabase.from('cart_items').delete().eq('cart_id', cartId);

        // Opsional: Anda bisa menghapus record 'carts' itu sendiri jika sudah kosong.
        // Namun, biasanya lebih baik membiarkannya agar tidak perlu membuat ulang saat pengguna menambahkan item lagi.
        // final remainingItems = await supabase.from('cart_items').select('id').eq('cart_id', cartId).limit(1);
        // if (remainingItems.isEmpty) {
        //   await supabase.from('carts').delete().eq('id', cartId);
        // }
      }


      // 4. Navigasi ke halaman pembayaran
      // Gunakan pushReplacement agar pengguna tidak bisa kembali ke halaman checkout setelah pesanan dibuat
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FormalityPaymentPage(
            orderId: orderId,
            totalAmount: widget.totalPrice,
          ),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat pesanan: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isProcessingOrder = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: _isProcessingOrder ? null : () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Poppins'
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          color: Colors.white,
          padding: EdgeInsets.only(
            left: screenWidth * 0.035,
            top: screenHeight * 0.03,
            right: screenWidth * 0.035,
            bottom: screenHeight * 0.02, // Original padding, as button is now in bottomNavigationBar
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCartItemsList(context),
              SizedBox(height: screenHeight * 0.026),
              _buildTotalPrice(screenWidth),
              SizedBox(height: screenHeight * 0.026),
              _buildPaymentMethodPlaceholder(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.026),
              _buildPolicySection(screenWidth, screenHeight),
              // Removed SizedBox(height: screenHeight * 0.04) here as it's not needed for spacing with the bottom navigation bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white, // Background for the button area
        padding: EdgeInsets.only(
          left: screenWidth * 0.07,
          right: screenWidth * 0.07,
          top: screenHeight * 0.02,
          bottom: screenHeight * 0.02 + MediaQuery.of(context).padding.bottom, // Add bottom safe area padding
        ),
        child: _buildPayNowButton(context, screenWidth, screenHeight),
      ),
    );
  }

  Widget _buildCartItemsList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (widget.cartItems.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
        child: const Text(
          "Keranjang Anda kosong.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: widget.cartItems.map((item) {
        // Ambil data dengan aman, berikan nilai default jika null
        final String title = item['title'] ?? 'Produk Tidak Bernama';
        final String? imageUrl = item['image'] as String?; // 'image' dari cart_items bisa jadi null
        final num price = item['price'] ?? 0.0;
        final int quantity = item['quantity'] ?? 0;

        final isNetworkImage = imageUrl?.startsWith('http') ?? false;
        final ImageProvider<Object> imageProvider;
        if (imageUrl != null) {
          imageProvider = isNetworkImage
              ? NetworkImage(imageUrl)
              : AssetImage(imageUrl) as ImageProvider;
        } else {
          imageProvider = const AssetImage('assets/images/placeholder.png'); // Sediakan placeholder
        }


        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.35,
                height: screenHeight * 0.14,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFECECEC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image for "$title": $error');
                    return const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40));
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title, // Menggunakan 'title' yang diambil dari item
                        style: TextStyle(
                          color: const Color(0xFF0C0C0C),
                          fontSize: screenWidth * 0.04,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: $quantity',
                        style: TextStyle(
                          color: const Color(0xFF9B9B9B),
                          fontSize: screenWidth * 0.033,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatPriceK((price).toDouble() * quantity),
                        style: TextStyle(
                          color: const Color(0xFF0C0C0C),
                          fontSize: screenWidth * 0.045,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotalPrice(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Harga:',
            style: TextStyle(
              color: Colors.black87,
              fontSize: screenWidth * 0.045,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _formatPriceRp(widget.totalPrice),
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.055,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodPlaceholder(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      height: screenHeight * 0.15,
      decoration: ShapeDecoration(
        color: const Color(0xFFECECEC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Metode Pembayaran',
            style: TextStyle(
              color: Colors.black87,
              fontSize: screenWidth * 0.04,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anda akan diarahkan ke halaman pembayaran setelah ini.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: screenWidth * 0.035,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.85,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: [
          Text(
            'Kebijakan Kami',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: screenWidth * 0.036,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenHeight * 0.007),
          Text(
            'Anda tidak dapat melakukan pembatalan dan perubahan apapun pada pesanan setelah melakukan pembayaran.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: screenWidth * 0.03,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPayNowButton(BuildContext context, double screenWidth, double screenHeight) {
    return ElevatedButton(
      onPressed: _isProcessingOrder ? null : () {
        _processOrderAndNavigateToPayment(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF205781),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.zero,
        minimumSize: Size(double.infinity, screenHeight * 0.065), // Ensures full width and correct height
      ),
      child: _isProcessingOrder
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: Color.fromARGB(255, 0, 0, 0), strokeWidth: 3),
      )
          : Text(
        'Pay Now',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.04,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}