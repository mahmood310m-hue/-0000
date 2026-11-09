import 'package:flutter/material.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final List> _assignments = [
    {'title': 'حل تمارين قواعد اللغة العربية', 'subject': 'اللغة العربية', 'done': false},
    {'title': 'تمرينات الفصل الثاني في الرياضيات', 'subject': 'الرياضيات', 'done': true},
    {'title': 'قراءة الدرس الثالث في اللغة الإنجليزية', 'subject': 'اللغة الإنجليزية', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الواجبات المدرسية اليومية'),
          backgroundColor: const Color(0xFF4A6B5B),
          foregroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: _assignments.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final item = _assignments[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('المادة: ${item['subject']}'),
                trailing: Checkbox(
                  activeColor: const Color(0xFF4A6B5B),
                  value: item['done'],
                  onChanged: (bool? value) {
                    setState(() {
                      _assignments[index]['done'] = value ?? false;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}