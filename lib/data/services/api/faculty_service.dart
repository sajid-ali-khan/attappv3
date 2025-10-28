import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/data/network/auth_http_client.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';

final khttp = AuthHttpClient();

Future<String?> getFacultyName() async{
  String? username = await getUsername();
  if (username == null){
    return null;
  }
  final facultyCode = username;

  final response = await khttp.get(
    Uri.parse('$baseUrl/faculties/$facultyCode/name')
  );

  if (response.statusCode == 404){
    return "Username Not Found.";
  }
  final json = jsonDecode(response.body);
  log(json.toString());
  // return json.name;
  return json["name"];
}

Future<List<ClassModel>> getFacultyClasses() async{
  String? username = await getUsername();
  if (username == null) return [];

  final facultyCode = username;

  final response = await khttp.get(
    Uri.parse('$baseUrl/faculties/$facultyCode/classes')
  );

  if (response.statusCode == 400) return [];

  final json = jsonDecode(response.body) as List;
  log(json.toString());
  final List<ClassModel> classes = [];
  for (var c in json){
    classes.add(ClassModel.fromJson(c));
  }

  log(classes.toString());
  return classes;
}