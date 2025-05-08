import 'package:flutter/material.dart';
import 'package:projectuasv2/constants/app_assets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buy Section',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(), // Halaman utama
    );
  }
}

// Halaman sebelumnya (HomePage)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman BuySection
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BuySection()),
            );
          },
          child: const Text('Go to Buy Section'),
        ),
      ),
    );
  }
}

class BuySection extends StatefulWidget {
  const BuySection({super.key});

  @override
  _BuySectionState createState() => _BuySectionState();
}

class _BuySectionState extends State<BuySection> {
  int quantity = 1; // State untuk kuantitas

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          color: const Color(0xFFD0DAE2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian atas dengan tombol back dan favorite
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 30),
                      onPressed: () {
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, size: 30),
                      onPressed: () {
                        // Aksi untuk tombol favorite
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to favorites!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Gambar produk (carousel)
              Container(
                width: screenWidth,
                height: 378,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildProductCard(
                      imageUrl: AppImages.chair1,
                      width: 267,
                      height: 317,
                      leftPadding: 74,
                      rightPadding: 0,
                    ),
                    _buildProductCard(
                      imageUrl: AppImages.chair1,
                      width: 267,
                      height: 317,
                      leftPadding: 74,
                      rightPadding: 0,
                    ),
                    _buildProductCard(
                      imageUrl: AppImages.chair1,
                      width: 267,
                      height: 317,
                      leftPadding: 74,
                      rightPadding: 104,
                    ),
                  ],
                ),
              ),
              // Container terpisah untuk deskripsi produk dengan background putih
              Container(
                width: screenWidth,
                color: Colors.white, // Background putih
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medium Chair',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
                      style: TextStyle(
                        color: Color(0xFF9B9B9B),
                        fontSize: 16,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400,
                        height: 1.64,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Simple Chair',
                      style: TextStyle(
                        color: Color(0xFF9B9B9B),
                        fontSize: 16,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400,
                        height: 1.64,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tombol increment dan decrement untuk kuantitas dengan desain baru
                    Container(
                      width: 120,
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFF205781),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Tombol Decrement
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                    color: Color(0xFF3E4462),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Angka Kuantitas
                          SizedBox(
                            width: 8,
                            child: Text(
                              '$quantity',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF3E4462),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.67,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ),
                          // Tombol Increment
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF205781),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tombol Add to Cart
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi untuk tombol Add to Cart
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added $quantity item(s) to cart!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF205781),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Add To Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildProductCard({
    required String imageUrl,
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
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}