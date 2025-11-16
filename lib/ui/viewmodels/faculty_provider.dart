import 'package:attappv1/data/repositories/faculty_repository.dart';
import 'package:flutter/material.dart';

class FacultyProvider extends ChangeNotifier {
  final FacultyRepository facultyRepository = FacultyRepository();
  bool _isLoading = false;
  bool _success = false;
  String _facultyName = '';

  bool get isLoading => _isLoading;
  bool get success => _success;
  String get facultyName => _facultyName;

  Future<void> getFacultyName(String name) async {
    _facultyName = '';
    _isLoading = true;
    _success = false;
    notifyListeners();

    final result = await facultyRepository.getFacultyName();
    _isLoading = false;
    if (result['success']){
      _facultyName = result['name'];
      _success = true;
    }
    notifyListeners();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async{
    _isLoading = true;
    _success = false;
    notifyListeners();

    final result = await facultyRepository.changePassword(currentPassword, newPassword);
    _isLoading = false;
    if (result['success']){
      _success = true;
    }
    notifyListeners();
  }
}