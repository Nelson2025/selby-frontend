/*This is the Select Category Screen*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/models/category_model.dart';
import 'package:selby/presentation/category/select_subcategories.dart';
import 'package:selby/presentation/product/autos/add_autos_screen.dart';
import 'package:selby/presentation/product/electronics/add_for_electronics.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:selby/provider/category_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
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
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: provider.fetchAllCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<CategoryModel> cdata = snapshot.data;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 0, crossAxisSpacing: 0),
              itemCount: cdata.length,
              itemBuilder: (context, index) {
                return MaterialButton(
                  onPressed: () {
                    if (cdata[index].title == 'Autos') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAutosScreen(
                                    city: city,
                                    state: state,
                                    country: country,
                                    category: cdata[index],
                                    subcategory: '',
                                  )));
                    } else if (cdata[index].title == 'Books' ||
                        cdata[index].title == 'Rent Car' ||
                        cdata[index].title == 'Arts & Crafts') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddForElectronicsScreen(
                                    city: city,
                                    state: state,
                                    country: country,
                                    category: cdata[index],
                                    subcategory: '',
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectSubcategories(
                                    category: cdata[index],
                                  )));
                    }
                  },
                  child: Column(children: [
                    CachedNetworkImage(
                      imageUrl:
                          "${Configuration.imageUrl}${cdata[index].image}",
                    ),
                    const GapWidget(),
                    Text(
                      "${cdata[index].title}",
                      style: TextStyle(color: AppColors.main, fontSize: 14),
                    )
                  ]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
