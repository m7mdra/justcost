class FQA {
  var show = false;
  int id;
  String question;
  String questionAr;
  String answer;
  String answerAr;
  String createdAt;
  String updatedAt;
  String deletedAt;

  FQA(
      {
        this.id,
        this.question,
        this.questionAr,
        this.answer,
        this.answerAr,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  FQA.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    questionAr = json['question_ar'];
    answer = json['answer'];
    answerAr = json['answer_ar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['question_ar'] = this.questionAr;
    data['answer'] = this.answer;
    data['answer_ar'] = this.answerAr;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}