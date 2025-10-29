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
  Map<int, SessionModel> _sessionsMap = {};
  @override
  void initState() {
    super.initState();
    renderSessions();
  }

  void renderSessions() async {
    final res = await fetchSessions(widget.classModel.classId, _selectedDay!);
    setState(() {
      _sessionsMap = res;
    });
  }

  void handleCreateNewSession() async {
    final res = await createNewSession(widget.classModel.classId);
    if (res == null) {
      showMySnackbar('Something went wrong, couldn\'t create a session.');
    }else{
      showMySnackbar('Session created.');
      handleEditSession(res.sessionId);
    }
  }

  showMySnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void handleDeleteSession(int sessionId) async {
    if (await deleteSession(sessionId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Session deleted successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _sessionsMap.remove(sessionId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong, couldn\' delete the session.'),
        ),
      );
    }
  }

  void handleEditSession(int sessionId) async {
    final sessionRegister = await fetchSessionRegister(sessionId);
    if (sessionRegister == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return MarkAttendancePage(sessionRegister: sessionRegister);
        },
      ),
    );
    if (result != null && result) renderSessions();
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
              // buttons
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        handleCreateNewSession();
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

              // session list
              Text(
                'Sessions for ${DateFormat.MMM().format(_selectedDay!)} ${_selectedDay!.day}, ${_selectedDay!.year}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              _sessionsMap.isEmpty
                  ? Center(
                      child: Text(
                        "No sessions on ${DateFormat.MMM().format(_selectedDay!)} ${_selectedDay!.day}, ${_selectedDay!.year}",
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: _sessionsMap.values.map((e) {
                          return SessionCard(
                            session: e,
                            handleDeleteSession: handleDeleteSession,
                            handleEditSession: handleEditSession,
                          );
                        }).toList(),
                      ),
                    ),
              SizedBox(height: 10),

              // date picker
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
                  lastDate: DateTime(2050), // Define your latest allowable date
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDay = newDate;
                    });
                    renderSessions();
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
