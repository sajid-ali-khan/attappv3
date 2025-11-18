import 'package:attappv1/data/services/token_service.dart';
import 'package:attappv1/ui/viewmodels/classes_provider.dart';
import 'package:attappv1/ui/viewmodels/connection_provider.dart';
import 'package:attappv1/ui/viewmodels/faculty_provider.dart';
import 'package:attappv1/ui/views/pages/change_password_page.dart';
import 'package:attappv1/ui/views/pages/class_selection_page.dart';
import 'package:attappv1/ui/views/pages/login_page.dart';
import 'package:attappv1/ui/views/widgets/class_card.dart';
import 'package:attappv1/ui/views/widgets/server_unreachable_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacultyProvider>().getFacultyName('');
      context.read<ClassesProvider>().getClasses();
    });
  }

  void _handleLogout() async {
    await _tokenService.deleteToken();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _handleChangePassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
    );
  }

  Widget buildDashboard(ClassesProvider classVm) {
    return Padding(
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
                        child: const Icon(
                          Icons.assessment,
                          color: Color(0xFF4C3FBB),
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
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'View attendance by branch/semester/section',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF999999),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // My Classes Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                'My Classes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Welcome back, ${context.watch<FacultyProvider>().facultyName}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),

          Expanded(
            child: classVm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : classVm.success
                ? ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: classVm.classes.length,
                    itemBuilder: (context, index) {
                      return ClassCard(assignedClass: classVm.classes[index]);
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: Color(0xFFCCCCCC),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No classes assigned to you',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final classVm = context.watch<ClassesProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Attendance Management',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'change_password',
                child: Text(
                  'Change Password',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.logout, color: Colors.grey.shade700),
                    Text(
                      'Logout',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout();
              } else if (value == 'change_password') {
                _handleChangePassword();
              }
            },
          ),
        ],
      ),
      body: Consumer<ConnectionProvider>(
        builder:
            (
              BuildContext context,
              ConnectionProvider connection,
              Widget? child,
            ) {
              if (!connection.connectedToServer) {
                return const ServerUnreachableWidget();
              }
              return buildDashboard(classVm);
            },
      ),
    );
  }
}
