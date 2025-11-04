import 'package:attappv1/data/services/api/faculty_service.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';
import 'package:attappv1/data/services/token_service.dart';
import 'package:attappv1/ui/viewmodels/classes_provider.dart';
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
        title: Text('Attendance Management'),
        actions: [
          IconButton(onPressed: _handleLogout, icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Classes', style: const TextStyle(fontSize: 20)),
            Text(
              'Welcome back, $facultyName',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: classes.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : classes.success
                  ? ListView.builder(
                      itemCount: classes.classes.length,
                      itemBuilder: (context, index) {
                        return ClassCard(assignedClass: classes.classes[index]);
                      },
                    )
                  : const Center(child: Text('No classes assigned to you')),
            ),
          ],
        ),
      ),
    );
  }
}
