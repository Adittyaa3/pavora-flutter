import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectuasv2/core/constants/app_assets.dart';
// Import halaman keranjang untuk navigasi
import 'package:projectuasv2/page/card.dart';

/// Halaman untuk menampilkan detail produk dan menambahkan produk ke keranjang.
class BuySection extends StatefulWidget {
  final int productId;
  final String productTitle;
  final double productPrice;
  final String? productImage;
  final String? productDescription;
  final int productStock;
  final double? originalPrice;
  final double? discount;
  final VoidCallback? onProductAdded;

  const BuySection({
    super.key,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    this.productImage,
    this.productDescription,
    required this.productStock,
    this.originalPrice,
    this.discount,
    this.onProductAdded,
  });

  @override
  _BuySectionState createState() => _BuySectionState();
}

class _BuySectionState extends State<BuySection> {
  int _quantity = 1;
  bool _isAddingToCart = false;

  String _formatPrice(double price) {
    return '${(price / 1000).toStringAsFixed(0)}K';
  }

  Future<int> _getOrCreateCartId() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('Tidak ada pengguna yang login');

    final response = await Supabase.instance.client
        .from('carts')
        .select('id')
        .eq('user_id', user.id)
        .maybeSingle();

    if (response == null) {
      final newCart = await Supabase.instance.client
          .from('carts')
          .insert({'user_id': user.id}).select('id').single();
      return newCart['id'] as int;
    }
    return response['id'] as int;
  }

  // Fungsi navigasi ke keranjang, bisa dipakai berulang kali
  void _navigateToCart() {
    // Pastikan import 'package:projectuasv2/page/card.dart'; ada
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          onNavigateToHome: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Future<void> _addToCart() async {
    if (_quantity > widget.productStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah melebihi stok yang tersedia')),
      );
      return;
    }

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final cartId = await _getOrCreateCartId();

      final existingItem = await Supabase.instance.client
          .from('cart_items')
          .select('id, quantity')
          .eq('cart_id', cartId)
          .eq('product_id', widget.productId)
          .maybeSingle();

      if (existingItem != null) {
        final newQuantity = existingItem['quantity'] + _quantity;
        if (newQuantity > widget.productStock) {
          throw Exception('Jumlah total melebihi stok yang tersedia');
        }
        await Supabase.instance.client
            .from('cart_items')
            .update({
              'quantity': newQuantity,
              'price': widget.productPrice,
            })
            .eq('id', existingItem['id']);
      } else {
        await Supabase.instance.client.from('cart_items').insert({
          'cart_id': cartId,
          'product_id': widget.productId,
          'quantity': _quantity,
          'price': widget.productPrice,
          'original_price': widget.originalPrice,
          'discount': widget.discount,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 28),
              SizedBox(width: 16),
              Expanded(
                child: Text('Berhasil ditambahkan!', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6.0,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'LIHAT',
            textColor: Colors.white,
            onPressed: _navigateToCart,
          ),
        ),
      );

      if (widget.onProductAdded != null) {
        widget.onProductAdded!();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan ke keranjang: $e')),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack( // Kembali menggunakan Stack sesuai struktur asli Anda
        children: [
          // Konten utama dengan SingleChildScrollView
          SingleChildScrollView(
            child: Container(
              width: screenWidth,
              color: const Color(0xFFD0DAE2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildImageCarousel(screenWidth),
                  _buildProductDetails(),
                  // Tambahkan padding bawah yang lebih besar untuk ruang tombol sticky
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          // Tombol sticky di footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, 
            child: _buildStickyAddToCartButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: Color(0xFF205781)),
            onPressed: () => Navigator.pop(context),
          ),
          // ================== PERUBAHAN 1: Mengganti Ikon dan Aksinya ==================
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 30, color: Color(0xFF205781)),
            onPressed: _navigateToCart,
          ),
        ],
      ),
    );
  }

  // Sisa kode di bawah ini tidak ada perubahan fungsional, hanya kembali ke struktur asli Anda.
  
  Widget _buildImageCarousel(double screenWidth) {
    final imageUrl = widget.productImage ?? AppImages.chair1;
    final isNetworkImage = imageUrl.startsWith('http') || imageUrl.startsWith('https');

    return SizedBox(
      width: screenWidth,
      height: 378,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(), // Agar tidak bisa di-scroll jika hanya 1 gambar
        children: [
          _buildProductCard(
            imageUrl: imageUrl,
            isNetworkImage: isNetworkImage,
            width: 267,
            height: 317,
            leftPadding: 74,
            rightPadding: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 10),
            child: Text(
              widget.productTitle,
              style: const TextStyle(
                color: Color(0xFF0C0C0C),
                fontSize: 36,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20),
            child: Text(
              widget.productDescription ?? 'Deskripsi tidak tersedia',
              style: const TextStyle(
                color: Color(0xFF9B9B9B),
                fontSize: 16,
                fontFamily: 'Sora',
                fontWeight: FontWeight.w400,
                height: 1.64,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.originalPrice != null && widget.discount != null)
                  Text(
                    'Harga Asli: ${_formatPrice(widget.originalPrice!)}',
                    style: const TextStyle(
                      color: Color(0xFF9B9B9B),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                if (widget.originalPrice != null && widget.discount != null)
                  const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Harga: ${_formatPrice(widget.productPrice)}',
                      style: const TextStyle(
                        color: Color(0xFF0C0C0C),
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.discount != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${widget.discount!.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20),
            child: _buildQuantitySelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
     return Container(
      width: 120,
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF205781)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.remove, color: Color(0xFF3E4462)),
            onPressed: () {
              setState(() {
                if (_quantity > 1) _quantity--;
              });
            },
          ),
          Text(
            '$_quantity',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, color: Color(0xFF205781)),
            onPressed: () {
              setState(() {
                if (_quantity < widget.productStock) _quantity++;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStickyAddToCartButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
        onPressed: _isAddingToCart ? null : _addToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF205781),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             _isAddingToCart
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Tambah ke Keranjang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String imageUrl,
    required bool isNetworkImage,
    required double width,
    required double height,
    required double leftPadding,
    required double rightPadding,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: isNetworkImage ? NetworkImage(imageUrl) : AssetImage(imageUrl),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) => const AssetImage(AppImages.chair1),
          ),
        ),
      ),
    );
  }
}