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

  // late StreamSubscription<Position> streamSubscription;
  // void getLocation() async {
  //   LocationPermission permission;
  //   permission = await Geolocator.checkPermission();
  //   permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     //nothing
  //   }
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.low);
  //   if (position != null) {
  //     print(position);
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("services disabled")));
  //   }
  // }

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
            // ElevatedButton(
            //     onPressed: () async {
            //       try {
            //         await determinePosition();
            //       } catch (ex) {
            //         var status = await Permission.location.status;
            //         if (status.isDenied) {
            //           openAppSettings();
            //           //  ScaffoldMessenger.of(context)
            //           //   .showSnackBar(SnackBar(content: Text(ex.toString())));
            //         } else {
            //           ScaffoldMessenger.of(context)
            //               .showSnackBar(SnackBar(content: Text(ex.toString())));
            //         }
            //         // ScaffoldMessenger.of(context)
            //         //     .showSnackBar(SnackBar(content: Text(ex.toString())));
            //       }
            //     },
            // child: Text("getLocation"))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Ionicons.location_outline,
                  color: AppColors.main,
                  size: 25,
                ),
                SizedBox(
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
            SizedBox(
              height: 20,
            ),
            // TextField(
            //   controller: latitude,
            // ),
            // SizedBox(
            //   height: 6,
            // ),
            // TextField(
            //   controller: longitude,
            // ),
            // SizedBox(
            //   height: 6,
            // ),
            // TextField(
            //   controller: address,
            // ),
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
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // streamSubscription.cancel();
  }

  // getLocation() async {
  //   bool serviceEnabled;

  //   LocationPermission permission;
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     await Geolocator.openLocationSettings();
  //     return Future.error('Location services are disabled.');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   streamSubscription =
  //       Geolocator.getPositionStream().listen((Position position) {
  //     latitude.text = 'Latitude : ${position.latitude}';
  //     longitude.text = 'Longitude : ${position.longitude}';
  //     getAddressFromLatLang(position);
  //   });
  // }

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
    // provider.city = place.locality.toString().replaceAll('a', 'ā');
    provider.city = place.locality.toString();
    provider.state = place.administrativeArea.toString();
    provider.country = place.country.toString();
    if (place.toString() != '') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }
  }
}
