import 'package:flutter/material.dart';
import 'package:projectuasv2/constants/app_assets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Profil Pengguna
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: ShapeDecoration(
                color: const Color(0xFF205781),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Foto Profil
                  Container(
                    width: 94,
                    height: 94,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: -3,
                          top: -3,
                          child: Container(
                            width: 101,
                            height: 101,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(AppImages.profileImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 21),
                  // Nama dan Email
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STEVEN',
                          style: AppTextStyles.profileName,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Steven@gmail.com',
                          style: AppTextStyles.profileEmail,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            // Daftar Menu
            _buildMenuItem('Alamat tersimpan'),
            const SizedBox(height: 7),
            _buildMenuItem('Alamat tersimpan'),
            const SizedBox(height: 7),
            _buildMenuItem('Pembayaran'),
            const SizedBox(height: 7),
            _buildMenuItem('Pengaturan'),
            const SizedBox(height: 7),
            _buildMenuItem('Panduan Layanan'),
            const SizedBox(height: 7),
            _buildMenuItem('Kebijakan privasi'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget untuk item menu
  Widget _buildMenuItem(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      decoration: ShapeDecoration(
        color: const Color(0xFF205781),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: AppTextStyles.menuItem,
            ),
          ),
        ],
      ),
    );
  }
}