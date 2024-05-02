import 'package:http/http.dart' as http;
import 'package:selby/core/configuration.dart';
import 'package:selby/models/category_model.dart';

class CategoryApi {
  static var client = http.Client();

  static Future<CategoryModel> fetchAllCategories() async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.parse(
        '${Configuration.baseUrl}${Configuration.fetchAllCategoriesUrl}');

    var response = await client.post(
      url,
      headers: requestHeaders,
    );

    // if (jsonDecode(response.body)['success'] == true) {
    //   SharedPreferences preferences = await SharedPreferences.getInstance();

    //   await preferences.setString(
    //       'phone', jsonDecode(response.body)['data']['phone']);
    // }
    return categoryModel(response.body);
  }
}
