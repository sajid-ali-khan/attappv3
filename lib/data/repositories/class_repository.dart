import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/branch_model/branch_model.dart';
import 'package:attappv1/data/network/auth_http_client.dart';

class ClassRepository {
  final AuthHttpClient _httpClient = AuthHttpClient();

  Future<Map<String, dynamic>> getDistinctBranches() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/student-batches/branches'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final List<BranchModel> branches = [];
        for (var b in json) {
          branches.add(BranchModel.fromJson(b));
        }
        return {'success': true, 'branches': branches};
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e, stack) {
      log('Error fetching distinct branches: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> getSemestersByBranch(int branchCode) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/student-batches/semesters?branchCode=$branchCode'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final List<int> semesters = [];
        for (var s in json) {
          semesters.add(s as int);
        }
        return {'success': true, 'semesters': semesters};
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e, stack) {
      log('Error fetching semesters by branch: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> getSectionsByBranchCodeAndSemester(
    int branchCode,
    int semester,
  ) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
          '$baseUrl/student-batches/sections?branchCode=$branchCode&semester=$semester',
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final List<String> sections = [];
        for (var s in json) {
          sections.add(s as String);
        }
        return {'success': true, 'sections': sections};
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e, stack) {
      log('Error fetching sections by branch code and semester: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }
}
