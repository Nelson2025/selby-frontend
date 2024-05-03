/*This is the My Ads Screen*/
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/models/product_model.dart';
import 'package:selby/presentation/product/product_details_screen.dart';
import 'package:selby/provider/products_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  String userId = '';
  getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString('userId').toString();
    setState(() {
      userId;
    });
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: FutureBuilder(
              future: provider.fetchAllProductByUserId(userId.toString()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                        autosId: cdata[index].sId!,
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
                                    decoration: const BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        "${Configuration.imageUrl}${cdata[index].image?[0]}",
                                        fit: BoxFit.cover,
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
                                          style: const TextStyle(
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
    // );
  }
}
