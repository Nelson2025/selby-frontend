class MsgModel {
  bool? fromSelf;
  String? message;
//   String? image;
// File? imageFilePath;
  MsgModel({this.fromSelf, this.message});

  MsgModel.fromJson(Map<String, dynamic> json) {
    fromSelf = json['fromSelf'] ?? false;
    message = json['message'] ?? '';
    // image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromSelf'] = this.fromSelf;
    data['message'] = this.message;
    // data['image'] =this.image;
    return data;
  }
}
