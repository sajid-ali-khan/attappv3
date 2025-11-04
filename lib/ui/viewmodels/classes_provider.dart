
import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/data/repositories/classes_repository.dart';
import 'package:flutter/foundation.dart';

class ClassesProvider extends ChangeNotifier {
  final ClassesRepository _classesRepository = ClassesRepository();
  bool _isLoading = false;
  bool _success = false;
  List<ClassModel>? _classes;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get success => _success;
  List<ClassModel> get classes => _classes!;
  String get errorMessage => _errorMessage!;


  Future<void> getClasses() async{
    _isLoading = true;
    _success = false;
    _errorMessage = null;
    _classes = null;

    notifyListeners();

    final result = await _classesRepository.getFacultyClasses();
    _isLoading = false;
    if (result["success"]){
      _success = true;
      _classes = result["classes"];
    }else {
      _success = false;
      _errorMessage = result["message"];
    }
    notifyListeners();
  }
}
