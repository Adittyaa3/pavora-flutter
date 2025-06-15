import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// Pastikan file ini ada dan path-nya benar
import 'package:projectuasv2/page/order_detail_page.dart';

// Halaman Riwayat Utama
class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // Fungsi _loadOrders tidak perlu diubah
  Future<void> _loadOrders() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _error = "Anda harus login untuk melihat riwayat.";
        });
        return;
      }

      final response = await _supabase
          .from('orders')
          .select('''
            id, 
            total_amount, 
            created_at,
            order_items (
              quantity,
              price,
              products (
                title,
                image
              )
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> loadedOrders =
          (response as List<dynamic>?)
                  ?.map((e) => e as Map<String, dynamic>)
                  .toList() ??
              [];

      if (mounted) {
        setState(() {
          _orders = loadedOrders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Gagal memuat riwayat: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF205781),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }
    if (_orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada riwayat pesanan.'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final List<dynamic> items = order['order_items'] ?? [];
    // 1. Ambil data tanggal di sini, satu kali untuk satu kartu pesanan
    final orderDate = DateTime.parse(order['created_at']);
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final totalFormatted = currencyFormat.format(order['total_amount']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF205781), width: 1.5),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(orderId: order['id']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Kartu: Hanya ID Pesanan
              // Text(
              //   'Pesanan #${order['id']}',
              //   style: const TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 16,
              //     color: Color(0xFF205781),
              //   ),
              // ),
              // const Divider(height: 24),
              
              // Daftar Item di dalam pesanan
              Column(
                children: items.map((item) {
                  // 2. Kirim data tanggal ke setiap item
                  return _buildSingleOrderItem(item, orderDate);
                }).toList(),
              ),
              
              if (items.isNotEmpty) const Divider(height: 24,color: const Color(0xFF205781),),
              
              // Footer Kartu: Total Harga
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Pesanan',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(
                    totalFormatted,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF205781)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // 3. Tambahkan parameter DateTime orderDate di sini
  Widget _buildSingleOrderItem(Map<String, dynamic> item, DateTime orderDate) {
    final product = item['products'];
    if (product == null) {
      return const ListTile(title: Text('Data produk tidak ditemukan.'));
    }

    final String productName = product['title'] ?? 'Nama Produk';
    final String? imageUrl = product['image'];
    final int quantity = item['quantity'] ?? 0;
    final double price = (item['price'] as num).toDouble();
    
    final dateFormatted = DateFormat('d MMM y, HH:mm', 'id_ID').format(orderDate);
    final subtotal = price * quantity;
    final subtotalFormatted = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(subtotal);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  '$quantity Item',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                // 5. Tampilkan tanggal yang sudah diformat di sini
                const SizedBox(height: 4),
                Text(
                  dateFormatted,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            subtotalFormatted,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}