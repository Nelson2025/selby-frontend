/* This is Message Provider*/
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/models/msg_model.dart';
import 'package:selby/models/room_model.dart';
import 'package:selby/services/msg_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class MessageProvider extends ChangeNotifier {
  List<MsgModel> messagesList = [];
  RoomModel? roomModel = RoomModel();
  MessageService messageService = MessageService();
  late IO.Socket socket;
  getMessageChart(
      {required String clientId,
      required String userModel,
      required String roomId,
      required String productId}) async {
    log('message initiated');
    MessageService messageService = MessageService();

    await messageService
        .getMessages(
            clientId: clientId,
            myId: userModel,
            roomId: roomId,
            productId: productId)
        .then((value) {
      messagesList.assignAll(value);
      notifyListeners();
    });
  }

  addNewMessage(MsgModel message) {
    messagesList.add(message);
    notifyListeners();
  }

  sendMessage(
      {required String clientId,
      required String userModel,
      required String? message,
      required String? roomId,
      required String? productId}) async {
    log('message initiated');
    log(roomId.toString());
    await messageService
        .sendMessage(
            clientId: clientId,
            myId: userModel,
            message: message,
            roomId: roomId,
            productId: productId)
        .then((value) {
      socket.emit('send-msg', {
        'roomId': roomModel!.sId,
        'to': clientId,
        'message': message,
      });

      addNewMessage(MsgModel(message: message, fromSelf: true));
      notifyListeners();
    });
  }

  getRoomId(
      {required clientModel, required myModel, required productId}) async {
    roomModel = null;
    roomModel = await messageService.createRoom(
        clientModel: clientModel, myModel: myModel, productId: productId);
    notifyListeners();
  }

  fetchRoomsById() async {
    List<RoomModel> rooms = [];
    String userId = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString('userId').toString();
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchRoomByIdUrl}$userId'),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        result['data'].forEach((value) => {
              rooms.add(
                RoomModel(
                    sId: value['_id'],
                    users: value['users'],
                    results: value['productId']['pid'],
                    senderDetails: value['senderId'],
                    receiverDetails: value['receiverId'],
                    msgStatus: value['msgStatus'],
                    lastUser: value['lastUser'],
                    updatedAt: value['updatedAt'],
                    createdAt: value['createdAt']),
              ),
            });
        return rooms;
      } else {
        return [];
      }
    } catch (ex) {
      log(ex.toString());
    }
  }
}
