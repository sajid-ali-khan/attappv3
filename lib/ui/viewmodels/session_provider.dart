import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/data/models/session_register/session_register.dart';
import 'package:attappv1/data/repositories/session_repository.dart';
import 'package:flutter/foundation.dart';

class SessionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isFetching = false;
  bool _isUpdating = false;
  bool _loaded = false;
  bool _created = false;
  bool _fetched = false;
  bool _updated = false;
  String? _errorMessage;
  Map<int, SessionModel>? _sessionMap;
  SessionRegister? _sessionRegister;
  int? _fetchingSessionRegisterId;

  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isFetching => _isFetching;
  bool get isUpdating => _isUpdating;
  bool get loaded => _loaded;
  bool get created => _created;
  bool get fetched => _fetched;
  bool get updated => _updated;
  String get errorMessage => _errorMessage!;
  SessionRegister get sessionRegister => _sessionRegister!;
  int get fetchingSessionRegisterId => _fetchingSessionRegisterId!;
  Iterable<SessionModel> get sessions =>
      _sessionMap == null ? [] : _sessionMap!.values;

  final SessionRepository _sessionRepository = SessionRepository();

  Future<void> getSessionsByDate(int classId, DateTime date) async {
    _isLoading = true;
    _loaded = false;
    _sessionMap = null;
    _errorMessage = null;

    notifyListeners();

    final result = await _sessionRepository.fetchSessions(classId, date);

    _isLoading = false;

    if (result["success"]) {
      _loaded = true;
      _sessionMap = result["sessionMap"];
    } else {
      _loaded = false;
      _errorMessage = result["message"];
    }

    notifyListeners();
  }

  Future<void> deleteSessionById(int sessionId) async {
    final result = await _sessionRepository.deleteSession(sessionId);
    if (result['success']) {
      _sessionMap!.remove(sessionId);
    } else {
      _errorMessage = result["message"];
    }

    notifyListeners();
  }

  Future<void> createSession(int courseId) async {
    _isCreating = true;
    _created = false;
    _errorMessage = null;
    notifyListeners();
    final result = await _sessionRepository.createNewSession(courseId);
    if (result['success']) {
      final newSession = result["session"] as SessionModel;
      await fetchSessionRegister(newSession.sessionId);

      if (_fetched) {
        _created = true;
      } else {
        _created = false;
        await _sessionRepository.deleteSession(newSession.sessionId);
      }
    } else {
      _created = false;
      _errorMessage = result["message"];
    }

    _isCreating = false;
    notifyListeners();
  }

  Future<void> fetchSessionRegister(int sessionId) async {
    _isFetching = true;
    _fetchingSessionRegisterId = sessionId;
    _fetched = false;
    _errorMessage = null;

    notifyListeners();
    final result2 = await _sessionRepository.fetchSessionRegister(sessionId);

    _isFetching = false;
    if (result2['success']) {
      _fetched = true;
      _sessionRegister = result2['sessionRegister'];
    } else {
      _errorMessage = result2['message'];
    }
    notifyListeners();
  }

  Future<void> updateSessionRegister(SessionRegister sessionRegister) async {
    _isUpdating = true;
    _updated = false;
    _errorMessage = null;

    notifyListeners();

    final result = await _sessionRepository.updateSession(sessionRegister);
    _isUpdating = false;
    if (result['success']) {
      _updated = true;
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }
}
