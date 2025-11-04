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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tileColor: Colors.indigo[50],
          splashColor: Colors.indigo[50],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ClassDetailsPage(
                    classModel: widget.assignedClass,
                  );
                },
              ),
            );
          },
          title: Text(widget.assignedClass.subjectName),
          subtitle: Text(widget.assignedClass.className),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
