import 'package:attappv1/data/models/attendance_report/attendance_report.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({super.key, required this.report});

  final AttendanceReport report;

  @override
  Widget build(BuildContext context) {
    final studentList = report.studentAttendanceMap.values.toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ListView.separated(
        itemCount: studentList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 2),
        itemBuilder: (context, index) {
          final reportItem = studentList[index]; // ✅ StudentAttendance object

          return Card(
            margin: EdgeInsets.zero,
            elevation: 0.0,
            color: Colors.indigo[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reportItem.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reportItem.roll,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Side: Percentage
                  Text(
                    '${reportItem.attendancePercentage.toStringAsFixed(2)}%', // ✅ show 2 decimals
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
