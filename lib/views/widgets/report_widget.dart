import 'package:attappv1/data/models/report_row.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({super.key, required this.report});

  final List<ReportRow> report;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListView.separated(
                  itemCount: report.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final reportItem = report[index];

                    return Card(
                      margin: EdgeInsets.zero,
                      elevation: 0.0,
                      color: Colors.deepPurple[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // Center vertically
                          children: [
                            // Left Side: Name and Roll Number
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reportItem.student.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Roll No: ${reportItem.student.roll}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Right Side: Percentage ONLY
                            Text(
                              '${reportItem.percentage}%', // Added % here for clarity
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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