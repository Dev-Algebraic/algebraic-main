class Topics {
  List<TopicsList>? data;

  Topics({this.data});

  Topics.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TopicsList>[];
      json['data'].forEach((v) {
        data!.add(TopicsList.fromJson(v));
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

class TopicsList {
  String? name;
  String? description;
  String? content;
  int? orderNo;
  int? status;
  String? effectiveFrom;
  String? effectiveTo;
  int? createdBy;
  String? createdDate;
  String? templateUrl;

  TopicsList(
      {this.name,
      this.description,
      this.content,
      this.orderNo,
      this.status,
      this.effectiveFrom,
      this.effectiveTo,
      this.createdBy,
      this.templateUrl,
      this.createdDate});

  TopicsList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    content = json['content'];
    orderNo = json['order_no'];
    status = json['status'];
    effectiveFrom = json['effective_from'];
    effectiveTo = json['effective_to'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    templateUrl = json['pdf_template_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['content'] = content;
    data['order_no'] = orderNo;
    data['status'] = status;
    data['effective_from'] = effectiveFrom;
    data['effective_to'] = effectiveTo;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['pdf_template_url'] = templateUrl;
    return data;
  }
}