import 'package:attappv1/data/models/branch_model/branch_model.dart';
import 'package:attappv1/data/repositories/class_repository.dart';
import 'package:flutter/foundation.dart';

class ClassProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _success = false;
  String? _errorMessage;
  List<BranchModel>? _branches;
  List<int>? _semesters;
  List<String>? _sections;

  final ClassRepository _classRepository = ClassRepository();

  bool get isLoading => _isLoading;
  List<BranchModel> get branches => _branches == null ? [] : _branches!;
  List<int> get semesters => _semesters == null ? [] : _semesters!;
  List<String> get sections => _sections == null ? [] : _sections!;
  bool get success => _success;
  String get errorMessage => _errorMessage!;

  Future<void> getDistinctBranches() async {
    _isLoading = true;
    _success = false;
    _errorMessage = null;

    notifyListeners();

    try {
      final result = await _classRepository.getDistinctBranches();
      _isLoading = false;
      notifyListeners();

      if (result['success']) {
          _success = true;
          _branches = result['branches'] as List<BranchModel>;
        } else {
          _errorMessage = result['message'] as String;
        }
        notifyListeners();
      
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSemestersByBranch(int branchCode) async {
    _success = false;
    _errorMessage = null;
    _semesters = null;
    _sections = null;
    notifyListeners();

    try {
      final result = await _classRepository.getSemestersByBranch(branchCode);
      if (result['success']) {
        _success = true;
        _semesters = result['semesters'] as List<int>;
        } else {
          _errorMessage = result['message'] as String;
        }
        notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> getSectionsByBranchCodeAndSemester(int branchCode, int semester) async {
    _success = false;
    _errorMessage = null;
    _sections = null;
    notifyListeners();

    try {
      final result = await _classRepository.getSectionsByBranchCodeAndSemester(branchCode, semester);
      if (result['success']) {
        _success = true;
        _sections = result['sections'] as List<String>;
      } else {
        _errorMessage = result['message'] as String;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}