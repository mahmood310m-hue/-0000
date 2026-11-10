
import 'package:flutter/material.dart';

class TopStudentsScreen extends StatelessWidget {
  const TopStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلاب المتفوقون'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'لا يوجد طلاب متفوقون حالياً',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
