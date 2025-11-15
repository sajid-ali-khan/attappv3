import 'package:attappv1/data/models/student_attendance/student_attendance.dart';
import 'package:flutter/material.dart';

class AttendanceListWidget extends StatelessWidget {
  final List<StudentAttendance> data;

  const AttendanceListWidget({super.key, required this.data});

  Color _getProgressColor(double percentage) {
    if (percentage < 65) return Colors.red.shade400;
    if (percentage < 75) return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: data.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
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
                        'No attendance data available',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateColor.resolveWith(
                      (states) => Colors.grey.shade100,
                    ),
                    dataRowMinHeight: 48,
                    dataRowMaxHeight: 60,
                    columnSpacing: 12,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Roll',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Name',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Pres',
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Total',
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Att %',
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      numeric: true,
                    ),
                    ],
                    rows: data
                        .map(
                          (student) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  student.roll,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataCell(
                                Text(
                                  student.name,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    student.presentDays.toString(),
                                    style: Theme.of(context).textTheme.labelSmall
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    student.totalDays.toString(),
                                    style: Theme.of(context).textTheme.labelSmall
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getProgressColor(
                                        student.attendancePercentage,
                                      ).withAlpha(30),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: _getProgressColor(
                                          student.attendancePercentage,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '${student.attendancePercentage.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: _getProgressColor(
                                          student.attendancePercentage,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
