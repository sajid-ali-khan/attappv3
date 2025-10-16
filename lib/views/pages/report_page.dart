import 'package:attappv1/data/utils.dart';
import 'package:attappv1/views/widgets/date_input.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Class: CSE(A) - 7th Sem', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              DateInput(label: 'From', selectedDate: kLastDay,),
              SizedBox(width: 10,),
              DateInput(label: 'To', selectedDate: DateTime.now(),),
            ],)
          ],
        ),
      ),
    );
  }
}
