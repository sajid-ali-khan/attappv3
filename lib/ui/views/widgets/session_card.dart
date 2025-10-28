import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/data/services/api/session_service.dart';
import 'package:attappv1/ui/views/pages/mark_attendance_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionCard extends StatefulWidget {
  const SessionCard({super.key, required this.session, required this.handleDeleteSession});

  final SessionModel session;
  final dynamic handleDeleteSession;

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  void _editSession(int sessionId) async {
    final sessionRegister = await fetchSessionRegister(sessionId);
    if (sessionRegister == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return MarkAttendancePage(sessionRegister: sessionRegister);
        },
      ),
    );
  }

  void _deleteSession(int sessionId) async {
    await widget.handleDeleteSession(sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: Colors.deepPurple[50],
          splashColor: Colors.deepPurple[100],
          onTap: () {
            // Quick action: edit
            _editSession(widget.session.sessionId);
          },
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          onLongPress: () async {
            // Long press: confirm delete
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Session'),
                content: Text(
                  'Are you sure you want to delete "${widget.session.sessionName}"?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Delete',
                    ),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              _deleteSession(widget.session.sessionId);
            }
          },
          title: Text(widget.session.sessionName),
          leading: Text(DateFormat.jm().format(widget.session.updatedAt)),
        ),

        SizedBox(height: 10),
      ],
    );
  }
}
