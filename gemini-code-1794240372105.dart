import 'package:flutter/material.dart';
import 'assignments_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _networkName = 'غير معروف';
  Color _networkColor = Colors.grey;

  void _detectNetwork(String value) {
    if (value.startsWith('077')) {
      setState(() {
        _networkName = 'آسيا سيل (Asiacell)';
        _networkColor = Colors.orange;
      });
    } else if (value.startsWith('078') || value.startsWith('079')) {
      setState(() {
        _networkName = 'زين العراق (Zain)';
        _networkColor = Colors.blue;
      });
    } else if (value.startsWith('075')) {
      setState(() {
        _networkName = 'كورك تيليكوم (Korek)';
        _networkColor = Colors.amber.shade800;
      });
    } else {
      setState(() {
        _networkName = 'أدخل رقماً صحيحاً (077/078/079/075)';
        _networkColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تسجيل دخول - مدرسة كوثر الأهلية'),
          backgroundColor: const Color(0xFF4A6B5B),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'مرحباً بك في بوابة مدرسة كوثر الأهلية',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E35),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: _detectNetwork,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف (مثل: 077xxxxxxxx)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'الشبكة المكتشفة: $_networkName',
                style: TextStyle(color: _networkColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6B5B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AssignmentsScreen()),
                  );
                },
                child: const Text('إرسال رمز التحقق', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}