/* This is Rent Car Banner Widget*/
import 'package:flutter/material.dart';

class RentCarBanner extends StatefulWidget {
  const RentCarBanner({super.key});

  @override
  State<RentCarBanner> createState() => _RentCarBannerState();
}

class _RentCarBannerState extends State<RentCarBanner> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/rent-car-banner.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.9), BlendMode.dstATop),
            ),
            border: Border.all(color: Colors.transparent, width: 0.4),
            borderRadius: BorderRadius.circular(10)),
        height: 110,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    "Want to Rent a Car",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const Text(
                    "Selby presents",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 26,
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.yellow, Colors.amber.shade800],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: MaterialButton(
                      onPressed: () {},
                      height: 26,
                      elevation: 4,
                      child: const Text(
                        "Rent Car",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
