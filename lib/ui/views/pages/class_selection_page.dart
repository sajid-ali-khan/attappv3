import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/ui/viewmodels/class_provider.dart';
import 'package:attappv1/ui/viewmodels/connection_provider.dart';
import 'package:attappv1/ui/views/pages/report_page.dart';
import 'package:attappv1/ui/views/widgets/custom_appbar2.dart';
import 'package:attappv1/ui/views/widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassSelectionPage extends StatefulWidget {
  const ClassSelectionPage({super.key});

  @override
  State<ClassSelectionPage> createState() => _ClassSelectionPageState();
}

class _ClassSelectionPageState extends State<ClassSelectionPage> {
  String? selectedBranchCode;
  int? selectedSemester;
  String? selectedSection;
  DateTime _lastRefresh = DateTime.now();

  @override
  void initState() {
    super.initState();
    reloadData();
  }

  void reloadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassProvider>().getDistinctBranches();
    });
  }

  Widget buildClassSelectionForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        spacing: 20,
        children: [
          Text(
            'Select Class',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          // Branch Dropdown
          Consumer<ClassProvider>(
            builder: (context, classProvider, _) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Branch',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    value: selectedBranchCode,
                    dropdownColor: Colors.white,
                    items: classProvider.branches.map((branch) {
                      return DropdownMenuItem<String>(
                        value: branch.branchCode.toString(),
                        child: Text(branch.displayName),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedBranchCode = newValue;
                          selectedSemester = null;
                          selectedSection = null;
                        });
                        final branchCode = int.parse(newValue);
                        context.read<ClassProvider>().getSemestersByBranch(
                          branchCode,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
          // Semester Dropdown
          Consumer<ClassProvider>(
            builder: (context, classProvider, _) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    hint: Text(
                      'Select Semester',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    value: selectedSemester,
                    dropdownColor: Colors.white,
                    items: classProvider.semesters.map((semester) {
                      return DropdownMenuItem<int>(
                        value: semester,
                        child: Text('Semester $semester'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null && selectedBranchCode != null) {
                        setState(() {
                          selectedSemester = newValue;
                          selectedSection = null;
                        });
                        final branchCode = int.parse(selectedBranchCode!);
                        context
                            .read<ClassProvider>()
                            .getSectionsByBranchCodeAndSemester(
                              branchCode,
                              newValue,
                            );
                      }
                    },
                  ),
                ),
              );
            },
          ),
          // Section Dropdown
          Consumer<ClassProvider>(
            builder: (context, classProvider, _) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Section',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    value: selectedSection,
                    dropdownColor: Colors.white,
                    items: classProvider.sections.map((section) {
                      return DropdownMenuItem<String>(
                        value: section,
                        child: Text('Section $section'),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedSection = newValue;
                        });
                      }
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // Submit Button
          FilledButton.icon(
            onPressed: _handleSubmit,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('View Report'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbar2(
        title: 'Consolidated Report',
        subTitle: 'Select class filters to view attendance',
      ),
      body: ValueListenableBuilder(
        valueListenable: context.read<ConnectionProvider>().refreshNotifier,
        builder: (context, timestamp, child) {
          if (_lastRefresh != timestamp) {
            _lastRefresh = timestamp;
            reloadData();
          }
          return buildClassSelectionForm();
        },
      ),
    );
  }

  void _handleSubmit() {
    if (selectedBranchCode == null ||
        selectedSemester == null ||
        selectedSection == null) {
      showMySnackbar(context, 'Please select all fields');
      return;
    }

    // Create a dummy ClassModel for consolidated report
    final consolidatedClassModel = ClassModel(
      classId: 0,
      className: 'Consolidated Report',
      subjectShortForm: '',
      subjectFullForm: 'Total Attendance',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportPage(
          classModel: consolidatedClassModel,
          consolidated: true,
          branchCode: int.parse(selectedBranchCode!),
          semester: selectedSemester,
          section: selectedSection,
        ),
      ),
    );
  }
}
