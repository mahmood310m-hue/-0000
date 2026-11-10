
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AttendanceProvider>().loadAttendance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحضور والغياب'),
        centerTitle: true,
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.records.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.records.isEmpty) {
            return const Center(
              child: Text('لا توجد سجلات حضور حالياً'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadAttendance,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.records.length,
              itemBuilder: (context, index) {
                final record = provider.records[index];

                final studentName =
                    record['student_name'] ??
                    record['name'] ??
                    'طالب';

                final status =
                    record['status']?.toString() ?? 'غير محدد';

                final date =
                    record['date']?.toString() ?? '';

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(
                      status == 'present'
                          ? Icons.check_circle
                          : status == 'absent'
                              ? Icons.cancel
                              : Icons.event_note,
                      color: status == 'present'
                          ? Colors.green
                          : status == 'absent'
                              ? Colors.red
                              : Colors.orange,
                    ),
                    title: Text(studentName.toString()),
                    subtitle: Text('التاريخ: $date'),
                    trailing: Text(status),
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
