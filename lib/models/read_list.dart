class Read {
  List<ReadList>? data;

  Read({this.data});

  Read.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ReadList>[];
      json['data'].forEach((v) {
        data!.add(ReadList.fromJson(v));
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

class ReadList {
  int? topicFk;
  int? userFk;
  int? createdBy;

  ReadList({this.topicFk, this.userFk, this.createdBy});

  ReadList.fromJson(Map<String, dynamic> json) {
    topicFk = json['topic_fk'];
    userFk = json['user_fk'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topic_fk'] = topicFk;
    data['user_fk'] = userFk;
    data['created_by'] = createdBy;
    return data;
  }
}