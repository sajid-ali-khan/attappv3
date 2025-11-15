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

    return Material(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              spacing: 12,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: Colors.indigo.shade700,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        widget.session.sessionName,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.session.updatedAtLocal,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
