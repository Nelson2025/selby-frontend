import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/product/add_for_sale_houses_apartments_screen.dart';
import 'package:selby/presentation/product/productList.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductSubCategory extends StatefulWidget {
  final dynamic category;
  const ProductSubCategory({super.key, this.category});

  @override
  State<ProductSubCategory> createState() => _ProductSubCategoryState();
}

class _ProductSubCategoryState extends State<ProductSubCategory> {
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
    print(widget.category);
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
              if (widget.category.subcategories[index] != '') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductList(
                            subcategoryId: widget.category.subcategories[index],
                            categoryId: widget.category.sId.toString())));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => AddForSaleHousesApartmentsScreen(
                //               city: city,
                //               state: state,
                //               country: country,
                //               category: widget.category,
                //               subcategory: widget.category.subcategories[index],
                //             )));
              }
            },
            leading: Text(
              "${widget.category.subcategories[index]}" + city,
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
