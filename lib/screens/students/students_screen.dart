
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StudentProvider>().loadStudents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلاب'),
        centerTitle: true,
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.students.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.students.isEmpty) {
            return const Center(
              child: Text('لا يوجد طلاب حالياً'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadStudents,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.students.length,
              itemBuilder: (context, index) {
                final student = provider.students[index];

                final name = student['name'] ??
                    student['student_name'] ??
                    student['full_name'] ??
                    'طالب ${index + 1}';

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(name.toString()),
                    subtitle: Text(
                      student.entries
                          .where((entry) =>
                              entry.key != 'name' &&
                              entry.key != 'student_name' &&
                              entry.key != 'full_name')
                          .map((entry) =>
                              '${entry.key}: ${entry.value ?? ''}')
                          .join(' | '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
