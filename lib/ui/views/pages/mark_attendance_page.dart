import 'package:attappv1/data/models/session_register/session_register.dart';
import 'package:attappv1/ui/viewmodels/session_provider.dart';
import 'package:attappv1/ui/views/widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarkAttendancePage extends StatefulWidget {
  const MarkAttendancePage({super.key, required this.sessionRegister});
  final SessionRegister sessionRegister;
  @override
  State<MarkAttendancePage> createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  final _sessionNameController = TextEditingController();
  void markAllPresent() {
    for (var key in widget.sessionRegister.attendanceRowMap.keys) {
      widget.sessionRegister.attendanceRowMap[key]?.status = true;
    }
  }

  void markAllAbsent() {
    for (var key in widget.sessionRegister.attendanceRowMap.keys) {
      widget.sessionRegister.attendanceRowMap[key]?.status = false;
    }
  }

  void _handleSessionUpdate() async {
    final sessionVm = context.read<SessionProvider>();

    await sessionVm.updateSessionRegister(widget.sessionRegister);

    if (!mounted) return;

    if (sessionVm.updated) {
      showMySnackbar(context, 'Session saved successfully');
      Navigator.pop(context);
    } else {
      showMySnackbar(context, sessionVm.errorMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _sessionNameController.text = widget.sessionRegister.sessionName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        actions: [
          Text(
            DateFormat.yMMMd(
              'en_US',
            ).add_jm().format(widget.sessionRegister.updatedAt),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _sessionNameController,
              onChanged: (value) => setState(() {
                widget.sessionRegister.sessionName = _sessionNameController.text
                    .trim();
              }),
              decoration: InputDecoration(
                label: Text('Session name'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Present'),
                Text(
                  '${widget.sessionRegister.presentCount}/${widget.sessionRegister.totalCount}',
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value:
                  widget.sessionRegister.presentCount /
                  widget.sessionRegister.totalCount,
              minHeight: 6,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        markAllPresent();
                        widget.sessionRegister.presentCount =
                            widget.sessionRegister.totalCount;
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
                        widget.sessionRegister.presentCount = 0;
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
                  children: widget.sessionRegister.attendanceRowMap.values.map((
                    e,
                  ) {
                    return Column(
                      children: [
                        SwitchListTile(
                          value: e.status,
                          onChanged: (bool val) {
                            setState(() {
                              e.status = val;
                              if (val) {
                                widget.sessionRegister.presentCount += 1;
                              } else {
                                widget.sessionRegister.presentCount -= 1;
                              }
                            });
                          },
                          title: Text(e.name),
                          subtitle: Text(e.roll),
                        ),
                        Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 10),
            FilledButton(
              onPressed: context.watch<SessionProvider>().isUpdating
                  ? null
                  : _handleSessionUpdate,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: context.watch<SessionProvider>().isUpdating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
