import 'package:attappv1/ui/viewmodels/class_provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassProvider>().getDistinctBranches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Consolidated Report'),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          spacing: 24,
          children: [
            Text('Select Class', style: TextStyle(fontSize: 16)),
            // Branch Dropdown
            Consumer<ClassProvider>(
              builder: (context, classProvider, _) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Select Branch'),
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
                          context.read<ClassProvider>().getSemestersByBranch(branchCode);
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
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      hint: Text('Select Semester'),
                      value: selectedSemester,
                      dropdownColor: Colors.white,
                      items: classProvider.semesters.map((semester) {
                        return DropdownMenuItem<int>(
                          value: semester,
                          child: Text(semester.toString()),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        if (newValue != null && selectedBranchCode != null) {
                          setState(() {
                            selectedSemester = newValue;
                            selectedSection = null;
                          });
                          final branchCode = int.parse(selectedBranchCode!);
                          context.read<ClassProvider>().getSectionsByBranchCodeAndSemester(branchCode, newValue);
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
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Select Section'),
                      value: selectedSection,
                      dropdownColor: Colors.white,
                      items: classProvider.sections.map((section) {
                        return DropdownMenuItem<String>(
                          value: section,
                          child: Text(section),
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
            // Submit Button
            FilledButton(
              onPressed: _handleSubmit,
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (selectedBranchCode == null || selectedSemester == null || selectedSection == null) {
      showMySnackbar(context, 'Please select all fields');
      return;
    }

    // TODO: Handle the submission with selectedBranchCode, selectedSemester, selectedSection
    print('Branch Code: $selectedBranchCode');
    print('Semester: $selectedSemester');
    print('Section: $selectedSection');
  }
}