import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Hapus import yang tidak terpakai untuk merapikan kode
// import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:projectuasv2/auth/register.dart';
import 'package:projectuasv2/page/home.dart';
// import 'package:projectuasv2/page/payment.dart';
import 'package:projectuasv2/page/history.dart';
import 'package:intl/date_symbol_data_local.dart';
// Hapus import intl.dart karena sudah di-export oleh date_symbol_data_local
// import 'package:intl/intl.dart'; 

void main() async {
  // digunakan bauat mastiin semua binding siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();
  
  // Baris ini WAJIB ada untuk memuat data locale Indonesia
  await initializeDateFormatting('id_ID', null);

  // Lanjutkan dengan inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://gtrhazdlhswidutdeoae.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd0cmhhemRsaHN3aWR1dGRlb2FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDczNjgxMzksImV4cCI6MjA2Mjk0NDEzOX0.W5QEQoalD39u5DCMwS9ISajjS6BJMvMbfeAmYLu4JOk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: AuthWrapper(),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}

// Widget untuk menentukan halaman awal berdasarkan status autentikasi
class AuthWrapper extends StatelessWidget {
  // Tambahkan const constructor agar lebih efisien
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Cek apakah pengguna sudah login
    final user = Supabase.instance.client.auth.currentUser;
    // Jika pengguna sudah login, arahkan ke HomeScreen
    if (user != null) {
      return const HomePage();
    }
    // Jika belum login, arahkan ke RegisterScreen (halaman awal baru)
    return const RegisterScreen();
  }
}