import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/ui/views/pages/class_details_page.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({super.key, required this.assignedClass});

  final ClassModel assignedClass;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: Colors.deepPurple[50],
          splashColor: Colors.deepPurple[50],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ClassDetailsPage(
                    subjectName: assignedClass.subjectName,
                  );
                },
              ),
            );
          },
          title: Text(assignedClass.subjectName),
          subtitle: Text(assignedClass.className),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
