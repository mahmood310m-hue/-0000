
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/grade_provider.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GradeProvider>().loadGrades();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('درجات الطلاب'),
        centerTitle: true,
      ),
      body: Consumer<GradeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.grades.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.grades.isEmpty) {
            return const Center(
              child: Text('لا توجد درجات حالياً'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadGrades,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.grades.length,
              itemBuilder: (context, index) {
                final grade = provider.grades[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.grade),
                    title: Text(
                      (grade['student_name'] ??
                              grade['name'] ??
                              'طالب')
                          .toString(),
                    ),
                    subtitle: Text(
                      'الدرجة: ${grade['grade'] ?? grade['score'] ?? 'غير محددة'}',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
