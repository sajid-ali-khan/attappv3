import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/ui/viewmodels/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionCard extends StatefulWidget {
  const SessionCard({
    super.key,
    required this.session,
    required this.handleDeleteSession,
    required this.handleEditSession,
  });

  final SessionModel session;
  final Future<void> Function(int) handleDeleteSession;
  final Future<void> Function(int) handleEditSession;

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  void _editSession(int sessionId) async {
    await widget.handleEditSession(sessionId);
  }

  void _deleteSession(int sessionId) async {
    await widget.handleDeleteSession(sessionId);
  }

  @override
  Widget build(BuildContext context) {
    final sessionVm = context.watch<SessionProvider>();
    final isLoading =
        sessionVm.isFetching &&
        sessionVm.fetchingSessionRegisterId == widget.session.sessionId;

    return Card(
      color: Colors.indigo.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isLoading
            ? null
            : () {
                _editSession(widget.session.sessionId);
              },
        onLongPress: () async {
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
                  child: const Text('Delete'),
                ),
              ],
            ),
          );

          if (confirm == true) {
            _deleteSession(widget.session.sessionId);
          }
        },
        child: ListTile(
          trailing: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.arrow_forward_ios),
          title: Text(widget.session.sessionName),
          leading: Text(widget.session.updatedAtLocal),
        ),
      ),
    );
  }
}
