/*This is the Initial Enable location Screen*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/home/home_screen.dart';
import 'package:selby/presentation/widgets/primary_button.dart';
import 'package:selby/provider/csc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  static const routeName = "locationScreen";

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController latitude = TextEditingController();
  final TextEditingController longitude = TextEditingController();
  final TextEditingController address = TextEditingController();

  void getLocation() async {
    try {
      await determinePosition();
    } catch (ex) {
      var status = await Permission.location.status;
      if (status.isDenied) {
        openAppSettings();
      } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.main,
        automaticallyImplyLeading: false,
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
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Ionicons.location_outline,
                  color: AppColors.main,
                  size: 25,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'User Location',
                  style: TextStyle(
                      color: AppColors.main,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              text: "Enable Location",
              onPressed: () => getLocation(),
            )
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAddressFromLatLang(Position position) async {
    final provider = Provider.of<CscProvider>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    latitude.text = position.latitude.toString();
    longitude.text = position.longitude.toString();
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address.text =
        'Address : ${place.locality},${place.administrativeArea},${place.postalCode},${place.country}';
    await preferences.setString('latitude', position.latitude.toString());
    await preferences.setString('longitude', position.longitude.toString());
    await preferences.setString('city', place.locality.toString());
    await preferences.setString('state', place.administrativeArea.toString());
    await preferences.setString('pincode', place.postalCode.toString());
    await preferences.setString('country', place.country.toString());
    provider.city = place.locality.toString();
    provider.state = place.administrativeArea.toString();
    provider.country = place.country.toString();
    if (place.toString() != '') {
      Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }
  }
}
