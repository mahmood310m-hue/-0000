
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/announcement_provider.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() =>
      _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AnnouncementProvider>().loadAnnouncements();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعلانات المدرسة'),
        centerTitle: true,
      ),
      body: Consumer<AnnouncementProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading &&
              provider.announcements.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.announcements.isEmpty) {
            return const Center(
              child: Text('لا توجد إعلانات حالياً'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadAnnouncements,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.announcements.length,
              itemBuilder: (context, index) {
                final announcement =
                    provider.announcements[index];

                final title =
                    announcement['title']?.toString() ??
                    'إعلان جديد';

                final content =
                    announcement['content']?.toString() ??
                    announcement['description']?.toString() ??
                    '';

                final date =
                    announcement['created_at']?.toString() ?? '';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.campaign,
                              color: Colors.teal,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                            ),
                          ],
                        ),
                        if (content.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(content),
                        ],
                        if (date.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            date,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall,
                          ),
                        ],
                      ],
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
