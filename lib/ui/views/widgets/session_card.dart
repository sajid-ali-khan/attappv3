import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/ui/views/pages/mark_attendance_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});

  final SessionModel session;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: Colors.deepPurple[50],
          splashColor: Colors.deepPurple[50],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MarkAttendancePage(session: session);
                },
              ),
            );
          },
          title: Text(session.sessionName),
          leading: Text(DateFormat.jm().format(session.updatedAt)),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
