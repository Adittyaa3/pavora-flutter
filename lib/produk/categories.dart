import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectuasv2/core/constants/app_assets.dart';
import 'package:projectuasv2/order/product.dart';

/// Halaman untuk menampilkan daftar kategori produk.
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Map<String, dynamic>> _categories = []; // Daftar kategori dari Supabase
  bool _isLoading = true; // Status loading saat mengambil data

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  /// Mengambil data kategori dari Supabase.
  Future<void> _fetchCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('categories')
          .select('id, name')
          .order('name', ascending: true);

      print('Categories fetched: $response'); // Debugging

      setState(() {
        _categories = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF205781),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 44),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _categories.isEmpty
                  ? const Center(child: Text('No categories available'))
                  : Column(
                children: _buildCategoryRows(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Membangun baris kategori secara dinamis dalam bentuk grid dua kolom.
  List<Widget> _buildCategoryRows() {
    List<Widget> rows = [];
    for (int i = 0; i < _categories.length; i += 2) {
      final category1 = _categories[i];
      final category2 = i + 1 < _categories.length ? _categories[i + 1] : null;
      rows.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCategoryItem(context, category1['name'], category1['id']),
            if (category2 != null) const SizedBox(width: 13),
            if (category2 != null) _buildCategoryItem(context, category2['name'], category2['id']),
          ],
        ),
      );
      if (i + 2 < _categories.length) rows.add(const SizedBox(height: 23));
    }
    return rows;
  }

  /// Membangun widget untuk setiap item kategori.
  Widget _buildCategoryItem(BuildContext context, String category, int categoryId) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(categoryId: categoryId, categoryName: category),
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