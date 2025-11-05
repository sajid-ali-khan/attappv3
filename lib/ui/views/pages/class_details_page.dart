import 'package:attappv1/data/models/class_model/class_model.dart';
// ignore: unused_import
import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/data/services/api/attendance_report_service.dart';
import 'package:attappv1/ui/viewmodels/session_provider.dart';
import 'package:attappv1/ui/views/pages/mark_attendance_page.dart';
import 'package:attappv1/ui/views/pages/report_page.dart';
import 'package:attappv1/ui/views/widgets/custom_appbar2.dart';
import 'package:attappv1/ui/views/widgets/session_card.dart';
import 'package:attappv1/ui/views/widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClassDetailsPage extends StatefulWidget {
  const ClassDetailsPage({super.key, required this.classModel});

  final ClassModel classModel;
  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  DateTime _selectedDay = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().getSessionsByDate(
        widget.classModel.classId,
        _selectedDay,
      );
    });
  }

  Future<void> _handleCreateSession() async {
    final sessionVm = context.read<SessionProvider>();
    if (sessionVm.isCreating) return;
    await sessionVm.createSession(widget.classModel.classId);

    if (!mounted) return;

    if (!sessionVm.created) {
      showMySnackbar(context, sessionVm.errorMessage);
      return;
    }
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MarkAttendancePage(sessionRegister: sessionVm.sessionRegister);
        },
      ),
    );
    await sessionVm.getSessionsByDate(widget.classModel.classId, _selectedDay);
  }

  Future<void> _handleDeleteSession(int sessionId) async {
    if (!context.mounted) return;
    await context.read<SessionProvider>().deleteSessionById(sessionId);
  }

  Future<void> _handleEditSession(int sessionId) async {
    final sessionVm = context.read<SessionProvider>();

    await sessionVm.fetchSessionRegister(sessionId);

    if (!mounted) return;

    if (sessionVm.fetched) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MarkAttendancePage(
              sessionRegister: sessionVm.sessionRegister,
            );
          },
        ),
      );
    } else {
      if (!mounted) return;
      showMySnackbar(context, sessionVm.errorMessage);
    }

    if (!mounted) return;

    await context.read<SessionProvider>().getSessionsByDate(
      widget.classModel.classId,
      _selectedDay,
    );
  }

  void getAttendanceReport() async {
    try {
      final attendanceReport = await fetchFullAttendanceReport(
        widget.classModel.classId,
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ReportPage(
              attendanceReport: attendanceReport,
              classModel: widget.classModel,
            );
          },
        ),
      );
    } catch (e) {
      showMySnackbar(context, "Couldn't fetch attendance report");
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionVm = context.watch<SessionProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar2(
        title: widget.classModel.className,
        subTitle: widget.classModel.subjectName,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // buttons
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _handleCreateSession,
                      label: sessionVm.isCreating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('New Session'),
                      icon: sessionVm.isCreating
                          ? const SizedBox()
                          : const Icon(Icons.add),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        getAttendanceReport();
                      },
                      label: Text('Report'),
                      icon: Icon(Icons.analytics_outlined),
                    ),
                  ),
                ],
              ),

              // session list
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    'Sessions for ${DateFormat.MMM().format(_selectedDay)} ${_selectedDay.day}, ${_selectedDay.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                  sessionVm.isLoading
                      ? Center(child: const CircularProgressIndicator())
                      : sessionVm.loaded
                      ? sessionVm.sessions.isEmpty
                            ? Center(
                                child: Text(
                                  "No sessions on ${DateFormat.MMM().format(_selectedDay)} ${_selectedDay.day}, ${_selectedDay.year}",
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: sessionVm.sessions.map((e) {
                                    return SessionCard(
                                      session: e,
                                      handleDeleteSession: _handleDeleteSession,
                                      handleEditSession: _handleEditSession,
                                    );
                                  }).toList(),
                                ),
                              )
                      : Center(
                          child: Text(
                            "No sessions on ${DateFormat.MMM().format(_selectedDay)} ${_selectedDay.day}, ${_selectedDay.year}",
                          ),
                        ),
                ],
              ),

              // date picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text('Select a Date', style: TextStyle(fontSize: 16)),
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
                      lastDate: DateTime(
                        2050,
                      ), // Define your latest allowable date
                      onDateChanged: (DateTime newDate) {
                        setState(() {
                          _selectedDay = newDate;
                        });
                        sessionVm.getSessionsByDate(
                          widget.classModel.classId,
                          _selectedDay,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
