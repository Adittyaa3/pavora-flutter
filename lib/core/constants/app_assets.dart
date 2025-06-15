  import 'package:flutter/material.dart';

  // Kelas untuk menyimpan path gambar
  class AppImages {
    static const String chair1 = 'assets/images/kursi1.png';

    static const String placeholderProduk = 'assets/images/kursi1.png';
  // Tambahkan path gambar lain jika diperlukan
  // static const String chair2 = 'assets/images/kursi2.png';
    static const String profileImage = 'assets/images/profile.png'; // Gambar profil
    static const String orderImage = 'assets/images/kursi1.png'; // Gambar untuk pesanan
    static const String categoris = 'assets/images/categories.png'; // Gambar untuk pesanan
    static const String pay = 'assets/images/pay.png'; // Gambar untuk pesanan
  }

  // Kelas untuk menyimpan gaya teks
  class AppTextStyles {
    // Gaya teks untuk harga di carousel
    static const TextStyle priceText = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );

    // Gaya teks untuk search bar (teks utama)
    static const TextStyle searchText = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );

    // Gaya teks untuk hint di search bar
    static const TextStyle searchHintText = TextStyle(
      color: Colors.white70,
      fontSize: 20,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );

  // Tambahkan gaya teks lain jika diperlukan
  // Gaya teks untuk nama pengguna
    static const TextStyle profileName = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    );

    // Gaya teks untuk email
    static const TextStyle profileEmail = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    );

    // Gaya teks untuk item menu
    static const TextStyle menuItem = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    );

    // Gaya teks untuk nama produk di OrdersPage
    static const TextStyle orderProductName = TextStyle(
      color: Color(0xFF205781),
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    );

    // Gaya teks untuk jumlah item di OrdersPage
    static const TextStyle orderItemCount = TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    );

    // Gaya teks untuk harga di OrdersPage
    static const TextStyle orderPrice = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    );

    // Gaya teks untuk tanggal di OrdersPage
    static const TextStyle orderDate = TextStyle(
      color: Color(0xFF9E9E9C),
      fontSize: 12,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    );


    // Gaya teks untuk judul "Categories"
    static const TextStyle categoryTitle = TextStyle(
      color: Colors.black,
      fontSize: 36,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );

    // Gaya teks untuk item kategori
    static const TextStyle categoryItem = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );
  }