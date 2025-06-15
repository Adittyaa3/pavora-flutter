import 'dart:io'; // Import ini mungkin diperlukan jika AppImages.profileImage adalah File
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectuasv2/core/constants/app_assets.dart';
// Import halaman update profil
import 'package:projectuasv2/auth/profile.dart'; // Sesuaikan path jika berbeda

// Asumsi AppTextStyles ada di file terpisah
class AppTextStyles {
  static const TextStyle profileName =
      TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle profileEmail =
      TextStyle(color: Colors.white70, fontSize: 14);
  static const TextStyle menuItem =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;
  String? _userEmail;
  String? _profileImageUrl;
  String? _userPhoneNumber;
  String? _userAddress;
  bool _isLoading = true; // Tambahkan state loading

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    // Pastikan widget masih ada sebelum update state
    if (!mounted) return;

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('detail_users')
            .select('nama_lengkap, profile_picture, number_phone, address')
            .eq('user_id', user.id)
            .single();

        if (mounted) {
          setState(() {
            _userName = response['nama_lengkap'];
            _userEmail = user.email ?? 'No email';
            _profileImageUrl = response['profile_picture']; // Bisa null
            _userPhoneNumber = response['number_phone'];
            _userAddress = response['address'];
            _isLoading = false; // Loading selesai
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false; // Loading selesai meskipun tidak ada user
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false; // Loading selesai karena ada error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/register');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  void _navigateToUpdateProfile() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && _userName != null) {
      final currentUserProfile = UserProfile(
        userId: user.id,
        fullName: _userName!,
        phoneNumber: _userPhoneNumber,
        address: _userAddress,
        profilePictureUrl: _profileImageUrl,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfileUpdateScreen(initialProfile: currentUserProfile),
        ),
      ).then((_) =>
          _fetchUserData()); // Refresh data setelah kembali dari halaman update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Data pengguna belum lengkap untuk update profil.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ================== PERBAIKAN UTAMA DI SINI ==================
    // Tentukan ImageProvider yang akan digunakan secara dinamis
    final ImageProvider imageProvider;
    // Cek jika URL gambar ada dan tidak kosong
    if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      // Jika ada, gunakan NetworkImage
      imageProvider = NetworkImage(_profileImageUrl!);
    } else {
      // Jika tidak ada, gunakan gambar aset default
      imageProvider = const AssetImage(AppImages.profileImage);
    }
    // =============================================================

    return SafeArea(
      
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 47, // 94 / 2
                    backgroundColor: Colors.white,
                    // Gunakan imageProvider yang sudah ditentukan di atas
                    backgroundImage: imageProvider,
                    // Tambahkan child untuk menampilkan indicator saat loading
                    child:
                        _isLoading ? const CircularProgressIndicator() : null,
                  ),
                  const SizedBox(width: 21),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLoading
                              ? 'Loading...'
                              : (_userName ?? 'Nama Tidak Ada'),
                          style: AppTextStyles.profileName,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isLoading
                              ? 'Loading...'
                              : (_userEmail ?? 'Email Tidak Ada'),
                          style: AppTextStyles.profileEmail,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            _buildMenuItem('Profil Lengkap', onTap: _navigateToUpdateProfile),
            const SizedBox(height: 7),
            _buildMenuItem('Pembayaran', onTap: () {}),
            const SizedBox(height: 7),
            _buildMenuItem('Pengaturan', onTap: () {}),
            const SizedBox(height: 7),
            _buildMenuItem('Panduan Layanan', onTap: () {}),
            const SizedBox(height: 7),
            _buildMenLogout('Logout', onTap: _logout),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        decoration: ShapeDecoration(
          color: const Color(0xFF205781),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: AppTextStyles.menuItem,
        ),
      ),
    );
  }
}

Widget _buildMenLogout(String title, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      decoration: ShapeDecoration(
        color: const Color.fromARGB(255, 174, 11, 11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: AppTextStyles.menuItem,
      ),
    ),
  );
}
