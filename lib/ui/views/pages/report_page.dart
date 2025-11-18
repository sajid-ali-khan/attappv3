import 'package:attappv1/data/models/attendance_report/attendance_report.dart';
import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/ui/viewmodels/connection_provider.dart';
import 'package:attappv1/ui/viewmodels/report_provider.dart';
import 'package:attappv1/ui/views/widgets/attendance_list_widget.dart';
import 'package:attappv1/ui/views/widgets/custom_appbar2.dart';
import 'package:attappv1/ui/views/widgets/no_internet_widget.dart';
import 'package:attappv1/ui/views/widgets/server_unreachable_widget.dart';
import 'package:attappv1/ui/views/widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  final ClassModel classModel;
  final bool consolidated;
  final int? branchCode;
  final int? semester;
  final String? section;

  const ReportPage({
    super.key,
    required this.classModel,
    this.consolidated = false,
    this.branchCode,
    this.semester,
    this.section,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  AttendanceReport? _report;
  AttendanceReport? _currentReport;
  // mutable copy
  bool _below75 = false;
  bool _below65 = false;
  bool _sortByAttendance = false;

  @override
  void initState() {
    super.initState(); // original data on load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reportVm = context.read<ReportProvider>();
      
      if (widget.consolidated) {
        // For consolidated report, use branchCode, semester, and section
        await reportVm.getClassReport(
          branchCode: widget.branchCode!,
          semester: widget.semester!,
          section: widget.section!,
        );
      } else {
        // For individual class report, use courseId
        await reportVm.getReport(courseId: widget.classModel.classId);
      }

      if (!mounted) return;

      if (context.read<ReportProvider>().success) {
        _report = context.read<ReportProvider>().attendanceReport;
        _currentReport = _report;
      } else {
        if (reportVm.errorMessage != null) {
          showMySnackbar(context, reportVm.errorMessage!);
        } else {
          showMySnackbar(context, 'Oops, Something went wrong.');
        }
      }
    });
  }

  void _applyFilters() {
    if (_report == null) return;
    final students = _report!.studentAttendanceMap.values.toList();

    List filtered = students;

    if (_below75) {
      filtered = filtered.where((s) => s.attendancePercentage < 75).toList();
    }

    if (_below65) {
      filtered = filtered.where((s) => s.attendancePercentage < 65).toList();
    }

    if (_sortByAttendance) {
      filtered.sort(
        (a, b) => a.attendancePercentage.compareTo(b.attendancePercentage),
      );
    }

    setState(() {
      if (_report == null) return;
      _currentReport = AttendanceReport(
        className: _report!.className,
        subjectName: _report!.subjectName,
        studentAttendanceMap: {for (var s in filtered) s.roll: s},
      );
    });
  }

  void _showDateFilterDialog() {
    DateTime? tempStartDate = _selectedStartDate;
    DateTime? tempEndDate = _selectedEndDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter by Date Range'),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    initialValue: tempStartDate,
                    decoration: InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                    dateFormat: DateFormat('d MMM yyyy',
                      Localizations.localeOf(context).toString(),
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        tempStartDate = value;
                      });
                    },
                  ),
                  DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    initialValue: tempEndDate,
                    decoration: InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                    dateFormat: DateFormat('d MMM yyyy',
                      Localizations.localeOf(context).toString(),
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        tempEndDate = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedStartDate = null;
                      _selectedEndDate = null;
                    });
                    Navigator.of(context).pop();
                    _refreshData();
                  },
                  child: const Text('Clear Filter'),
                ),
                FilledButton(
                  onPressed: (tempStartDate == null || tempEndDate == null)
                      ? null
                      : () {
                          setState(() {
                            _selectedStartDate = tempStartDate;
                            _selectedEndDate = tempEndDate;
                          });
                          Navigator.of(context).pop();
                          _refreshData();
                        },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _refreshData() async {
    final reportVm = context.read<ReportProvider>();
    
    if (widget.consolidated) {
      // For consolidated report, use date filters if provided
      await reportVm.getClassReport(
        branchCode: widget.branchCode!,
        semester: widget.semester!,
        section: widget.section!,
        startDate: _selectedStartDate,
        endDate: _selectedEndDate,
      );
    } else {
      // For individual class report, use date filters
      await reportVm.getReport(
        courseId: widget.classModel.classId,
        startDate: _selectedStartDate,
        endDate: _selectedEndDate,
      );
    }

    if (reportVm.success) {
      setState(() {
        _currentReport = reportVm.attendanceReport;
        _report = reportVm.attendanceReport;
        _below65 = false;
        _below75 = false;
        _sortByAttendance = false;
      });
    }
  }

Widget buildReportPage(reportVm) {
      return SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      // Date Filter Chip
                      FilterChip(
                        label: Row(
                          spacing: 4,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.date_range, size: 16),
                            Text(
                              _selectedStartDate != null && _selectedEndDate != null
                                  ? '${DateFormat('d MMM').format(_selectedStartDate!)} - ${DateFormat('d MMM').format(_selectedEndDate!)}'
                                  : 'Select Date Range',
                            ),
                          ],
                        ),
                        onSelected: (_) => _showDateFilterDialog(),
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.indigo.shade100,
                        side: BorderSide(
                          color: _selectedStartDate != null && _selectedEndDate != null
                              ? Colors.indigo
                              : Colors.grey.shade300,
                        ),
                      ),
                      // Sort Chip
                      FilterChip(
                        label: Row(
                          spacing: 4,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.sort, size: 16),
                            Text('Sort by Attendance %'),
                          ],
                        ),
                        selected: _sortByAttendance,
                        onSelected: (bool selected) {
                          setState(() {
                            _sortByAttendance = selected;
                            _applyFilters();
                          });
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.indigo.shade100,
                        side: BorderSide(
                          color: _sortByAttendance
                              ? Colors.indigo
                              : Colors.grey.shade300,
                        ),
                      ),
                      FilterChip(
                        label: const Text('Below 75%'),
                        selected: _below75,
                        onSelected: (bool selected) {
                          setState(() {
                            _below75 = selected;
                            _applyFilters();
                          });
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.indigo.shade100,
                        side: BorderSide(
                          color: _below75
                              ? Colors.indigo
                              : Colors.grey.shade300,
                        ),
                      ),
                      FilterChip(
                        label: const Text('Below 65%'),
                        selected: _below65,
                        onSelected: (bool selected) {
                          setState(() {
                            _below65 = selected;
                            _applyFilters();
                          });
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.indigo.shade100,
                        side: BorderSide(
                          color: _below65
                              ? Colors.indigo
                              : Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                  
                  reportVm.isLoading
                      ? const SizedBox(
                          height: 300,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : reportVm.success
                      ? _currentReport == null
                            ? SizedBox(
                                height: 300,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No report available',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Colors.grey.shade600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : AttendanceListWidget(
                                data: _currentReport!.studentAttendanceMap.values
                                    .toList(),
                              )
                      : SizedBox(
                          height: 300,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Couldn\'t fetch the report',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.red.shade600,
                                      ),
                                ),
                              ],
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
    final reportVm = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar2(
        title: 'Attendance Report',
        subTitle: _currentReport == null? 'Loading...'
            : widget.consolidated? '${_currentReport!.className} - Total Attendance'
            : '${widget.classModel.className} - ${widget.classModel.subjectDisplayName}',
      ),
      body: Consumer<ConnectionProvider>(
        builder: (context, connection, child) {
          if (!connection.connectedToInternet) {
            return const NoInternetWidget();
          }
          if (!connection.connectedToServer){
            return const ServerUnreachableWidget();
          }
          return buildReportPage(reportVm);
        },
      ),
    );
  }
}
