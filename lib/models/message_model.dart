class MessageModel {
  String? time;
  String? sender;
  String? message;

  MessageModel({this.time, this.sender, this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    sender = json['sender'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['sender'] = sender;
    data['message'] = message;
    return data;
  }
}
