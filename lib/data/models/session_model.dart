class SessionModel {
  int sessionId;
  String sessionName;
  DateTime updatedAt;

  SessionModel({
    required this.sessionId,
    required this.sessionName,
    required this.updatedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: 0,
      sessionName: json['sessionName'],
      updatedAt: json['updatedat'],
    );
  }
}
