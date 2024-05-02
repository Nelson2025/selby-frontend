// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:selby/core/config.dart';
// import 'package:selby/models/autos_model.dart';
// import 'package:selby/models/otp_model.dart';
// import 'package:selby/models/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AutosApi {
//   static var client = http.Client();

//   static Future<AutosModel> createAutos(String categoryId, String userId, String price, String title) async {
//     Map<String, String> requestHeaders = {
//       'Content-Type': 'multipart/form-data'
//     };

    
//     var url = Uri.parse('${Config.baseUrl}${Config.createAutosUrl}');

//     var request = http.MultipartRequest('POST', url);
//     request.fields['title'] = 

//     var response = await client.post(
//       url,
//       headers: requestHeaders,
//       // body: jsonEncode(
//       //   {"phone": phone},
//       // ),
//     );

//     // if (jsonDecode(response.body)['success'] == true) {}
//     return autosModel(response.body);
//   }
// }
