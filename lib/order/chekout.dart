import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkout Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CheckoutPage(),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar menggunakan MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi untuk tombol back
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          color: Colors.white, // Background putih sesuai desain
          padding: EdgeInsets.only(
            left: screenWidth * 0.035, // 3.5% dari lebar layar (sekitar 14px pada 440px)
            top: screenHeight * 0.09, // 9% dari tinggi layar (sekitar 86px pada 956px)
            right: screenWidth * 0.035, // 3.5% dari lebar layar
            bottom: screenHeight * 0.02, // 2% dari tinggi layar
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bagian Gambar dan Harga
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.48, // 48% dari lebar layar (sekitar 212px pada 440px)
                    height: screenHeight * 0.17, // 17% dari tinggi layar (sekitar 162px pada 956px)
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFECECEC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: screenWidth * 0.07, // 7% dari lebar layar (sekitar 31px pada 440px)
                          top: screenHeight * 0.006, // 0.6% dari tinggi layar (sekitar 6px pada 956px)
                          child: Container(
                            width: screenWidth * 0.34, // 34% dari lebar layar (sekitar 150px pada 440px)
                            height: screenHeight * 0.157, // 15.7% dari tinggi layar (sekitar 150px pada 956px)
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("https://placehold.co/150x150"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.07), // 7% dari lebar layar (sekitar 31px pada 440px)
                  SizedBox(
                    width: screenWidth * 0.33, // 33% dari lebar layar (sekitar 145px pada 440px)
                    child: Text(
                      '891k',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF0C0C0C),
                        fontSize: screenWidth * 0.11, // 11% dari lebar layar (sekitar 48px pada 440px)
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.026), // 2.6% dari tinggi layar (sekitar 25px pada 956px)
              // Bagian Deskripsi Produk
              Container(
                width: screenWidth * 0.9, // 90% dari lebar layar (sekitar 397px pada 440px)
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Medium Chair',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.055, // 5.5% dari lebar layar (sekitar 24px pada 440px)
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003), // 0.3% dari tinggi layar (sekitar 3px pada 956px)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
                        style: TextStyle(
                          color: const Color(0xFF9B9B9B),
                          fontSize: screenWidth * 0.034, // 3.4% dari lebar layar (sekitar 15px pada 440px)
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400,
                          height: 1.64,
                        ),
                        softWrap: true, // Memastikan teks membungkus
                        overflow: TextOverflow.ellipsis, // Menangani overflow teks
                        maxLines: 3, // Batasi jumlah baris
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003), // 0.3% dari tinggi layar (sekitar 3px pada 956px)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.055, // 5.5% dari lebar layar (sekitar 24px pada 440px)
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003), // 0.3% dari tinggi layar (sekitar 3px pada 956px)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Simple Chair',
                        style: TextStyle(
                          color: const Color(0xFF9B9B9B),
                          fontSize: screenWidth * 0.036, // 3.6% dari lebar layar (sekitar 16px pada 440px)
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400,
                          height: 1.64,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.026), // 2.6% dari tinggi layar (sekitar 25px pada 956px)
              // Placeholder untuk metode pembayaran atau detail lainnya
              Container(
                width: double.infinity,
                height: screenHeight * 0.28, // 28% dari tinggi layar (sekitar 266px pada 956px)
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFECECEC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Payment Method Placeholder',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.026), // 2.6% dari tinggi layar (sekitar 25px pada 956px)
              // Kebijakan
              Container(
                width: screenWidth * 0.75, // 75% dari lebar layar (sekitar 329px pada 440px)
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Kebijakan Kami',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.034, // 3.4% dari lebar layar (sekitar 15px pada 440px)
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.009), // 0.9% dari tinggi layar (sekitar 9px pada 956px)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'kamu tidak dapat melakukan pembatalan dan perubahan apapun pada pesanan setelah melakukan pembayaran',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.027, // 2.7% dari lebar layar (sekitar 12px pada 440px)
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        softWrap: true, // Memastikan teks membungkus
                        overflow: TextOverflow.ellipsis, // Menangani overflow teks
                        maxLines: 3, // Batasi jumlah baris
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.026), // 2.6% dari tinggi layar (sekitar 25px pada 956px)
              // Tombol Pay Now
              SizedBox(
                width: screenWidth * 0.86, // 86% dari lebar layar (sekitar 379px pada 440px)
                height: screenHeight * 0.065, // 6.5% dari tinggi layar (sekitar 62px pada 956px)
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi untuk tombol Pay Now
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF205781),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Pay Now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.073, // 7.3% dari lebar layar (sekitar 32px pada 440px)
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // 2% dari tinggi layar
            ],
          ),
        ),
      ),
    );
  }
}