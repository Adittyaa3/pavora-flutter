// lib/page/main.dart
import 'package:flutter/material.dart';
import 'package:projectuasv2/navigation_bar.dart';
import 'package:projectuasv2/page/card.dart';
import 'package:projectuasv2/page/keranjang.dart';
import 'package:projectuasv2/page/profile.dart';
import 'package:projectuasv2/constants/app_assets.dart';
import 'package:projectuasv2/produk/categories.dart';
import 'package:projectuasv2/order/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<ProductItem> _products = const [
    ProductItem(imageUrl: AppImages.chair1, price: "999k"),
    ProductItem(imageUrl: AppImages.chair1, price: "1.2M"),
    ProductItem(imageUrl: AppImages.chair1, price: "1.5M"),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _HomeContent(),
          CartPage(),
          OrdersPage(),
          ProfilePage(),
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
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<ProductItem> _products = const [
    ProductItem(imageUrl: AppImages.chair1, price: "999k"),
    ProductItem(imageUrl: AppImages.chair1, price: "1.2M"),
    ProductItem(imageUrl: AppImages.chair1, price: "1.5M"),
  ];

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 10),
              ],
            ),
          ),
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
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(_products[index]);
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _products.length,
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

  Widget _buildProductCard(ProductItem product) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 280,
              height: 280,
              child: _isLocalAsset(product.imageUrl)
                  ? Image.asset(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Error loading image'));
                },
              )
                  : Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Error loading image'));
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
                    borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
              child: Text(
                product.price,
                style: AppTextStyles.priceText,
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
              child: const Icon(Icons.favorite_border, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Search Bar
          Container(
            width: 288,
            height: 78, // Kurangi tinggi agar lebih sesuai dengan gambar
            decoration: const ShapeDecoration(
              color: Color(0xFF205781),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)), // Border radius lebih kecil
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 12), // Padding kiri untuk ikon
                const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8), // Jarak antara ikon dan TextField lebih kecil
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: AppTextStyles.searchText,
                    decoration: InputDecoration(
                      hintText: 'Search Item',
                      hintStyle: AppTextStyles.searchHintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0), // Atur padding vertikal
                    ),
                    onChanged: (value) {
                      print("Pencarian: $value");
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 11),
          // Tombol Kategori
          GestureDetector(
            onTap: () {
              print("Tombol kategori diklik!");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesPage()),
              );
            },
            child: Container(
              width: 78, // Ukuran persegi
              height: 78,
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                color: Color(0xFF205781),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)), // Border radius lebih kecil
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.categoris, // Ganti dengan path gambar kustommu
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  color: Colors.white, // Opsional: jika gambar perlu diwarnai
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isLocalAsset(String path) {
    return path.startsWith('assets/') || path.startsWith('images/');
  }
}

class ProductItem {
  final String imageUrl;
  final String price;

  const ProductItem({required this.imageUrl, required this.price});
}