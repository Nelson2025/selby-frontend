// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CscProvider extends ChangeNotifier {
  String? city;
  String? state;
  String? country;

  CscProvider({
    this.city,
    this.state,
    this.country,
  });

  void changeCsc({
    required String newCity,
    required String newState,
    required String newCountry,
  }) async {
    city = newCity;
    state = newState;
    country = newCountry;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('city', city.toString().replaceAll('ā', 'a'));
    await preferences.setString('state', state.toString().replaceAll('ā', 'a'));
    await preferences.setString(
        'country', country.toString().replaceAll('ā', 'a'));
    notifyListeners();
  }
}
