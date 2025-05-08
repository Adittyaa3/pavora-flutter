import 'package:flutter/material.dart';
import 'package:projectuasv2/constants/app_assets.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            // Item pesanan (bisa diulang untuk beberapa pesanan)
            _buildOrderItem(),
            const SizedBox(height: 16),
            _buildOrderItem(), // Contoh: menambahkan item kedua

          ],
        ),
      ),
    );
  }

  // Widget untuk item pesanan
  Widget _buildOrderItem() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Gambar Produk
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 19),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFECECEC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Container(
            width: 44,
            height: 52,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(AppImages.orderImage), // Gunakan gambar dari AppImages
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 11), // Jarak antar elemen
        // Informasi Pesanan
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            spacing: 192, // Jarak horizontal antar elemen
            runSpacing: 0, // Jarak vertikal antar baris
            children: [
              Text(
                'Medium Chair',
                style: AppTextStyles.orderProductName, // Gunakan gaya teks dari AppTextStyles
              ),
              Text(
                '1 Item',
                style: AppTextStyles.orderItemCount, // Gunakan gaya teks dari AppTextStyles
              ),
              Text(
                '999K',
                style: AppTextStyles.orderPrice, // Gunakan gaya teks dari AppTextStyles
              ),
              Text(
                '16 Maret 2025, 20.00 PM',
                style: AppTextStyles.orderDate, // Gunakan gaya teks dari AppTextStyles
              ),
            ],
          ),
        ),
      ],
    );
  }
}