import 'package:attappv1/data/models/session_register/session_register.dart';
import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/ui/viewmodels/connection_provider.dart';
import 'package:attappv1/ui/viewmodels/session_provider.dart';
import 'package:attappv1/ui/views/widgets/custom_appbar2.dart';
import 'package:attappv1/ui/views/widgets/no_internet_widget.dart';
import 'package:attappv1/ui/views/widgets/server_unreachable_widget.dart';
import 'package:attappv1/ui/views/widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarkAttendancePage extends StatefulWidget {
  const MarkAttendancePage({
    super.key,
    required this.sessionRegister,
    required this.classModel,
  });
  final SessionRegister sessionRegister;
  final ClassModel classModel;
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

    // If session name is empty, set it to 'Untitled'
    if (widget.sessionRegister.sessionName.isEmpty) {
      widget.sessionRegister.sessionName = 'Untitled';
    }

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
    _sessionNameController.text = widget.sessionRegister.sessionName;
  }

  @override
  void dispose() {
    _sessionNameController.dispose();
    super.dispose();
  }

  Widget buildMarkAttendancePage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        children: [
          // Session Name Input with Creation Time
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          'Session Name',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                              ),
                        ),
                        TextField(
                          controller: _sessionNameController,
                          onChanged: (value) => setState(() {
                            widget.sessionRegister.sessionName =
                                _sessionNameController.text.trim();
                          }),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(8),
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 4,
                    children: [
                      Text(
                        'Created',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        '${DateFormat('hh:mm a').format(widget.sessionRegister.createdAtLocal)}, ${DateFormat('MMM dd').format(widget.sessionRegister.createdAtLocal)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Attendance Summary Card
          Material(
            borderRadius: BorderRadius.circular(12),
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attendance',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${widget.sessionRegister.presentCount}/${widget.sessionRegister.totalCount}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value:
                          widget.sessionRegister.presentCount /
                          widget.sessionRegister.totalCount,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.indigo,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Action Buttons
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      markAllPresent();
                      widget.sessionRegister.presentCount =
                          widget.sessionRegister.totalCount;
                    });
                  },
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('All Present'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      markAllAbsent();
                      widget.sessionRegister.presentCount = 0;
                    });
                  },
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text('All Absent'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ],
          ),

          // Attendance List
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: widget.sessionRegister.attendanceRowMap.values.map((
                  e,
                ) {
                  return Material(
                    borderRadius: BorderRadius.circular(8),
                    elevation: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: SwitchListTile(
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
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          e.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          e.roll,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                        activeThumbColor: Colors.indigo,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Save Button
          FilledButton.icon(
            onPressed: context.watch<SessionProvider>().isUpdating
                ? null
                : _handleSessionUpdate,
            icon: context.watch<SessionProvider>().isUpdating
                ? const SizedBox()
                : const Icon(Icons.save, color: Colors.white),
            label: context.watch<SessionProvider>().isUpdating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Save Session',
                    style: TextStyle(color: Colors.white),
                  ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar2(
        title: widget.classModel.className,
        subTitle: widget.classModel.subjectDisplayName,
      ),
      body: Consumer<ConnectionProvider>(
        builder: (context, connection, child) {
          if (!connection.connectedToInternet) {
            return const NoInternetWidget();
          }
          if (!connection.connectedToServer) {
            return const ServerUnreachableWidget();
          }
          return buildMarkAttendancePage();
        },
      ),
    );
  }
}
