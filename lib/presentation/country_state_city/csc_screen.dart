/*This is the Change Location Screen*/
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/home/home_screen.dart';
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
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(ex.toString())));
      }
    }
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.requestPermission();
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
    // ignore: use_build_context_synchronously
    context.read<CscProvider>().changeCsc(
        newCity: place.locality.toString(),
        newState: place.administrativeArea.toString(),
        newCountry: place.country.toString());
    if (place.toString() != '') {
      Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(
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
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              text: "Submit",
              onPressed: () async {
                context.read<CscProvider>().changeCsc(
                    newCity: cityValue,
                    newState: stateValue,
                    newCountry: countryValue);

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text("- OR -"),
            ),
            const SizedBox(
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
