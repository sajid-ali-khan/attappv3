import 'package:attappv1/data/models/student_attendance/student_attendance.dart';
import 'package:flutter/material.dart';

class AttendanceListWidget extends StatelessWidget {
  final List<StudentAttendance> data;

  const AttendanceListWidget({super.key, required this.data});

  Color _getProgressColor(double percentage) {
    if (percentage < 65) return Colors.red;
    if (percentage < 75) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            // Header row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                color: Color.fromRGBO(232, 234, 246, 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 16,
                children: [
                  SizedBox(width: 32),
                  Expanded(
                    child: Text(
                      'Student',
                      style: TextStyle(fontSize: 12, color: Color(0xff4B5563)),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Present',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff4B5563),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Rate',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff4B5563),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // List rows
            data.isEmpty
                ? Center(child: Text('No data'))
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...data.map((student) {
                            final percentage = student.attendancePercentage;
                            final progressColor = _getProgressColor(percentage);
                            final percentageText =
                                "${percentage.toStringAsFixed(0)}%";

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                spacing: 16,
                                children: [
                                  // Student info
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: const Color(0xFFE8EDFF),
                                    child: Text(
                                      student.name[0],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF4361EE),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          student.roll,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Row(
                                      spacing: 16,
                                      children: [
                                        // Present count
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                "Present",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF6B7280),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "${student.presentDays}/${student.totalDays}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Rate bar and percentage
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // Progress bar
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFE5E7EB,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            3,
                                                          ),
                                                    ),
                                                  ),
                                                  FractionallySizedBox(
                                                    widthFactor:
                                                        percentage / 100,
                                                    child: Container(
                                                      height: 6,
                                                      decoration: BoxDecoration(
                                                        color: progressColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              3,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                percentageText,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: progressColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
