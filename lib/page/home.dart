import 'package:flutter/material.dart';
import 'package:projectuasv2/navigation_bar.dart';
import 'package:projectuasv2/page/card.dart';
import 'package:projectuasv2/page/history.dart';
import 'package:projectuasv2/page/profile.dart';
import 'package:projectuasv2/core/constants/app_assets.dart';
import 'package:projectuasv2/produk/categories.dart';
import 'package:projectuasv2/order/buy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// 'product.dart' tidak digunakan, bisa dihapus jika tidak ada kelas ProductItem di sana.
// import 'package:projectuasv2/order/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<CartPageState> _cartPageKey = GlobalKey<CartPageState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) { // If navigating to CartPage (index 1)
      _cartPageKey.currentState?.refreshCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeContent(cartPageKey: _cartPageKey), // Pass the key to _HomeContent
          CartPage(key: _cartPageKey, onNavigateToHome: () => _onItemTapped(0)),
          const HistoryPage(), // Menggunakan const untuk optimasi
          const ProfilePage(), // Menggunakan const untuk optimasi
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final GlobalKey<CartPageState> cartPageKey;
  const _HomeContent({Key? key, required this.cartPageKey}) : super(key: key);

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _discountedProducts = [];
  List<Map<String, dynamic>> _randomProducts = [];
  bool _isLoading = true;
  int _currentPageNumber = 1;
  final int _productsPerPage = 10;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchDiscountedProducts();
    _fetchRandomProducts();
  }

  Future<void> _fetchDiscountedProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select('id, title, price, image, description, stock, discount')
          .gt('discount', 0)
          .limit(3);

      setState(() {
        _discountedProducts = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching discounted products: $e');
    }
  }

  Future<void> _fetchRandomProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select('id, title, price, image, description, stock')
          .range((_currentPageNumber - 1) * _productsPerPage, 
                 _currentPageNumber * _productsPerPage - 1)
          .order('id', ascending: false);

      setState(() {
        _randomProducts = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching random products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      _fetchRandomProducts();
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('products')
          .select('id, title, price, image, description, stock')
          .ilike('title', '%$query%')
          .limit(_productsPerPage);

      setState(() {
        _randomProducts = List<Map<String, dynamic>>.from(response);
        _searchQuery = query;
      });
    } catch (e) {
      print('Error searching products: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProductCarousel(),
          const SizedBox(height: 16),
          _buildSearch(context),
          const SizedBox(height: 20),
          _buildRandomProducts(),
        ],
      ),
    );
  }

  Widget _buildProductCarousel() {
    return Container(
      height: 392,
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Color(0xFFCFDAE2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _discountedProducts.length,
            itemBuilder: (context, index) {
              return _buildProductCard(_discountedProducts[index]);
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _discountedProducts.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? const Color(0xFF205781)
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final originalPrice = (product['price'] as num).toDouble();
    final discount = (product['discount'] as num).toDouble();
    final discountedPrice = originalPrice * (1 - discount / 100);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuySection(
              productId: product['id'] as int,
              productTitle: product['title'] as String? ?? 'Nama Produk',
              productPrice: discountedPrice,
              productImage: product['image'] as String?,
              productDescription: product['description'] as String? ?? 'Deskripsi tidak tersedia',
              productStock: product['stock'] as int? ?? 0,
              originalPrice: originalPrice,
              discount: discount,
              onProductAdded: () {
                widget.cartPageKey.currentState?.refreshCart();
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Image.network(
                  product['image'] ?? AppImages.chair1,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
            ),
            Positioned(
              left: 15,
              bottom: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const ShapeDecoration(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rp ${discountedPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${discount.toStringAsFixed(0)}% OFF',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   right: 15,
            //   bottom: 40,
            //   child: Container(
            //     width: 60,
            //     height: 60,
            //     decoration: const ShapeDecoration(
            //       color: Colors.white,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(24)),
            //       ),
            //     ),
            //     child: const Icon(Icons.favorite_border, color: Colors.black),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: const ShapeDecoration(
                color: Color(0xFF205781),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Search Item',
                        hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        _searchProducts(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 11),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesPage()),
              );
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: const ShapeDecoration(
                color: Color(0xFF205781),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.categoris,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRandomProducts() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_randomProducts.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada produk yang ditemukan',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            color: Color(0xFF205781),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: _randomProducts.length,
          itemBuilder: (context, index) {
            final product = _randomProducts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuySection(
                      productId: product['id'] as int,
                      productTitle: product['title'] as String? ?? 'Nama Produk',
                      productPrice: (product['price'] as num).toDouble(),
                      productImage: product['image'] as String?,
                      productDescription: product['description'] as String? ?? 'Deskripsi tidak tersedia',
                      productStock: product['stock'] as int? ?? 0,
                      onProductAdded: () {
                        widget.cartPageKey.currentState?.refreshCart();
                      },
                    ),
                  ),
                );
              },
              child: Container(
                decoration: ShapeDecoration(
                  color: const Color(0xFFECECEC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Image.network(
                        product['image'] ?? AppImages.chair1,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product['title'] ?? 'Nama Produk',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF0C0C0C),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${(product['price'] as num).toStringAsFixed(0)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF0C0C0C),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _currentPageNumber > 1
                  ? () {
                      setState(() {
                        _currentPageNumber--;
                        _fetchRandomProducts();
                      });
                    }
                  : null,
            ),
            Text(
              'Page $_currentPageNumber',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _randomProducts.length == _productsPerPage
                  ? () {
                      setState(() {
                        _currentPageNumber++;
                        _fetchRandomProducts();
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

// Definisikan kelas ini di sini atau di file model terpisah
class ProductItem {
  final String imageUrl;
  final String price;

  const ProductItem({required this.imageUrl, required this.price});
}