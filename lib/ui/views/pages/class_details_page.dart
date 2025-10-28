import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/data/services/api/session_service.dart';
import 'package:attappv1/ui/views/pages/mark_attendance_page.dart';
import 'package:attappv1/ui/views/pages/report_page.dart';
import 'package:attappv1/ui/views/widgets/session_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassDetailsPage extends StatefulWidget {
  const ClassDetailsPage({super.key, required this.classModel});

  final ClassModel classModel;
  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  DateTime? _selectedDay = DateTime.now();
  List<SessionModel> _sessions = [];

  @override
  void initState() {
    super.initState();
    renderSessions();
  }

  void renderSessions() async {
    final sessions = await fetchSessions(
      widget.classModel.classId,
      _selectedDay!,
    );
    setState(() {
      _sessions = sessions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.classModel.subjectName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              // create a new session by calling the api
                              SessionModel sessionModel = SessionModel(
                                sessionId: 0,
                                sessionName: "Untitled",
                                updatedAt: DateTime.now(),
                              );
                              return MarkAttendancePage(session: sessionModel);
                            },
                          ),
                        );
                      },
                      label: Text('New Session'),
                      icon: Icon(Icons.add),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ReportPage();
                            },
                          ),
                        );
                      },
                      label: Text('Report'),
                      icon: Icon(Icons.analytics_outlined),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Sessions for ${DateFormat.MMM().format(_selectedDay!)} ${_selectedDay!.day}, ${_selectedDay!.year}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              SingleChildScrollView(
                child: Column(
                  children: _sessions.map((e) {
                    return SessionCard(session: e);
                  }).toList(),
                ),
              ),
              SizedBox(height: 10),
              Text('Select a Date', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDay,
                  firstDate: DateTime(
                    2000,
                  ), // Define your earliest allowable date
                  lastDate: DateTime(
                    2050,
                  ), // Define your latest allowable date
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDay = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
