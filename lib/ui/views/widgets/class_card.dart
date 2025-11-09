import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/ui/views/pages/class_details_page.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatefulWidget {
  const ClassCard({super.key, required this.assignedClass});

  final ClassModel assignedClass;

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  void handleClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ClassDetailsPage(classModel: widget.assignedClass);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: handleClick,
        child: ListTile(
          title: Text(widget.assignedClass.className),
          subtitle: Text(
            widget.assignedClass.subjectName,
            style: TextStyle(fontSize: 12),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
    // return Card(color: Colors.indigo.shade50 ,child: ListTile(title: Text('Consolidated Attendance Report'),),);
  }
}
