
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/announcement_provider.dart';
import '../../config/theme.dart';

class NewsTicker extends StatefulWidget {
  const NewsTicker({super.key});

  @override
  State<NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends State<NewsTicker> {
  final ScrollController _scrollController = ScrollController();
  bool _isPaused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted || _isPaused || !_scrollController.hasClients) return;

      final position = _scrollController.position;
      if (position.maxScrollExtent <= 0) return;

      if (_scrollController.offset >= position.maxScrollExtent) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(
          (_scrollController.offset + 2).clamp(
            0.0,
            position.maxScrollExtent,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnnouncementProvider>();
    final news = provider.announcements;

    if (news.isEmpty) {
      return const SizedBox.shrink();
    }

    final newsText = news
        .map((item) => item['title']?.toString() ?? '')
        .where((title) => title.isNotEmpty)
        .join('   •   ');

    if (newsText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Icon(
              Icons.campaign,
              color: Colors.white,
              size: 20,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _isPaused = !_isPaused);
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    newsText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              setState(() => _isPaused = !_isPaused);
            },
          ),
        ],
      ),
    );
  }
}
