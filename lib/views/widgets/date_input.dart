import 'package:attappv1/data/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  const DateInput({super.key, required this.label, required this.selectedDate});

  final String label;
  final DateTime selectedDate;
  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          SizedBox(height: 5,),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tileColor: Colors.deepPurple[50],
            splashColor: Colors.deepPurple[50],
            onTap: () {
              showDatePicker(context: context, firstDate: kFirstDay, lastDate: kLastDay);
            },
            title: Text(DateFormat('yMd').format(widget.selectedDate)),
            trailing: Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
    );
  }
}
