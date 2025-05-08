import 'package:flutter/material.dart';
import 'package:projectuasv2/auth/login.dart';


void main() {
  runApp(const MaterialApp(
    home: RegisterScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerificationController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPasswordVerificationVisible = false;

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _passwordVerificationError;

  void _validateAndRegister() {
    setState(() {
      _fullNameError = null;
      _emailError = null;
      _passwordError = null;
      _passwordVerificationError = null;

      // Validasi full name
      if (_fullNameController.text.isEmpty) {
        _fullNameError = 'Full name cannot be empty';
      }

      // Validasi email
      if (_emailController.text.isEmpty) {
        _emailError = 'Email cannot be empty';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
        _emailError = 'Please enter a valid email';
      }

      // Validasi password
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password cannot be empty';
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      }

      // Validasi password verification
      if (_passwordVerificationController.text.isEmpty) {
        _passwordVerificationError = 'Password verification cannot be empty';
      } else if (_passwordVerificationController.text != _passwordController.text) {
        _passwordVerificationError = 'Passwords do not match';
      }

      // Jika tidak ada error, lanjutkan proses registrasi
      if (_fullNameError == null &&
          _emailError == null &&
          _passwordError == null &&
          _passwordVerificationError == null) {
        // Lakukan proses registrasi (misalnya, panggil API)
        print('Full Name: ${_fullNameController.text}');
        print('Email: ${_emailController.text}');
        print('Password: ${_passwordController.text}');
        // Contoh: Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordVerificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil lebar dan tinggi layar menggunakan MediaQuery
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome Section with Logo
                Container(
                  width: screenWidth * 0.6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Welcome',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF205781),
                          fontSize: 28,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Image.asset(
                        'assets/images/logo.png',
                        width: screenWidth * 0.6,
                        height: screenWidth * 0.4,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Form Section
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Input Fields with Custom Icons
                    _buildTextField(
                      'Full Name',
                      'assets/images/user.png',
                      screenWidth,
                      controller: _fullNameController,
                      errorText: _fullNameError,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTextField(
                      'Email',
                      'assets/images/iconlogin.png',
                      screenWidth,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTextField(
                      'Password',
                      'assets/images/lock.png',
                      screenWidth,
                      controller: _passwordController,
                      isPassword: true,
                      isVisible: _isPasswordVisible,
                      onVisibilityChanged: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      errorText: _passwordError,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTextField(
                      'Password Verification',
                      'assets/images/lock.png',
                      screenWidth,
                      controller: _passwordVerificationController,
                      isPassword: true,
                      isVisible: _isPasswordVerificationVisible,
                      onVisibilityChanged: () {
                        setState(() {
                          _isPasswordVerificationVisible = !_isPasswordVerificationVisible;
                        });
                      },
                      errorText: _passwordVerificationError,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        onPressed: _validateAndRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF205781),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Or Sign Up With
                    const Text(
                      'or Sign up with',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Google Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF205781)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google.png',
                              width: screenWidth * 0.05,
                              height: screenWidth * 0.05,
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            const Text(
                              'SIGN UP WITH GOOGLE',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Login Link
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Color(0xFF205781),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                // Footer
                SizedBox(height: screenHeight * 0.02),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'By clicking sign up you are agreeing to the\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: 'Terms of use',
                        style: TextStyle(
                          color: Color(0xFF205781),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: ' and the ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: 'privacy policy',
                        style: TextStyle(
                          color: Color(0xFF205781),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String iconPath,
      double screenWidth, {
        TextEditingController? controller,
        TextInputType? keyboardType,
        bool isPassword = false,
        bool isVisible = false,
        VoidCallback? onVisibilityChanged,
        String? errorText,
      }) {
    return Container(
      width: double.infinity,
      height: screenWidth * 0.12,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF205781)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: screenWidth * 0.05,
            height: screenWidth * 0.05,
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: isPassword && !isVisible,
              decoration: InputDecoration(
                hintText: label,
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                suffixIcon: isPassword
                    ? IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF205781),
                  ),
                  onPressed: onVisibilityChanged,
                )
                    : null,
                errorText: errorText,
                errorStyle: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}