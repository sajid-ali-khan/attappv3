import 'package:attappv1/data/models/attendance_report/attendance_report.dart';
import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/data/services/api/attendance_report_service.dart';
import 'package:attappv1/ui/views/widgets/report_widget.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class ReportPage extends StatefulWidget {
  final AttendanceReport attendanceReport;
  
  final ClassModel classModel;

  const ReportPage({super.key, required this.attendanceReport, required this.classModel});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  late AttendanceReport _currentReport =
      widget.attendanceReport; // mutable copy
  bool _below75 = false;
  bool _below65 = false;
  bool _sortByAttendance = false;

  @override
  void initState() {
    super.initState();
    _currentReport = widget.attendanceReport; // original data on load
  }

  void _applyFilters() {
    final students = widget.attendanceReport.studentAttendanceMap.values
        .toList();

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
      _currentReport = AttendanceReport(
        className: widget.attendanceReport.className,
        subjectName: widget.attendanceReport.subjectName,
        studentAttendanceMap: {for (var s in filtered) s.roll: s},
      );
    });
  }

  Future<void> _refreshData() async {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Select both dates first"), behavior: SnackBarBehavior.floating,));
      return;
    }

    final newReport = await fetchFullAttendanceReportBetweenDates(
      widget.classModel.classId,
      _selectedStartDate!,
      _selectedEndDate!,
    );

    setState(() {
      _currentReport = newReport;
      _below65 = false;
      _below75 = false;
      _sortByAttendance = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance Report')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    decoration: const InputDecoration(labelText: 'From'),
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                    onChanged: (value) => _selectedStartDate = value,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    decoration: const InputDecoration(labelText: 'To'),
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                    onChanged: (value) => _selectedEndDate = value,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Refresh button
            OutlinedButton.icon(
              onPressed: _refreshData,
              label: Text('Apply'),
              icon: Icon(Icons.refresh),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 42),
              ),
            ),

            SizedBox(height: 12),

            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                // Sort Chip
                FilterChip(
                  label: Text('Sort by %'),
                  avatar: Icon(Icons.sort, size: 18),
                  selected: _sortByAttendance,
                  onSelected: (bool selected) {
                    setState(() {
                      _sortByAttendance = selected;
                      _applyFilters();
                    });
                  },
                ),

                FilterChip(
                  label: Text('Below 75%'),
                  selected: _below75,
                  onSelected: (bool selected) {
                    _below75 = selected;
                    _applyFilters();
                  },
                ),
                FilterChip(
                  label: Text('Below 65%'),
                  selected: _below65,
                  onSelected: (bool selected) {
                    _below65 = selected;
                    _applyFilters();
                  },
                ),
              ],
            ),

            SizedBox(height: 12),

            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ReportWidget(report: _currentReport),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
