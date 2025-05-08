import 'package:flutter/material.dart';
import 'package:projectuasv2/constants/app_assets.dart';
import 'package:projectuasv2/order/product.dart';

void main() {
  runApp(const MaterialApp(
    home: CategoriesPage(),
    debugShowCheckedModeBanner: false,
  ));
}
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Categories',
                textAlign: TextAlign.center,
                style: AppTextStyles.categoryTitle,
              ),
              const SizedBox(height: 44),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildCategoryItem(context, 'Table'),
                      const SizedBox(width: 13),
                      _buildCategoryItem(context, 'Chair'),
                    ],
                  ),
                  const SizedBox(height: 23),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildCategoryItem(context, 'Kitchen'),
                      const SizedBox(width: 13),
                      _buildCategoryItem(context, 'Computer'),
                    ],
                  ),
                  const SizedBox(height: 23),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildCategoryItem(context, 'Work'),
                      const SizedBox(width: 13),
                      _buildCategoryItem(context, 'Garage'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(),
            ),
          );
        },
        child: Container(
          height: 75,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFF205781),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Center(
            child: Text(
              category,
              style: AppTextStyles.categoryItem,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryProductsPage extends StatelessWidget {
  final String category;

  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk - $category'),
      ),
      body: Center(
        child: Text('Daftar produk untuk kategori $category'),
      ),
    );
  }
}