import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/home/home_screen.dart';
import 'package:selby/presentation/home/user_feed_screen.dart';
import 'package:selby/presentation/widgets/primary_button.dart';
import 'package:selby/provider/csc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CscScreen extends StatefulWidget {
  const CscScreen({super.key});

  @override
  State<CscScreen> createState() => _CscScreenState();
}

class _CscScreenState extends State<CscScreen> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  void getLocation() async {
    try {
      await determinePosition();
    } catch (ex) {
      var status = await Permission.location.status;
      if (status.isDenied) {
        openAppSettings();
        //  ScaffoldMessenger.of(context)
        //   .showSnackBar(SnackBar(content: Text(ex.toString())));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(ex.toString())));
      }
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(ex.toString())));
    }
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.requestPermission();
      // return Future.error('Location services are disabled. Please enable.');
    }

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    // print(position);

    //return await Geolocator.getCurrentPosition();
    return getAddressFromLatLang(position);
  }

  Future<void> getAddressFromLatLang(Position position) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    await preferences.setString('latitude', position.latitude.toString());
    await preferences.setString('longitude', position.longitude.toString());
    await preferences.setString('city', place.locality.toString());
    await preferences.setString('state', place.administrativeArea.toString());
    await preferences.setString('pincode', place.postalCode.toString());
    await preferences.setString('country', place.country.toString());
    context.read<CscProvider>().changeCsc(
        newCity: place.locality.toString(),
        newState: place.administrativeArea.toString(),
        newCountry: place.country.toString());
    if (place.toString() != '') {
      // Navigator.pop(context, true);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CscProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.main,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/selby_logo.png',
              width: 100,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Different Location",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey.shade500),
            ),
            SizedBox(
              height: 20,
            ),
            CSCPicker(
              layout: Layout.vertical,
              flagState: CountryFlag.DISABLE,
              defaultCountry: CscCountry.India,
              onCountryChanged: (country) {
                setState(() {
                  countryValue = country.toString().replaceAll('ā', 'a');
                });
              },
              onStateChanged: (state) {
                setState(() {
                  stateValue = state.toString().replaceAll('ā', 'a');
                });
              },
              onCityChanged: (city) {
                cityValue = city.toString().replaceAll('ā', 'a');
              },
            ),
            SizedBox(
              height: 20,
            ),
            PrimaryButton(
              text: "Submit",
              onPressed: () async {
                // SharedPreferences preferences =
                //     await SharedPreferences.getInstance();
                print(cityValue);
                context.read<CscProvider>().changeCsc(
                    newCity: cityValue,
                    newState: stateValue,
                    newCountry: countryValue);
                // await preferences.setString('city', cityValue.toString());
                // await preferences.setString('state', stateValue.toString());
                // await preferences.setString('country', countryValue.toString());
                // Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
              },
            ),
            SizedBox(
              height: 20,
            ),
            const Center(
              child: Text("- OR -"),
            ),
            SizedBox(
              height: 20,
            ),
            PrimaryButton(
              text: "Current Location",
              onPressed: () {
                getLocation();
              },
            ),
          ],
        ),
      ),
    );
  }
}
