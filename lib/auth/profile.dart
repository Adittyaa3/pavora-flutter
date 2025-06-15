import 'dart:io'; // Diperlukan jika kamu menggunakan image_picker untuk file
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:image_picker/image_picker.dart'; // Uncomment jika ingin implementasi image picker

// Model sederhana untuk data pengguna, bisa disesuaikan dengan model lengkapmu
class UserProfile {
  final String userId;
  String fullName;
  String? phoneNumber;
  String? address;
  String? profilePictureUrl; // URL gambar yang sudah ada
  // File? newProfileImage; // File gambar baru yang dipilih pengguna (opsional, tergantung implementasi)

  UserProfile({
    required this.userId,
    required this.fullName,
    this.phoneNumber,
    this.address,
    this.profilePictureUrl,
    // this.newProfileImage,
  });
}

class ProfileUpdateScreen extends StatefulWidget {
  final UserProfile initialProfile; // Data profil awal pengguna

  const ProfileUpdateScreen({super.key, required this.initialProfile});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  File? _selectedImageFile; // Untuk menyimpan file gambar yang baru dipilih
  String? _currentProfileImageUrl;
  bool _isLoading = false; // State untuk loading indicator

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.initialProfile.fullName);
    _phoneController = TextEditingController(text: widget.initialProfile.phoneNumber);
    _addressController = TextEditingController(text: widget.initialProfile.address);
    _currentProfileImageUrl = widget.initialProfile.profilePictureUrl;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Implementasi image picker di sini
    // Contoh menggunakan package image_picker:
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   setState(() {
    //     _selectedImageFile = File(image.path);
    //     _currentProfileImageUrl = null; // Hapus URL lama jika gambar baru dipilih
    //   });
    // }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fungsi pilih gambar belum diimplementasikan.')),
    );
  }

  Future<void> _submitProfileUpdate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Panggil onSaved pada TextFormField jika ada

      setState(() {
        _isLoading = true;
      });

      try {
        // Data yang akan dikirim ke backend/database
        final Map<String, dynamic> updatedProfileData = {
          'nama_lengkap': _fullNameController.text,
          'number_phone': _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
          'address': _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
          'updated_at': DateTime.now().toIso8601String(), // Perbarui timestamp
        };

        // Logika untuk upload gambar akan ditambahkan nanti
        // if (_selectedImageFile != null) {
        //   // Upload _selectedImageFile dan dapatkan URL baru
        //   // updatedProfileData['profile_picture'] = newImageUrl;
        // }

        final response = await Supabase.instance.client
            .from('detail_users')
            .update(updatedProfileData)
            .eq('user_id', widget.initialProfile.userId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui!')),
          );
          Navigator.pop(context, true); // Kirim 'true' untuk menandakan ada perubahan
        }

      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui profil: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profil'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF2F2F2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _selectedImageFile != null
                          ? FileImage(_selectedImageFile!)
                          : (_currentProfileImageUrl != null && _currentProfileImageUrl!.isNotEmpty
                              ? NetworkImage(_currentProfileImageUrl!)
                              : null) as ImageProvider?,
                      child: (_selectedImageFile == null && (_currentProfileImageUrl == null || _currentProfileImageUrl!.isEmpty))
                          ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                          : null,
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                        radius: 20,
                        backgroundColor:Color(0xFF205781),

                        child: Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama lengkap tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon (Opsional)',
                  border: OutlineInputBorder(
                     borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                
                  ),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat (Opsional)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitProfileUpdate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color(0xFF205781),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0,)) : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
