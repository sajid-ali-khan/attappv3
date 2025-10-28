import 'dart:developer';

import 'package:attappv1/data/services/api/faculty_service.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';
import 'package:attappv1/data/services/token_service.dart';
import 'package:attappv1/ui/views/pages/login_page.dart';
import 'package:attappv1/ui/views/widgets/class_card.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String facultyName = '';
  List<dynamic> classes = [];
  @override
  void initState() {
    super.initState();
    fetchFacultyName();
    fetchFacultyClasses();
  }

  void fetchFacultyClasses() async {
    final kclasses = await getFacultyClasses();
    setState((){
      classes = kclasses;
    });
  }

  void fetchFacultyName() async {
    String? fname = await getSharedPrefs("facultyName");
    if (fname == null) {
      fname = await getFacultyName();
      if (fname == null) return;
    }
    log('Obtained faculty name: $fname');
    setState(() {
      facultyName = fname!;
    });
  }
  final _tokenService = TokenService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await _tokenService.deleteToken();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,'),
            Text(facultyName, style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text(
              'Your Classes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            Column(
              children: classes.map((e) {
                return ClassCard(assignedClass: e);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
