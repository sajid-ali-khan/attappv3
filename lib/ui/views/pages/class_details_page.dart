import 'package:attappv1/data/constants.dart';
import 'package:attappv1/ui/views/pages/mark_attendance_page.dart';
import 'package:attappv1/ui/views/pages/report_page.dart';
import 'package:attappv1/ui/views/widgets/session_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassDetailsPage extends StatefulWidget {
  const ClassDetailsPage({super.key, required this.subjectName});

  final String subjectName;

  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  DateTime? _selectedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subjectName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                            return MarkAttendancePage(
                              attendanceList: Constants.attendanceList,
                            );
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
            Column(
              children: Constants.sessions.map((e) {
                return SessionCard(session: e);
              }).toList(),
            ),

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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
