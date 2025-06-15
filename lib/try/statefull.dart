import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contoh StatelessWidget (InfoCard)'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Agar kartu mengisi lebar
            children: const <Widget>[
              InfoCard(
                title: 'Selamat Datang!',
                description: 'Ini adalah contoh penggunaan StatelessWidget untuk membuat komponen UI yang dapat digunakan kembali.',
                icon: Icons.info_outline,
                iconColor: Colors.blueAccent,
                backgroundColor: Color(0xFFE3F2FD), // Warna biru muda
              ),
              SizedBox(height: 16),
              InfoCard(
                title: 'Tips Performa',
                description: 'Gunakan StatelessWidget jika UI Anda tidak memerlukan perubahan state internal. Ini baik untuk performa.',
                icon: Icons.lightbulb_outline,
                iconColor: Colors.orangeAccent,
                backgroundColor: Color(0xFFFFF3E0), // Warna oranye muda
              ),
              SizedBox(height: 16),
              InfoCard(
                title: 'Data Statis',
                description: 'Cocok untuk menampilkan data yang tidak berubah setelah widget dimuat.',
                icon: Icons.data_usage,
                iconColor: Colors.greenAccent,
                backgroundColor: Color(0xFFE8F5E9), // Warna hijau muda
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Definisikan StatelessWidget kustom kita
class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  // Konstruktor untuk InfoCard
  // Semua field adalah 'final', dan widget ini 'const'
  const InfoCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = Colors.grey,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // UI untuk InfoCard dibangun di sini.
    // Tampilannya hanya bergantung pada parameter yang diterima dari konstruktor.
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: iconColor, size: 32.0),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                    height: 1.4, // Jarak antar baris teks
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
