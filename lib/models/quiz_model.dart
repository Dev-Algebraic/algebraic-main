class Quiz {
  List<QuizList>? data;

  Quiz({this.data});

  Quiz.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <QuizList>[];
      json['data'].forEach((v) {
        data!.add(QuizList.fromJson(v));
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

class QuizList {
  String? questionHeader;
  String? question;
  String? description;
  String? questionImg1;
  String? questionImg2;
  String? questionImg3;
  String? type;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? option5;
  String? objectiveAnswer;
  String? textLabel1;
  String? textLabel2;
  String? textLabel3;
  String? textAnswer1;
  String? textAnswer2;
  String? textAnswer3;
  String? answerHint;
  List<String>? options;

  QuizList(
      {this.questionHeader,
      this.question,
      this.description,
      this.questionImg1,
      this.questionImg2,
      this.questionImg3,
      this.type,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.option5,
      this.objectiveAnswer,
      this.textLabel1,
      this.textLabel2,
      this.textLabel3,
      this.textAnswer1,
      this.textAnswer2,
      this.textAnswer3,
      this.options,
      this.answerHint});

  QuizList.fromJson(Map<String, dynamic> json) {
    questionHeader = json['question_header'];
    question = json['question'];
    description = json['description'];
    questionImg1 = json['question_img1'];
    questionImg2 = json['question_img2'];
    questionImg3 = json['question_img3'];
    type = json['type'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    option4 = json['option4'];
    option5 = json['option5'];
    objectiveAnswer = json['objective_answer'];
    textLabel1 = json['text_label1'];
    textLabel2 = json['text_label2'];
    textLabel3 = json['text_label3'];
    textAnswer1 = json['text_answer1'];
    textAnswer2 = json['text_answer2'];
    textAnswer3 = json['text_answer3'];
    answerHint = json['answer_hint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_header'] = questionHeader;
    data['question'] = question;
    data['description'] = description;
    data['question_img1'] = questionImg1;
    data['question_img2'] = questionImg2;
    data['question_img3'] = questionImg3;
    data['type'] = type;
    data['option1'] = option1;
    data['option2'] = option2;
    data['option3'] = option3;
    data['option4'] = option4;
    data['option5'] = option5;
    data['objective_answer'] = objectiveAnswer;
    data['text_label1'] = textLabel1;
    data['text_label2'] = textLabel2;
    data['text_label3'] = textLabel3;
    data['text_answer1'] = textAnswer1;
    data['text_answer2'] = textAnswer2;
    data['text_answer3'] = textAnswer3;
    data['answer_hint'] = answerHint;
    return data;
  }
}