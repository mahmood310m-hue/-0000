import 'package:flutter/material.dart';

void main() {
  runApp(const KawtarSchoolApp());
}

class KawtarSchoolApp extends StatelessWidget {
  const KawtarSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مدرسة كوثر الأهلية المختلطة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F8F6), // أوف وايت
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6B5B), // أخضر حكيمي رئيسي
          primary: const Color(0xFF4A6B5B),
          secondary: const Color(0xFF8C6D53), // بني جوزي
        ),
      ),
      home: const LoginScreen(),
    );
  }
}