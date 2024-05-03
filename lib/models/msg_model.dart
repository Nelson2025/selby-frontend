/*This is the model of Message*/
class MsgModel {
  bool? fromSelf;
  String? message;
  MsgModel({this.fromSelf, this.message});

  MsgModel.fromJson(Map<String, dynamic> json) {
    fromSelf = json['fromSelf'] ?? false;
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromSelf'] = this.fromSelf;
    data['message'] = this.message;
    return data;
  }
}
