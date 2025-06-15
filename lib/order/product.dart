import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectuasv2/core/constants/app_assets.dart';
import 'package:projectuasv2/order/buy.dart';

/// Halaman untuk menampilkan daftar produk berdasarkan kategori yang dipilih.
class ProductPage extends StatefulWidget {
  final int categoryId; // ID kategori untuk memfilter produk
  final String categoryName; // Nama kategori untuk ditampilkan di AppBar

  const ProductPage(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> _products =
      []; // Daftar produk yang diambil dari Supabase
  bool _isLoading = true; // Status loading saat mengambil data

  @override
  void initState() {
    super.initState();
    // Validasi categoryId sebelum mengambil data
    if (widget.categoryId == 0) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID kategori tidak valid')),
      );
      return;
    }
    _fetchProducts();
  }

  /// Mengambil data produk dari Supabase berdasarkan categoryId.
  Future<void> _fetchProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select('id, title, price, image, description, stock')
          .eq('categories_id', widget.categoryId);

      setState(() {
        _products = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat produk: $e')),
      );
    }
  }

  /// Memformat harga ke dalam format "K" (misalnya, 891000 -> 891K).
  String _formatPrice(dynamic price) {
    if (price == null) return '0K';
    final priceValue =
        price is String ? double.tryParse(price) ?? 0.0 : price.toDouble();
    return '${(priceValue / 1000).toStringAsFixed(0)}K';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Pisah produk ke dua kolom (kiri dan kanan) untuk layout
    List<Map<String, dynamic>> leftColumnProducts = [];
    List<Map<String, dynamic>> rightColumnProducts = [];
    for (int i = 0; i < _products.length; i++) {
      if (i % 2 == 0) {
        leftColumnProducts.add(_products[i]);
      } else {
        rightColumnProducts.add(_products[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF205781),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Kategori ${widget.categoryName}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Poppins',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? Container(

                  color: Colors.white,
                  child: const Center(
                    child: Text('Tidak ada produk tersedia untuk kategori ini'
                    ,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Color(0xFF205781),
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    width: screenWidth,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.034,
                      vertical: screenHeight * 0.023,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: List.generate(leftColumnProducts.length,
                                (index) {
                              final product = leftColumnProducts[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: screenHeight * 0.039),
                                child: ProductCard(
                                  product: product,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  isLeftColumn: true,
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.0001),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: List.generate(rightColumnProducts.length,
                                (index) {
                              final product = rightColumnProducts[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.023,
                                ),
                                child: ProductCard(
                                  product: product,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  isLeftColumn: false,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

/// Widget untuk menampilkan kartu produk individual.
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final double screenWidth;
  final double screenHeight;
  final bool isLeftColumn;

  const ProductCard({
    super.key,
    required this.product,
    required this.screenWidth,
    required this.screenHeight,
    required this.isLeftColumn,
  });

  /// Memformat harga ke dalam format "K" (misalnya, 891000 -> 891K).
  String _formatPrice(dynamic price) {
    if (price == null) return '0K';
    final priceValue =
        price is String ? double.tryParse(price) ?? 0.0 : price.toDouble();
    return '${(priceValue / 1000).toStringAsFixed(0)}K';
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = isLeftColumn ? screenWidth * 0.48 : screenWidth * 0.4;
    final cardHeight = isLeftColumn ? screenHeight * 0.21 : screenHeight * 0.28;
    final imageWidth = isLeftColumn ? screenWidth * 0.24 : screenWidth * 0.24;
    final imageHeight =
        isLeftColumn ? screenHeight * 0.14 : screenHeight * 0.17;

    final imageUrl = product['image'] ?? AppImages.chair1;
    final isNetworkImage =
        imageUrl.startsWith('http') || imageUrl.startsWith('https');
    final ImageProvider<Object> imageProvider =
        isNetworkImage ? NetworkImage(imageUrl) : AssetImage(imageUrl);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuySection(
              productId: product['id'] as int,
              productTitle: product['title'] as String? ?? 'Nama Produk',
              productPrice: (product['price'] as num?)?.toDouble() ?? 0.0,
              productImage: product['image'] as String?,
              productDescription: product['description'] as String? ??
                  'Deskripsi tidak tersedia',
              productStock: product['stock'] as int? ?? 0,
            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: ShapeDecoration(
          color: const Color(0xFFECECEC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text(
              product['title'] ?? 'Nama Produk',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF0C0C0C),
                fontSize: screenWidth * 0.032,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: screenHeight * 0.002),
            Text(
              _formatPrice(product['price']),
              textAlign: TextAlign.center,
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
    );
  }
}



  // import 'package:flutter/material.dart';
  // import 'package:supabase_flutter/supabase_flutter.dart';
  // import 'package:projectuasv2/core/constants/app_assets.dart';
  // import 'package:projectuasv2/order/buy.dart';

  // /// Halaman untuk menampilkan daftar produk berdasarkan kategori yang dipilih.
  // class ProductPage extends StatefulWidget {
  //   final int categoryId; // ID kategori untuk memfilter produk
  //   final String categoryName; // Nama kategori untuk ditampilkan di AppBar

  //   const ProductPage(
  //       {super.key, required this.categoryId, required this.categoryName});

  //   @override
  //   _ProductPageState createState() => _ProductPageState();
  // }

  // class _ProductPageState extends State<ProductPage> {
  //   List<Map<String, dynamic>> _products = []; // Daftar produk
  //   bool _isLoading = true; // Status loading

  //   @override
  //   void initState() {
  //     super.initState();
  //     _fetchProducts();
  //   }

  //   /// Mengambil data produk dari Supabase berdasarkan categoryId.
  //   Future<void> _fetchProducts() async {
  //     // ... (Fungsi ini tidak perlu diubah)
  //     try {
  //       final response = await Supabase.instance.client
  //           .from('products')
  //           .select('id, title, price, image, description, stock')
  //           .eq('categories_id', widget.categoryId);

  //       setState(() {
  //         _products = List<Map<String, dynamic>>.from(response);
  //         _isLoading = false;
  //       });
  //     } catch (e) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Gagal memuat produk: $e')),
  //       );
  //     }
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         // ... (AppBar tidak perlu diubah)
  //         backgroundColor: const Color(0xFF205781),
  //         elevation: 0,
  //         leading: IconButton(
  //           icon: const Icon(
  //             Icons.arrow_back,
  //             color: Color.fromARGB(255, 255, 255, 255),
  //           ),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ),
  //         title: Text(
  //           'Kategori ${widget.categoryName}',
  //           style: const TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: Color.fromARGB(255, 255, 255, 255),
  //             fontFamily: 'Poppins',
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //         centerTitle: true,
  //       ),
  //       body: _isLoading
  //           ? const Center(child: CircularProgressIndicator())
  //           : _products.isEmpty
  //               ? const Center(
  //                   child: Text('Tidak ada produk tersedia untuk kategori ini'),
  //                 )
  //               // ================== PERUBAHAN UTAMA DIMULAI DARI SINI ==================
  //               // Mengganti layout manual dengan GridView.builder
  //               : GridView.builder(
  //                   padding: const EdgeInsets.all(16.0),
  //                   // Konfigurasi Grid
  //                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 2, // Menentukan ada 2 kolom
  //                     crossAxisSpacing: 16.0, // Jarak horizontal antar kartu
  //                     mainAxisSpacing: 16.0, // Jarak vertikal antar kartu
  //                     childAspectRatio: 0.75, // Rasio lebar:tinggi kartu
  //                   ),
  //                   itemCount: _products.length,
  //                   itemBuilder: (context, index) {
  //                     final product = _products[index];
  //                     // Setiap item di grid akan menjadi ProductCard
  //                     return ProductCard(product: product);
  //                   },
  //                 ),
  //     );
  //   }
  // }

  // // ================== WIDGET PRODUCTCARD MENJADI LEBIH SEDERHANA ==================
  // /// Widget untuk menampilkan kartu produk individual.
  // class ProductCard extends StatelessWidget {
  //   final Map<String, dynamic> product;

  //   const ProductCard({
  //     super.key,
  //     required this.product,
  //   });

  //   /// Memformat harga ke dalam format "K" (misalnya, 891000 -> 891K).
  //   String _formatPrice(dynamic price) {
  //     if (price == null) return '0K';
  //     final priceValue =
  //         price is String ? double.tryParse(price) ?? 0.0 : price.toDouble();
  //     return '${(priceValue / 1000).toStringAsFixed(0)}K';
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     final imageUrl = product['image'] ?? AppImages.chair1;
  //     final isNetworkImage =
  //         imageUrl.startsWith('http') || imageUrl.startsWith('https');
  //     final ImageProvider<Object> imageProvider =
  //         isNetworkImage ? NetworkImage(imageUrl) : AssetImage(imageUrl);

  //     return GestureDetector(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => BuySection(
  //               productId: product['id'] as int,
  //               productTitle: product['title'] as String? ?? 'Nama Produk',
  //               productPrice: (product['price'] as num?)?.toDouble() ?? 0.0,
  //               productImage: product['image'] as String?,
  //               productDescription: product['description'] as String? ??
  //                   'Deskripsi tidak tersedia',
  //               productStock: product['stock'] as int? ?? 0,
  //             ),
  //           ),
  //         );
  //       },
  //       child: Container(
  //         decoration: ShapeDecoration(
  //           color: const Color(0xFFECECEC),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(24), // Radius disesuaikan
  //           ),
  //         ),
  //         child: Padding(
  //           // Memberi padding di dalam kartu agar konten tidak menempel
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             // Konten di dalam kartu
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               Expanded(
  //                 flex: 3, // Beri porsi lebih besar untuk gambar
  //                 child: Image(
  //                   image: imageProvider,
  //                   fit: BoxFit.contain,
  //                   errorBuilder: (context, error, stackTrace) {
  //                     return const Icon(Icons.error);
  //                   },
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 2, // Beri porsi lebih kecil untuk teks
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       product['title'] ?? 'Nama Produk',
  //                       textAlign: TextAlign.center,
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: const TextStyle(
  //                         color: Color(0xFF0C0C0C),
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Text(
  //                       _formatPrice(product['price']),
  //                       textAlign: TextAlign.center,
  //                       style: const TextStyle(
  //                         color: Color(0xFF0C0C0C),
  //                         fontSize: 18,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w700,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }
