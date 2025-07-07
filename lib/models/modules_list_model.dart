class Modules {
  List<ModulesList>? data;

  Modules({this.data});

  Modules.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ModulesList>[];
      json['data'].forEach((v) {
        data!.add(ModulesList.fromJson(v));
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

class ModulesList {
  int? order_no;
  String? name;
  String? description;
  int? score;
  int? quizAttempt;
  int? totalQuestions;
  int? userFk;
  dynamic scorePercentage;

  ModulesList(
      {this.order_no,
      this.name,
      this.description,
     this.score,
      this.quizAttempt,
      this.totalQuestions,
      this.userFk,
      this.scorePercentage});

  ModulesList.fromJson(Map<String, dynamic> json) {
    order_no = json['order_no'];
    name = json['name'];
    description = json['description'];
    score = json['score'];
    quizAttempt = json['quiz_attempt'];
    totalQuestions = json['total_questions'];
    userFk = json['user_fk'];
    scorePercentage = json['score_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_no'] = order_no;
    data['name'] = name;
    data['description'] = description;
    data['score'] = score;
    data['quiz_attempt'] = quizAttempt;
    data['total_questions'] = totalQuestions;
    data['user_fk'] = userFk;
    data['score_percentage'] = scorePercentage;
    return data;
  }
}