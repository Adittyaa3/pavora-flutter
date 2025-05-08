import 'package:flutter/material.dart';
import 'package:projectuasv2/constants/app_assets.dart';
import 'package:projectuasv2/order/buy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar menggunakan MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Daftar produk (contoh data)
    final List<Map<String, dynamic>> products = [
      {
        'name': 'Simple Chair',
        'price': '891K',
        'imageUrl': AppImages.chair1,
      },
      {
        'name': 'Medium Chair',
        'price': '891K',
        'imageUrl': AppImages.chair1,
      },
      {
        'name': 'Simple Chair',
        'price': '891K',
        'imageUrl': AppImages.chair1,
      },
      {
        'name': 'Medium Chair',
        'price': '891K',
        'imageUrl': 'https://placehold.co/149x177',
      },
      {
        'name': 'Simple Chair',
        'price': '891K',
        'imageUrl': 'https://placehold.co/150x150',
      },
      {
        'name': 'Medium Chair',
        'price': '891K',
        'imageUrl': 'https://placehold.co/149x177',
      },
      {
        'name': 'Simple Chair',
        'price': '891K',
        'imageUrl': 'https://placehold.co/150x150',
      },
      {
        'name': 'Medium Chair',
        'price': '891K',
        'imageUrl': 'https://placehold.co/149x177',
      },
      {
        'name': 'Simple Chair',
        'price': '891K',
        'imageUrl': 'https://placehold.co/150x150',
      },
    ];

    // Membagi produk menjadi dua kolom
    List<Map<String, dynamic>> leftColumnProducts = [];
    List<Map<String, dynamic>> rightColumnProducts = [];
    for (int i = 0; i < products.length; i++) {
      if (i % 2 == 0) {
        leftColumnProducts.add(products[i]);
      } else {
        rightColumnProducts.add(products[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Mengatur background AppBar menjadi putih
        elevation: 0, // Menghapus bayangan untuk tampilan lebih bersih
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black, // Mengatur warna ikon menjadi hitam untuk kontras
          ),
          onPressed: () {
            // Aksi untuk tombol back
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Mengatur warna teks menjadi hitam untuk kontras
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          color: Colors.white, // Background putih sesuai desain
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.034, // 3.4% dari lebar layar (sekitar 15px pada 440px)
            vertical: screenHeight * 0.02, // 2% dari tinggi layar
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom Kiri
              Expanded(
                flex: 1,
                child: Column(
                  children: List.generate(leftColumnProducts.length, (index) {
                    final product = leftColumnProducts[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.023), // Jarak antar produk
                      child: ProductCard(
                        name: product['name'],
                        price: product['price'],
                        imageUrl: product['imageUrl'],
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        isLeftColumn: true,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(width: screenWidth * 0.034), // Jarak antar kolom
              // Kolom Kanan
              Expanded(
                flex: 1,
                child: Column(
                  children: List.generate(rightColumnProducts.length, (index) {
                    final product = rightColumnProducts[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.023), // Jarak antar produk
                      child: ProductCard(
                        name: product['name'],
                        price: product['price'],
                        imageUrl: product['imageUrl'],
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

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final double screenWidth;
  final double screenHeight;
  final bool isLeftColumn;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.screenWidth,
    required this.screenHeight,
    required this.isLeftColumn,
  });

  @override
  Widget build(BuildContext context) {
    // Menentukan ukuran berdasarkan kolom (kiri atau kanan)
    final cardWidth = isLeftColumn
        ? screenWidth * 0.48 // 48% dari lebar layar (sekitar 214px pada 440px)
        : screenWidth * 0.4; // 40% dari lebar layar (sekitar 176px pada 440px)
    final cardHeight = isLeftColumn
        ? screenHeight * 0.21 // 21% dari tinggi layar (sekitar 217px pada 1041px)
        : screenHeight * 0.28; // 28% dari tinggi layar (sekitar 295px pada 1041px)
    final imageWidth = isLeftColumn
        ? screenWidth * 0.24 // 24% dari lebar layar (sekitar 105px pada 440px)
        : screenWidth * 0.24; // 24% dari lebar layar (sekitar 105px pada 440px)
    final imageHeight = isLeftColumn
        ? screenHeight * 0.14 // 14% dari tinggi layar (sekitar 150px pada 1041px)
        : screenHeight * 0.17; // 17% dari tinggi layar (sekitar 177px pada 1041px)

    // Menentukan apakah imageUrl adalah URL atau aset lokal
    final isNetworkImage = imageUrl.startsWith('http') || imageUrl.startsWith('https');
    final ImageProvider<Object> imageProvider = isNetworkImage ? NetworkImage(imageUrl) : AssetImage(imageUrl);

    return GestureDetector(
      onTap: () {
        // Navigasi ke CheckoutPage dengan mengirimkan data produk
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuySection(
              // name: name,
              // price: price,
              // imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: ShapeDecoration(
          color: const Color(0xFFECECEC), // Background abu-abu muda sesuai desain
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar Produk
            Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Menangani error saat gambar gagal dimuat
                    print('Error loading image: $exception');
                  },
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // 1% dari tinggi layar
            // Nama Produk
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF0C0C0C),
                fontSize: screenWidth * 0.032, // 3.2% dari lebar layar (sekitar 14px pada 440px)
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: screenHeight * 0.005), // 0.5% dari tinggi layar
            // Harga Produk
            Text(
              price,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF0C0C0C),
                fontSize: screenWidth * 0.045, // 4.5% dari lebar layar (sekitar 20px pada 440px)
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