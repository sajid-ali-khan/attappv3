import 'package:attappv1/data/services/api/faculty_service.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';
import 'package:attappv1/data/services/token_service.dart';
import 'package:attappv1/ui/viewmodels/classes_provider.dart';
import 'package:attappv1/ui/views/pages/class_selection_page.dart';
import 'package:attappv1/ui/views/pages/login_page.dart';
import 'package:attappv1/ui/views/widgets/class_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String facultyName = '';
  final _tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    fetchFacultyName();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassesProvider>().getClasses();
    });
  }

  void fetchFacultyName() async {
    String? fname =
        await getSharedPrefs("facultyName") ?? await getFacultyName();
    if (fname == null) return;
    setState(() => facultyName = fname);
  }

  void _handleLogout() async {
    await _tokenService.deleteToken();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final classes = context.watch<ClassesProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Attendance Management',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: Icon(Icons.logout, color: Colors.grey.shade700),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Consolidated Report Card
            Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClassSelectionPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      spacing: 12,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.assessment,
                            color: Colors.indigo.shade700,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                'Consolidated Report',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'View attendance by branch/semester/section',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // My Classes Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text(
                  'My Classes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Welcome back, $facultyName',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            Expanded(
              child: classes.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : classes.success
                      ? ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: classes.classes.length,
                          itemBuilder: (context, index) {
                            return ClassCard(
                              assignedClass: classes.classes[index],
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No classes assigned to you',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
