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
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: handleClick,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              spacing: 12,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.class_,
                    color: Color(0xFF4C3FBB),
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        widget.assignedClass.className,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.assignedClass.subjectDisplayName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF999999),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
