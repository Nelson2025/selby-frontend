/* This widget shows list of all products according to location in the home screen*/
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/models/product_model.dart';
import 'package:selby/presentation/product/product_details_screen.dart';
import 'package:selby/presentation/widgets/categories_list.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:selby/presentation/widgets/rent_car_banner.dart';
import 'package:selby/presentation/widgets/stories_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:selby/provider/csc_provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final ScrollController scrollController = ScrollController();

  List<ProductModel> products = [];
  int totalProducts = 100000;
  String city = '';

  bool isLoading = false;
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
    ),
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      city = Provider.of<CscProvider>(context, listen: false).city.toString();
    });
    getProducts();
    scrollController.addListener(loadMoreData);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getProducts,
      child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: scrollController,
          children: [
            const StoriesWidget(),
            const CategoriesList(),
            const GapWidget(),
            const RentCarBanner(),
            const GapWidget(),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.28,
                      childAspectRatio: 2),
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                      autosId: products[index].sId!,
                                    )))
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
                                  decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      cacheManager: instance,
                                      key: UniqueKey(),
                                      imageUrl:
                                          "${Configuration.imageUrl}${products[index].image?[0]}",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey.shade400,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.grey.shade400,
                                        child: const Icon(
                                            Ionicons.alert_circle_outline),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Row(
                                children: [
                                  Badge(
                                    backgroundColor: Colors.grey,
                                    largeSize: 22,
                                    label: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        "${products[index].categoryId['title']}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis),
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
                                      "${products[index].title}",
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "₹${products[index].price}",
                                    style: const TextStyle(
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
                                  const Icon(
                                    Ionicons.location_outline,
                                    size: 13,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${products[index].city}, ${products[index].state}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis),
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
                )),
            isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : const Text(''),
            const GapWidget(),
          ]),
    );
  }

  void loadMoreData() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        products.length < totalProducts) {
      getProducts();
    }
  }

  Future<void> getProducts() async {
    const limit = 6;

    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchAllProductsUrl}/$limit/${products.length}/$city'),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        result['data']?.forEach((value) => {
              // if (!products.contains(value))
              products.add(
                ProductModel(
                  sId: value['_id'],
                  categoryId: value['categoryId'],
                  userId: value['userId'],
                  title: value['title'],
                  description: value['description'],
                  price: value['price'],
                  image: value['image'],
                  city: value['city'],
                  state: value['state'],
                  updatedOn: value['updatedOn'],
                  createdOn: value['createdOn'],
                ),
              ),
            });

        setState(() {
          isLoading = false;
          totalProducts = result['totalRecords'];
          products;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
