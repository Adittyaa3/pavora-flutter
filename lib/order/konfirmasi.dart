import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// -------------------------------------------------------------------
// KELAS WIDGET KONFIRMASI PEMBAYARAN (PaymentConfirmationWidget)
// -------------------------------------------------------------------
class PaymentConfirmationWidget extends StatelessWidget {
  final String orderId;
  final String totalAmount;
  final String paymentMethod;

  const PaymentConfirmationWidget({
    Key? key,
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menggunakan AlertDialog agar lebih pas sebagai pop-up konfirmasi sederhana
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white, // Untuk Flutter 3+, agar background tetap putih
      contentPadding: EdgeInsets.zero, // Kita atur padding di Column
      content: Container( // Bungkus dengan container untuk shadow jika diperlukan (AlertDialog sudah punya)
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration( // Dekorasi ini mungkin redundant jika AlertDialog sudah di-style
          shape: BoxShape.rectangle,
          color: Colors.white, // Pastikan warna background konsisten
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Agar dialog tidak memenuhi layar
          children: <Widget>[
            Icon(
              Icons.check_circle_outline_rounded, // Ganti dengan ikon custom jika ada
              color: Colors.green, // Sesuaikan warna
              size: 70.0, // Ukuran ikon disesuaikan sedikit
            ),
            SizedBox(height: 20.0),
            Text(
              "Pembayaran Berhasil!",
              style: TextStyle(
                fontSize: 20.0, // Sedikit disesuaikan
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Warna teks lebih jelas
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              "Cihuhuy! Pembayaran Anda telah berhasil. Berikut detail pesanan Anda:",
              style: TextStyle(fontSize: 15.0, color: Colors.black54), // Warna teks lebih lembut
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            _buildDetailRow("No. Pesanan:", "#$orderId"),
            _buildDetailRow("Total Bayar:", "Rp $totalAmount"),
            _buildDetailRow("Metode Bayar:", paymentMethod),
            SizedBox(height: 28.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A90E2), // Warna biru dari tombol "Add to Cart" di desainmu
                foregroundColor: Colors.white, // Warna teks tombol
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12), // Padding disesuaikan
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), // Font weight disesuaikan
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Sesuaikan dengan desainmu
                ),
                minimumSize: Size(double.infinity, 48), // Tombol full width di dalam dialog
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                // Arahkan ke halaman beranda atau detail pesanan
                // Contoh: if (Navigator.canPop(context)) Navigator.pop(context); // Kembali ke halaman sebelumnya jika ada
                // Atau Navigator.pushReplacementNamed(context, '/home_screen'); // Jika ada routing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Kembali ke Beranda (Simulasi)")),
                );
              },
              child: Text("Kembali ke Beranda"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0), // Sedikit padding vertikal
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// KELAS APLIKASI UTAMA (MyApp)
// -------------------------------------------------------------------
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contoh Konfirmasi Pembayaran',
      theme: ThemeData(
          primarySwatch: Colors.blue, // Warna dasar, bisa diganti
          // Tema global agar mirip desain (opsional, bisa di-override per widget)
          scaffoldBackgroundColor: Color(0xFFF4F4F8), // Latar belakang umum seperti desain
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white, // Latar belakang AppBar putih
            elevation: 0.5, // Sedikit shadow untuk AppBar
            iconTheme: IconThemeData(color: Colors.black54), // Ikon AppBar (misal tombol back)
            titleTextStyle: TextStyle(
              color: Colors.black87, // Warna judul AppBar
              fontSize: 18,
              fontWeight: FontWeight.w600, // Font weight judul AppBar
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2), // Warna biru dari tombol "Add to Cart"
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          dialogTheme: DialogTheme( // Styling default untuk semua dialog
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          )
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
    );
  }
}

// -------------------------------------------------------------------
// KELAS HALAMAN UTAMA (HomePage)
// -------------------------------------------------------------------
class HomePage extends StatelessWidget {
  // Fungsi untuk menampilkan dialog
  void _showConfirmationDialog(BuildContext context) {
    String orderId = "ORD789"; // Contoh data
    String totalAmount = "891.000"; // Sesuai harga di desainmu
    String paymentMethod = "Transfer Bank"; // Contoh data

    showDialog(
      context: context,
      barrierDismissible: false, // Pengguna harus berinteraksi dengan dialog
      builder: (BuildContext context) {
        return PaymentConfirmationWidget(
          orderId: orderId,
          totalAmount: totalAmount,
          paymentMethod: paymentMethod,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil referensi dari desain "add to card" untuk tombol "Pay Now"
    // Mari kita buat halaman yang sedikit menyerupai layar "add to card" (bagian bawahnya)
    // untuk menempatkan tombol pemicu dialog.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( // Tombol back seperti di desain
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            // Aksi jika tombol back ditekan (misal: Navigator.pop(context))
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Tombol Back Ditekan!")),
            );
          },
        ),
        title: Text('Keranjang Saya'), // Contoh judul
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Mendorong tombol ke bawah
          children: <Widget>[
            // Bagian atas bisa diisi dengan daftar item keranjang (tidak diimplementasikan di sini)
            Expanded(
              child: Center(
                child: Text(
                  "Isi keranjang belanja Anda akan tampil di sini.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Bagian bawah yang mirip dengan ringkasan dan tombol "Pay Now"
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, -2), // Shadow ke atas
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Harga:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      Text(
                        "Rp 891.000", // Harga dari desain
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton( // Tombol ini akan memicu dialog
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4A90E2), // Warna biru dari tombol "Pay Now"
                      minimumSize: Size(double.infinity, 50), // Agar tombol full-width
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                    child: Text('Lanjutkan Pembayaran'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}