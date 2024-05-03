/* This is Message services*/
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:selby/models/msg_model.dart';
import 'package:selby/models/room_model.dart';
import 'package:selby/core/configuration.dart';
import 'package:http/http.dart' as http;

//get Messages
class MessageService {
  static var client = http.Client();
  List<MsgModel> messagesList = [];
  Future getMessages(
      {required String clientId,
      required String myId,
      required String roomId,
      required String productId}) async {
    Dio dio = Dio();

    var data = json.encode({
      "from": myId,
      "to": clientId,
      "roomId": roomId,
      "productId": productId
    });
    return dio
        .post(
      "${Configuration.baseUrl}/messages/getMsg",
      data: data,
      options: Options(contentType: 'application/json'),
    )
        .then((value) {
      var list = value.data as List;

      for (var element in list) {
        MsgModel messageModel = MsgModel.fromJson(element);

        messagesList.add(messageModel);
      }

      return messagesList;
    }).catchError((e) {
      log(e.toString());
    });
  }

//send messages
  Future<void> sendMessage({
    required String clientId,
    required String myId,
    required String? message,
    required String? roomId,
    required String? productId,
  }) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "to": clientId,
      "from": myId,
      "message": message,
      "roomId": roomId,
      "productId": productId,
    });
    var dio = Dio();
    var response = await dio.request(
      "${Configuration.baseUrl}/messages/addMsg",
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      log(json.encode(response.data));
    } else {
      log('${response.statusMessage}');

      throw Exception('Error');
    }
  }

//create room
  Future<RoomModel> createRoom(
      {required clientModel, required myModel, required productId}) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.parse("${Configuration.baseUrl}/messages/createRoom/");

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "clientModel": {"_id": clientModel},
          "myModel": {"_id": myModel},
          "productId": productId,
        },
      ),
    );

    return roomModel(response.body);
  }
}
