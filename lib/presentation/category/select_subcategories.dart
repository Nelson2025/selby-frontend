import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/product/add_for_sale_houses_apartments_screen.dart';
import 'package:selby/presentation/product/electronics/add_for_electronics.dart';
import 'package:selby/presentation/product/mobiles/add_for_accessories.dart';
import 'package:selby/presentation/product/mobiles/add_for_mobile_phones.dart';
import 'package:selby/presentation/product/mobiles/add_for_tablets.dart';
import 'package:selby/presentation/product/motorcycles/add_for_bicycles.dart';
import 'package:selby/presentation/product/motorcycles/add_for_motorcycles.dart';
import 'package:selby/presentation/product/motorcycles/add_for_scooters.dart';
import 'package:selby/presentation/product/motorcycles/add_for_spareparts.dart';
import 'package:selby/presentation/product/properties/add_for_land_plots.dart';
import 'package:selby/presentation/product/properties/add_for_pg_guesthouses.dart';
import 'package:selby/presentation/product/properties/add_for_rent_houses_Apartments.dart';
import 'package:selby/presentation/product/properties/add_for_rent_shops_offices.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectSubcategories extends StatefulWidget {
  final dynamic category;
  const SelectSubcategories({super.key, this.category});

  @override
  State<SelectSubcategories> createState() => _SelectSubcategoriesState();
}

class _SelectSubcategoriesState extends State<SelectSubcategories> {
  String city = '';
  String state = '';
  String country = '';
  String pincode = '';
  getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    city = preferences.getString('city').toString();
    state = preferences.getString('state').toString();
    country = preferences.getString('country').toString();
    pincode = preferences.getString('pincode').toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    setState(() {
      city;
      state;
      country;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category.title}"),
      ),
      body: Container(
          child: ListView.builder(
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2, mainAxisSpacing: 0, crossAxisSpacing: 0),
        itemCount: widget.category.subcategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              if (widget.category.subcategories[index] ==
                  'For Sale: Houses & Apartments') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForSaleHousesApartmentsScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] ==
                  'For Rent: Houses & Apartments') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForRentHousesApartmentsScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] == 'Lands & Plots') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForLandPlotsScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if ((widget.category.subcategories[index] ==
                      "For Rent: Shops & Offices") ||
                  (widget.category.subcategories[index] ==
                      "For Sale: Shops & Offices")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForRentShopsOfficesScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] == "PG & Guest Houses") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForPgGuestHousesScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] == "Mobile Phones") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForMobilePhonesScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] == "Accessories") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForAccessoriesScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] == "Tablets") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForTabletsScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] == "Motorcycles") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForMotorcyclesScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] == "Scooters") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForScootersScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] == "Spare Parts") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForSparepartsScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if (widget.category.subcategories[index] == "Bicycles") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForBicyclesScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
              if ((widget.category.subcategories[index] ==
                      "TVs, Video - Audio") ||
                  (widget.category.subcategories[index] ==
                      "Kitchen & Other Appliances") ||
                  (widget.category.subcategories[index] ==
                      "Computers & Laptops") ||
                  (widget.category.subcategories[index] ==
                      "Cameras & Lenses") ||
                  (widget.category.subcategories[index] ==
                      "Games & Entertainment") ||
                  (widget.category.subcategories[index] == "Fridges") ||
                  (widget.category.subcategories[index] ==
                      "Computer Accessories") ||
                  (widget.category.subcategories[index] ==
                      "Hard Disks, Printers & Monitors") ||
                  (widget.category.subcategories[index] == "ACs") ||
                  (widget.category.subcategories[index] ==
                      "Washing Machines") ||
                  (widget.category.subcategories[index] == "Sofa & Dining") ||
                  (widget.category.subcategories[index] ==
                      "Beds & Wardrobes") ||
                  (widget.category.subcategories[index] ==
                      "Home Decor & Garden") ||
                  (widget.category.subcategories[index] == "Kids Furniture") ||
                  (widget.category.subcategories[index] ==
                      "Other Household Items") ||
                  (widget.category.subcategories[index] == "Shoes") ||
                  (widget.category.subcategories[index] == "Clothing")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddForElectronicsScreen(
                              city: city,
                              state: state,
                              country: country,
                              category: widget.category,
                              subcategory: widget.category.subcategories[index],
                            )));
              }
            },
            leading: Text(
              "${widget.category.subcategories[index]}",
              style: TextStyle(color: AppColors.main, fontSize: 14),
            ),
            trailing: Icon(Ionicons.arrow_forward_circle),
          );
          // final category = provider.categories[index];
        },
      )),
    );
  }
}
