import 'package:attappv1/data/models/attendance_report/attendance_report.dart';
import 'package:attappv1/data/repositories/report_repository.dart';
import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier {
  final _reportRepository = ReportRepository();
  bool _isLoading = false;
  bool _success = false;
  String? _errorMessage;
  AttendanceReport? _attendanceReport;

  bool get isLoading => _isLoading;
  bool get success => _success;
  String? get errorMessage => _errorMessage;
  AttendanceReport get attendanceReport => _attendanceReport!;

  Future<void> getReport({
    required int courseId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    _success = false;
    _errorMessage = null;
    notifyListeners();

    late final Map<String, dynamic> result;
    if (startDate == null && endDate == null) {
      result = await _reportRepository.fetchFullAttendanceReport(courseId);
    } else {
      result = await _reportRepository.fetchFullAttendanceReportBetweenDates(
        courseId,
        startDate!.toUtc(),
        endDate!.toUtc(),
      );
    }
    _isLoading = false;
    if (result['success']) {
      _success = true;
      _attendanceReport = result['attendanceReport'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }
}
