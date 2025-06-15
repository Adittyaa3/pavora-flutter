import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;
  const OrderDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _orderData;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            id,
            total_amount,
            status,
            shipping_address,
            shipping_method,
            created_at,
            order_items (
              quantity,
              price,
              original_price,
              discount,
              products (title, image)
            ),
            payments (payment_type, status)
          ''')
          .eq('id', widget.orderId)
          .single();

      if (mounted) {
        setState(() {
          _orderData = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat detail pesanan: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Detail Pesanan'),
        backgroundColor: Color(0xFF205781),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0.5,
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
    if (_orderData == null) {
      return const Center(child: Text('Data pesanan tidak ditemukan.'));
    }

    final order = _orderData!;
    final List<dynamic> items = order['order_items'] ?? [];
    final List<dynamic> payments = order['payments'] ?? [];
    final paymentInfo = payments.isNotEmpty ? payments.first : null;

    final DateTime? createdAt = DateTime.tryParse(order['created_at'] ?? '');
    final dateFormatted = createdAt != null
        ? DateFormat('d MMMM y, HH:mm', 'id_ID').format(createdAt)
        : 'Tanggal tidak tersedia';
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            child: Column(
              children: [
                
                _buildInfoRow('ID Pesanan', '#${order['id']?.toString() ?? 'N/A'}'),
                const Divider(height: 24,color: const Color(0xFF205781),),
                _buildInfoRow('Tanggal', dateFormatted),
                const Divider(height: 24,color: const Color(0xFF205781),),
                _buildInfoRow('Status Pesanan', order['status']?.toString().toUpperCase() ?? 'N/A',
                  valueColor: _getStatusColor(order['status']?.toString() ?? '')
                ),
              ],
            )
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Daftar Barang'),
          const SizedBox(height: 8),
          _buildSectionCard(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) => _buildOrderItem(items[index]),
              separatorBuilder: (context, index) => const Divider(),
            )
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Informasi Pengiriman'),
          const SizedBox(height: 8),
          _buildSectionCard(
            child: Column(
              children: [
                _buildInfoRow('Metode', order['shipping_method'] ?? 'N/A'),
                _buildInfoRow('Alamat', order['shipping_address'] ?? 'Tidak ada alamat', isMultiline: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Rincian Pembayaran'),
          const SizedBox(height: 8),
          _buildSectionCard(
            child: Column(
              children: [
                _buildInfoRow('Metode Pembayaran', paymentInfo?['payment_type']?.toString().toUpperCase() ?? 'N/A'),
                _buildInfoRow('Status Pembayaran', paymentInfo?['status']?.toString().toUpperCase() ?? 'N/A'),
                const Divider(height: 24,color: const Color(0xFF205781),),
                _buildInfoRow(
                  'Total Pembayaran', 
                  currencyFormat.format(order['total_amount']),
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color:const Color(0xFF205781)),
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false, bool isMultiline = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                color: Colors.black54,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    final product = item['products'];
    if (product == null) return const SizedBox.shrink();

    final imageUrl = product['image'];
    final originalPrice = item['original_price'] as double?;
    final discount = item['discount'] as double?;
    final itemPrice = (item['price'] as num? ?? 0.0).toDouble();
    final int quantity = (item['quantity'] as int? ?? 0);

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, color: Colors.grey, size: 30);
                      },
                    )
                  : const Icon(Icons.image_not_supported, color: Colors.grey, size: 30),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Jumlah: $quantity',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                if (originalPrice != null && discount != null && discount > 0)
                  Text(
                    'Harga Asli: ${currencyFormat.format(originalPrice * quantity)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Row(
                  children: [
                    Text(
                      'Harga: ${currencyFormat.format(itemPrice * quantity)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    if (discount != null && discount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${discount.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green.shade700;
      case 'canceled':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }
}