import 'package:attappv1/data/models/class_model/class_model.dart';
// ignore: unused_import
import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/ui/viewmodels/connection_provider.dart';
import 'package:attappv1/ui/viewmodels/report_provider.dart';
import 'package:attappv1/ui/viewmodels/session_provider.dart';
import 'package:attappv1/ui/views/pages/mark_attendance_page.dart';
import 'package:attappv1/ui/views/pages/report_page.dart';
import 'package:attappv1/ui/views/widgets/custom_appbar2.dart';
import 'package:attappv1/ui/views/widgets/server_unreachable_widget.dart';
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
          return MarkAttendancePage(
            sessionRegister: sessionVm.sessionRegister,
            classModel: widget.classModel,
          );
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
              classModel: widget.classModel,
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

  void _getAttendanceReport() async {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ReportPage(classModel: widget.classModel);
        },
      ),
    );
  }

  Widget buildClassDetailsPage(
    SessionProvider sessionVm,
    ReportProvider reportVm,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action Buttons
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _handleCreateSession,
                    label: sessionVm.isCreating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('New Session'),
                    icon: sessionVm.isCreating
                        ? const SizedBox()
                        : const Icon(Icons.add),
                    style: FilledButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: reportVm.isLoading ? null : _getAttendanceReport,
                    label: reportVm.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('View Report'),
                    icon: reportVm.isLoading
                        ? const SizedBox()
                        : const Icon(Icons.analytics_outlined),
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

            // Sessions Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Sessions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${DateFormat.MMM().format(_selectedDay)} ${_selectedDay.day}, ${_selectedDay.year}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                sessionVm.isLoading
                    ? const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : sessionVm.loaded
                    ? sessionVm.sessions.isEmpty
                          ? SizedBox(
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.inbox_outlined,
                                      size: 48,
                                      color: Color(0xFFCCCCCC),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "No sessions on ${DateFormat.MMM().format(_selectedDay)} ${_selectedDay.day}, ${_selectedDay.year}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: sessionVm.sessions.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                return SessionCard(
                                  session: sessionVm.sessions[index],
                                  handleDeleteSession: _handleDeleteSession,
                                  handleEditSession: _handleEditSession,
                                );
                              },
                            )
                    : SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: Color(0xFFCCCCCC),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No sessions on ${DateFormat.MMM().format(_selectedDay)} ${_selectedDay.day}, ${_selectedDay.year}",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),

            // Date Picker Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Choose Date',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Pick a date to view sessions',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CalendarDatePicker(
                      initialDate: _selectedDay,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionVm = context.watch<SessionProvider>();
    final reportVm = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar2(
        title: widget.classModel.className,
        subTitle: widget.classModel.subjectDisplayName,
      ),
      body: Consumer<ConnectionProvider>(
        builder: (context, connection, child) {
          if (!connection.connectedToServer) {
            return const ServerUnreachableWidget();
          }
          return buildClassDetailsPage(sessionVm, reportVm);
        },
      ),
    );
  }
}
