import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectuasv2/order/chekout.dart';
import 'package:intl/intl.dart'; // Impor package intl

/// Halaman untuk menampilkan daftar produk di keranjang belanja.
class CartPage extends StatefulWidget {
  final VoidCallback? onNavigateToHome;
  const CartPage({super.key, this.onNavigateToHome});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Public method to refresh cart items
  Future<void> refreshCart() async {
    await _fetchCartItems();
  }

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Silakan login untuk melihat keranjang Anda'),
            ),
          );
        }
        return;
      }

      final cartResponse = await Supabase.instance.client
          .from('carts')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (cartResponse == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _cartItems = [];
          });
        }
        return;
      }

      final cartId = cartResponse['id'] as int;

      final response = await Supabase.instance.client
          .from('cart_items')
          .select(
            'id, quantity, price, product_id, products(title, image, description, stock)',
          )
          .eq('cart_id', cartId)
          .order('id', ascending: true);

      final List<Map<String, dynamic>> fetchedItems = [];
      for (var itemData in response) {
        final productInfo = itemData['products'] as Map<String, dynamic>?;
        fetchedItems.add({
          'id': itemData['id'],
          'quantity': itemData['quantity'],
          'price': itemData['price'],
          'product_id': itemData['product_id'],
          'title': productInfo?['title'] ?? 'Produk Tidak Ditemukan',
          'image': productInfo?['image'],
          'description':
              productInfo?['description'] ?? 'Deskripsi tidak tersedia.',
          'stock': productInfo?['stock'] ?? 0,
        });
      }

      if (mounted) {
        setState(() {
          _cartItems = fetchedItems;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat keranjang: ${e.toString()}')),
        );
        print('Error fetching cart items: $e');
      }
    }
  }

  Future<void> _removeCartItem(int cartItemId) async {
    try {
      await Supabase.instance.client
          .from('cart_items')
          .delete()
          .eq('id', cartItemId);
      _fetchCartItems();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus item: $e')));
      }
    }
  }

  double _calculateTotalPrice() {
    return _cartItems.fold(0.0, (total, item) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = (item['quantity'] as int?) ?? 0;
      return total + (price * quantity);
    });
  }

  Future<void> _updateQuantity(
    int cartItemId,
    int newQuantity,
    int stock,
  ) async {
    if (newQuantity <= 0) {
      await _removeCartItem(cartItemId);
      return;
    }
    if (newQuantity > stock) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kuantitas melebihi stok yang tersedia (Stok: $stock)',
            ),
          ),
        );
      }
      _fetchCartItems();
      return;
    }

    try {
      await Supabase.instance.client
          .from('cart_items')
          .update({'quantity': newQuantity}).eq('id', cartItemId);
      _fetchCartItems();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui kuantitas: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang utama putih
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ), // Warna teks AppBar
        backgroundColor: const Color(0xFF205781), // Latar belakang AppBar putih
        foregroundColor: const Color(0xFF205781), // Warna ikon back (jika ada)
        elevation: 0.5, // Elevasi minimal untuk garis tipis pemisah
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF205781)),
            )
          : _cartItems.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0), // Tambah padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/cart.png'),
                        const SizedBox(height: 24),
                        const Text(
                          'Your Cart is Empty :(',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Lets add some products to your cart and start shopping :D',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15, // Ukuran font disesuaikan
                            fontFamily: 'Poppins',
                            color: Colors.grey[500],
                          ), // Warna teks lebih lembut
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF205781),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ), // Padding disesuaikan
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ), // Berat font disesuaikan
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // Border radius disesuaikan
                            ),
                            elevation: 2, // Sedikit elevasi untuk tombol
                          ),
                          onPressed: () {
                            widget.onNavigateToHome?.call();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                          ), // Ikon kembali
                          label: const Text('Back to Catalog'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          0,
                        ), // Padding disesuaikan
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return ProductCard(
                            title: item['title'] as String,
                            imageUrl: item['image'] as String?,
                            quantity: item['quantity'] as int,
                            price: (item['price'] as num).toDouble(),
                            description: item['description'] as String?,
                            stock: item['stock'] as int,
                            cartItemId: item['id'] as int,
                            onDelete: () => _removeCartItem(item['id'] as int),
                            onQuantityChanged: (newQuantity) {
                              _updateQuantity(
                                item['id'] as int,
                                newQuantity,
                                item['stock'] as int,
                              );
                            },
                            currencyFormatter: _currencyFormatter,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12), // Jarak antar card
                      ),
                    ),
                    _buildSummaryAndCheckout(),
                  ],
                ),
    );
  }

  Widget _buildSummaryAndCheckout() {
    final totalPrice = _calculateTotalPrice();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ), // Padding disesuaikan
      decoration: BoxDecoration(
        color: Colors.white, // Pastikan background putih
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1.0,
          ), // Garis pemisah tipis di atas
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Jarak bawah
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pesanan:', // Teks diubah
                  style: TextStyle(
                    fontSize: 17, // Ukuran font disesuaikan
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Color(0xFF555555),
                  ), // Warna teks
                ),
                Text(
                  _currencyFormatter.format(totalPrice),
                  style: const TextStyle(
                    fontSize: 20, // Ukuran font disesuaikan
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF205781),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF205781),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ), // Padding disesuaikan
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Border radius disesuaikan
                ),
                textStyle: const TextStyle(
                  fontSize: 17, // Ukuran font disesuaikan
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                elevation: 2, // Sedikit elevasi
              ),
              onPressed: _cartItems.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            cartItems: _cartItems,
                            totalPrice: totalPrice,
                          ),
                        ),
                      );
                    },
              child: const Text('Lanjut ke Checkout'), // Teks diubah
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget untuk menampilkan kartu produk di keranjang.
class ProductCard extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final int quantity;
  final double price;
  final String? description;
  final int stock;
  final int cartItemId;
  final VoidCallback onDelete;
  final Function(int) onQuantityChanged;
  final NumberFormat currencyFormatter;

  const ProductCard({
    super.key,
    required this.title,
    this.imageUrl,
    required this.quantity,
    required this.price,
    this.description,
    required this.stock,
    required this.cartItemId,
    required this.onDelete,
    required this.onQuantityChanged,
    required this.currencyFormatter,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // Tidak perlu _currentQuantity lagi jika kita selalu menggunakan widget.quantity
  // late int _currentQuantity;

  // @override
  // void initState() {
  //   super.initState();
  //   _currentQuantity = widget.quantity;
  // }

  // @override
  // void didUpdateWidget(covariant ProductCard oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.quantity != oldWidget.quantity &&
  //       widget.quantity != _currentQuantity) {
  //     setState(() {
  //       _currentQuantity = widget.quantity;
  //     });
  //   }
  // }

  void _incrementQuantity() {
    if (widget.quantity < widget.stock) {
      widget.onQuantityChanged(widget.quantity + 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stok maksimal untuk ${widget.title} adalah ${widget.stock}.',
          ),
        ),
      );
    }
  }

  void _decrementQuantity() {
    widget.onQuantityChanged(widget.quantity - 1);
  }

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = widget.imageUrl?.startsWith('http') ?? false;
    final ImageProvider<Object> imageProvider;

    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      imageProvider = isNetworkImage
          ? NetworkImage(widget.imageUrl!)
          : AssetImage(widget.imageUrl!) as ImageProvider;
    } else {
      imageProvider = const AssetImage('assets/images/placeholder.png');
    }

    return Container(
      // Mengganti Card dengan Container
      decoration: BoxDecoration(
        color: Colors.white, // Background putih untuk card
        borderRadius: BorderRadius.circular(10.0), // Border radius
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1.0,
        ), // Border tipis
      ),
      clipBehavior: Clip.antiAlias, // Untuk Dismissible
      child: Dismissible(
        key: ValueKey(widget.cartItemId),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          widget.onDelete();
        },
        background: Container(
          color: Colors.red.shade300, // Warna background hapus lebih lembut
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Icon(
            Icons.delete_sweep_outlined, // Ikon hapus yang berbeda
            color: Colors.white,
            size: 28,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Produk
              Container(
                width: 85, // Ukuran gambar disesuaikan
                height: 85, // Ukuran gambar disesuaikan
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white, // Background gambar putih
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain, // Contain agar gambar tidak terpotong
                    onError: (exception, stackTrace) {},
                  ),
                ),
                // Tambahkan border tipis di sekitar gambar jika diinginkan
                // child: DecoratedBox(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8.0),
                //     border: Border.all(color: Colors.grey[200]!, width: 0.8),
                //   ),
                // ),
              ),
              const SizedBox(width: 15), // Jarak antar elemen
              // Detail Produk & Kontrol Kuantitas
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15, // Ukuran font disesuaikan
                        fontWeight: FontWeight.w600, // Berat font disesuaikan
                        fontFamily: 'Poppins',
                        color: Color(0xFF252525),
                      ), // Warna teks lebih gelap
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5), // Jarak antar elemen
                    Text(
                      widget.currencyFormatter.format(widget.price),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Colors.orange.shade800, // Warna harga
                      ),
                    ),
                    if (widget.description != null &&
                        widget.description!.isNotEmpty &&
                        widget.description != 'Deskripsi tidak tersedia.')
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          widget.description!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontFamily: 'Poppins',
                          ), // Ukuran font deskripsi
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 10), // Jarak antar elemen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Kontrol Kuantitas
                        Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[100], // Warna latar tombol kuantitas
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: _decrementQuantity,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ), // Padding tombol
                                  child: Icon(
                                    Icons.remove,
                                    size: 18, // Ukuran ikon
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ), // Padding angka
                                child: Text(
                                  '${widget.quantity}',
                                  style: const TextStyle(
                                    fontSize: 15, // Ukuran angka
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: _incrementQuantity,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ), // Padding tombol
                                  child: Icon(
                                    Icons.add,
                                    size: 18, // Ukuran ikon
                                    color: const Color(0xFF205781),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Total Harga per Item
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4.0,
                          ), // Sedikit padding kanan
                          child: Text(
                            widget.currencyFormatter.format(
                              widget.price * widget.quantity,
                            ),
                            style: const TextStyle(
                              fontSize: 15, // Ukuran font total
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Color(0xFF205781),
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
        ),
      ),
    );
  }
}
