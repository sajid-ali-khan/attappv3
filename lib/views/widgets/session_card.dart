import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/session.dart';
import 'package:attappv1/views/pages/mark_attendance_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});
  
  final Session session;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MarkAttendancePage(studentList: Constants.students);
            },));
          },
          title: Text('Session ${session.sessionNo}'),
          leading: Text(DateFormat.jm().format(session.markedAt)),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        SizedBox(height: 16,)
      ],
    );
  }
}
