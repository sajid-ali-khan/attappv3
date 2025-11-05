import 'package:attappv1/data/models/attendance_report/attendance_report.dart';
import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/ui/viewmodels/report_provider.dart';
import 'package:attappv1/ui/views/widgets/attendance_list_widget.dart';
import 'package:attappv1/ui/views/widgets/custom_appbar2.dart';
import 'package:attappv1/ui/views/widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  final ClassModel classModel;

  const ReportPage({super.key, required this.classModel});

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
      await reportVm.getReport(courseId: widget.classModel.classId);

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

  Future<void> _refreshData() async {
    final reportVm = context.read<ReportProvider>();
    await reportVm.getReport(
      courseId: widget.classModel.classId,
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
    );

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

  @override
  Widget build(BuildContext context) {
    final reportVm = context.watch<ReportProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar2(
        title: 'Attendance Report',
        subTitle:
            '${widget.classModel.className} - ${widget.classModel.subjectName}',
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 12,
              children: [
                Row(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: DateTimeFormField(
                        mode: DateTimeFieldPickerMode.date,
                        decoration: const InputDecoration(labelText: 'From'),
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                        onChanged: (value) => setState(() {
                          _selectedStartDate = value;
                        }),
                      ),
                    ),
                    Expanded(
                      child: DateTimeFormField(
                        mode: DateTimeFieldPickerMode.date,
                        decoration: const InputDecoration(labelText: 'To'),
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                        onChanged: (value) => setState(() {
                          _selectedEndDate = value;
                        }),
                      ),
                    ),
                  ],
                ),

                // Refresh button
                OutlinedButton.icon(
                  onPressed:
                      (reportVm.isLoading ||
                          _selectedStartDate == null ||
                          _selectedEndDate == null)
                      ? null
                      : _refreshData,
                  label: reportVm.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2,),
                        )
                      : Text('Apply'),
                  icon: reportVm.isLoading
                      ? const SizedBox()
                      : Icon(Icons.refresh),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 42),
                  ),
                ),
              ],
            ),

            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                // Sort Chip
                InputChip(
                  backgroundColor: Colors.indigo.shade50,
                  label: Row(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.sort, size: 16), Text('Sort by %')],
                  ),
                  selected: _sortByAttendance,
                  onSelected: (bool selected) {
                    setState(() {
                      _sortByAttendance = selected;
                      _applyFilters();
                    });
                  },
                ),

                FilterChip(
                  backgroundColor: Colors.indigo.shade50,
                  label: Text('Below 75%'),
                  selected: _below75,
                  onSelected: (bool selected) {
                    _below75 = selected;
                    _applyFilters();
                  },
                ),
                FilterChip(
                  backgroundColor: Colors.indigo.shade50,
                  label: Text('Below 65%'),
                  selected: _below65,
                  onSelected: (bool selected) {
                    _below65 = selected;
                    _applyFilters();
                  },
                ),
              ],
            ),

            Expanded(
              child: reportVm.isLoading
                  ? Center(child: const CircularProgressIndicator())
                  : reportVm.success
                  ? _currentReport == null
                        ? Center(child: Text('No report available'))
                        : AttendanceListWidget(
                            data: _currentReport!.studentAttendanceMap.values
                                .toList(),
                          )
                  : Center(child: Text('Couldb\'t fetch the report.')),
            ),
          ],
        ),
      ),
    );
  }
}
