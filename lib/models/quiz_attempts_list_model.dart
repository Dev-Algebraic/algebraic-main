class Attempts {
  List<QuizAttemptsList>? data;

  Attempts({this.data});

  Attempts.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <QuizAttemptsList>[];
      json['data'].forEach((v) {
        data!.add(QuizAttemptsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuizAttemptsList {
  int? moduleFk;
  int? score;
  int? attemptNum;
  int? totalQuestions;
  DateTime? createdDate;
  dynamic scorePercentage;

  QuizAttemptsList(
      {
      this.moduleFk,
      this.score,
      this.attemptNum,
      this.totalQuestions,
      this.createdDate,
      this.scorePercentage});

  QuizAttemptsList.fromJson(Map<String, dynamic> json) {
    moduleFk = json['module_fk'];
    score = json['score'];
    attemptNum = json['attempt_num'];
    totalQuestions = json['total_questions'];
    createdDate = (json['created_date'] != null) ? DateTime.parse(json['created_date']) : null;
    scorePercentage = json['score_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module_fk'] = moduleFk;
    data['score'] = score;
    data['attempt_num'] = attemptNum;
    data['total_questions'] = totalQuestions;
    data['created_date'] = createdDate?.toIso8601String();
    data['score_percentage'] = scorePercentage;
    return data;
  }
}