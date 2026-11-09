import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/announcement_provider.dart';
import '../../providers/settings_provider.dart';
import '../../config/theme.dart';
import '../../widgets/digital_clock.dart';
import '../../widgets/news_ticker.dart';
import '../../widgets/stat_card.dart';
import '../admin/admin_login_screen.dart';
import '../students/students_screen.dart';
import '../top_students/top_students_screen.dart';
import '../grades/grades_screen.dart';
import '../attendance/attendance_screen.dart';
import '../announcements/announcements_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomePage(),
    const TopStudentsScreen(),
    const GradesScreen(),
    const AttendanceScreen(),
    const AnnouncementsScreen(),
    const AdminLoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: 'المتفوقون',
          ),
          NavigationDestination(
            icon: Icon(Icons.grade_outlined),
            selectedIcon: Icon(Icons.grade),
            label: 'الدرجات',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'الحضور',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'الإعلانات',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'الإدارة',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مدرسة كوثر الأهلية المختلطة'),
        actions: [
          // الساعة الإلكترونية
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: DigitalClock(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            studentProvider.loadStudents(),
            announcementProvider.loadAnnouncements(),
            settingsProvider.loadSettings(),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // الشريط الإخباري
            const NewsTicker(),
            const SizedBox(height: 16),
            
            // البطاقة الترحيبية
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مدرسة كوثر: بيت العلم والإبداع',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'مرحباً بكم في مدرسة كوثر',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'بيئة تعليمية آمنة ومحفزة، نؤمن أن لكل طالب موهبة تستحق الرعاية.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // بطاقات الإحصائيات
            const Text(
              'إحصائيات المدرسة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                StatCard(
                  title: 'الطلبة',
                  value: studentProvider.students.length.toString(),
                  icon: Icons.people,
                  color: AppTheme.primaryColor,
                ),
                StatCard(
                  title: 'المتفوقون',
                  value: studentProvider.topStudents.length.toString(),
                  icon: Icons.star,
                  color: Colors.amber,
                ),
                StatCard(
                  title: 'العام الدراسي',
                  value: settingsProvider.schoolYear,
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                ),
                StatCard(
                  title: 'الإعلانات',
                  value: announcementProvider.announcements.length.toString(),
                  icon: Icons.campaign,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // معلومات المستخدم
            if (authProvider.currentUser != null) ...[
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      authProvider.currentUser!.fullName.isNotEmpty
                          ? authProvider.currentUser!.fullName[0]
                          : '؟',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(authProvider.currentUser!.fullName),
                  subtitle: Text(authProvider.currentUser!.role),
                  trailing: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await authProvider.logout();
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
