import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/utils.dart';
import 'package:attappv1/ui/views/widgets/date_input.dart';
import 'package:attappv1/ui/views/widgets/report_widget.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance Report')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class: CSE(A) - 7th Sem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DateInput(label: 'From', selectedDate: kLastDay),
                SizedBox(width: 10),
                DateInput(label: 'To', selectedDate: DateTime.now()),
              ],
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                Chip(
                  label: Text('Attendance %'),
                  avatar: Icon(Icons.sort, size: 18),
                  onDeleted: () {},
                  deleteIcon: Icon(Icons.close, size: 18),
                ),
                FilterChip(
                  label: Text('Below 75%'),
                  selected: false,
                  onSelected: (bool selected) {},
                ),
                FilterChip(
                  label: Text('Below 65%'),
                  selected: false,
                  onSelected: (bool selected) {},
                ),
              ],
            ),
            SizedBox(height: 12),

            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(child: ReportWidget(report: Constants.report)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
