import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:selby/models/msg_model.dart';
import 'package:selby/models/room_model.dart';
import 'package:selby/models/user_model.dart';
import 'package:selby/core/configuration.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static var client = http.Client();
  List<MsgModel> messagesList = [];
  Future getMessages(
      {required String clientId,
      required String myId,
      required String roomId,
      required String productId}) async {
    Dio dio = Dio();

    var headers = {'Content-Type': 'application/json'};

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
      // print(value.data.toString()+ 'aaaaaaaaaaaaa');
      var list = value.data as List;

      for (var element in list) {
        MsgModel messageModel = MsgModel.fromJson(element);

        messagesList.add(messageModel);
      }
// print(messagesList.toString()+ 'aaaaaaaaaaaaa');

      return messagesList;
    }).catchError((e) {
      print(e);
    });

// var headers = {
//   'Content-Type': 'application/json'
// };
// var data = json.encode({
//   "from": "658842425586e8adc1d63347",
//   "to": "658851905586e8adc1d63352"
// });
// var dio = Dio();
// var response = await dio.request(
//   'http://192.168.18.72:5000/api/messages/getmsg',
//   options: Options(
//     method: 'POST',
//     headers: headers,
//   ),
//   data: data,
// );

// if (response.statusCode == 200) {
//   print(json.encode(response.data));
// }
// else {
//   print(response.statusMessage);
// }
  }

//send messagess
  Future<void> sendMessage({
    required String clientId,
    required String myId,
    required String? message,
    required String? roomId,
    required String? productId,
    // String? image
  }) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "to": clientId,
      "from": myId,
      "message": message,
      "roomId": roomId,
      "productId": productId,
      // "image": image ?? ''
      // "image":"https://images.unsplash.com/photo-1703192163803-e63d896d2379?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxM3x8fGVufDB8fHx8fA%3D%3D"
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
      print(json.encode(response.data).toString() + 'aaaaaaaaaaaaaaaaaaa');
    } else {
      print(response.statusMessage.toString() + 'aaaaaaaaaaaa');

      throw Exception('Error');
    }
  }

  // Future uploadImageToCloudinary(String imagePath) async {
  //   Dio dio = new Dio();
  //   try {
  //     String cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dv8st8mw4/upload';
  //     FormData formData = FormData.fromMap({
  //       'file': await MultipartFile.fromFile(imagePath),
  //       'upload_preset': 'la5wyzno',
  //       // Add any additional parameters or options as needed
  //     });

  //     Response response = await dio.post(cloudinaryUrl, data: formData);

  //     if (response.statusCode == 200) {
  //       // Image uploaded successfully
  //       print("Image uploaded successfully");
  //       log(response.data['secure_url']);

  //       return response.data['secure_url'];
  //     } else {
  //       // Handle error
  //       print("Error uploading image: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     // Handle exception
  //     print("Exception during image upload: $e");
  //   }
  // }

//send messagess
  Future<RoomModel> createRoom(
      {required clientModel, required myModel, required productId}) async {
    // var headers = {'Content-Type': 'application/json'};
    // var data = json.encode({
    //   "clientModel": {"_id": clientModel},
    //   "myModel": {"_id": myModel},
    // });
    // var dio = Dio();
    // var response = await dio.request(
    //   "${Configuration.baseUrl}/messages/createRoom/",
    //   options: Options(
    //     method: 'POST',
    //     headers: headers,
    //   ),
    //   data: data,
    // );
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

    print(response.body);
    return roomModel(response.body);

    // if (response.statusCode == 200) {
    //   // var res= json.encode(response.data);
    //   print(response.data['data'].toString() + 'created');
    //   RoomModel roomModel = RoomModel.fromJson(response.data?['data']);
    //   return roomModel;
    // } else {
    //   print(response.statusMessage.toString() + 'aaaaaaaaaaaa');

    //   throw Exception('Error');
    // }
  }
}
