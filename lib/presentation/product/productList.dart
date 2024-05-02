// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';

import 'package:selby/core/ui.dart';
import 'package:selby/models/product_model.dart';
import 'package:selby/presentation/category/select_category_screen.dart';
import 'package:selby/presentation/product/autos_details_screen.dart';
import 'package:selby/presentation/product/productSubCategory.dart';
import 'package:selby/presentation/widgets/autos_widget.dart';
import 'package:selby/presentation/widgets/categories_list.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:selby/presentation/widgets/rent_car_banner.dart';
import 'package:selby/presentation/widgets/stories_widget.dart';
import 'package:selby/provider/autos_provider.dart';

class ProductList extends StatefulWidget {
  final String categoryId;
  final String subcategoryId;
  const ProductList({
    Key? key,
    required this.categoryId,
    required this.subcategoryId,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AutosProvider>(context, listen: false);
    // provider.fetchAllAutos();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.main,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/selby_logo.png',
              width: 100,
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Ionicons.notifications_outline,
              color: AppColors.white,
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Ionicons.search_outline,
          //     color: AppColors.white,
          //   ),
          // ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: FutureBuilder(
              future: provider.fetchProductByCategoryId(
                  widget.categoryId, widget.subcategoryId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<ProductModel> cdata = snapshot.data;

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.28,
                    ),
                    itemCount: cdata.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () => {
                          // if (cdata[index].title == 'Autos')
                          //   {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AutosDetailsScreen(
                                        autosId: cdata[index].sId!,
                                      )))
                          //   }
                          // else
                          //   {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => AutosDetailsScreen(
                          //                   autosId: cdata[index].sId!,
                          //                 )))
                          //   }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.width * 0.4,
                                    // alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        "${Configuration.imageUrl}${cdata[index].image?[0]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(2, 2),
                                              color: Colors.grey,
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Ionicons.heart_outline,
                                          color: AppColors.main,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                child: Row(
                                  children: [
                                    Badge(
                                      backgroundColor: Colors.grey,
                                      largeSize: 22,
                                      label: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "${cdata[index].categoryId['title']}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${cdata[index].title}",
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "₹${cdata[index].price}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Ionicons.location_outline,
                                      size: 13,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${cdata[index].city}",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              })),
    );
  }
}
