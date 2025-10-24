import 'package:attappv1/data/models/attendance_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarkAttendancePage extends StatefulWidget {
  const MarkAttendancePage({super.key, required this.attendanceList});
  final List<AttendanceRow> attendanceList;
  @override
  State<MarkAttendancePage> createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  int _presentCount = 0;
  void markAllPresent() {
    for (var s in widget.attendanceList) {
      s.present = true;
    }
  }

  void markAllAbsent() {
    for (var s in widget.attendanceList) {
      s.present = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance'), actions: [
        Text(DateFormat.yMMMd('en_US').add_jm().format(DateTime.now()))
      ],),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Present'),
                Text('$_presentCount/${widget.attendanceList.length}'),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: _presentCount / widget.attendanceList.length,
              minHeight: 6,
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        markAllPresent();
                        _presentCount = widget.attendanceList.length;
                      });
                    },
                    child: Text('Mark All Present'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        markAllAbsent();
                        _presentCount = 0;
                      });
                    },
                    child: Text('Mark All Absent'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: widget.attendanceList.map((e) {
                    return Column(
                      children: [
                        SwitchListTile(
                          value: e.present,
                          onChanged: (bool val) {
                            setState(() {
                              e.present = val;
                              if (val) {
                                _presentCount += 1;
                              } else {
                                _presentCount -= 1;
                              }
                            });
                          },
                          title: Text(e.student.name),
                          subtitle: Text(e.student.roll),
                        ),
                        Divider()
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
