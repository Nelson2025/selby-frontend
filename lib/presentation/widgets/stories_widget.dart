// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/models/product_model.dart';
import 'package:selby/provider/csc_provider.dart';
import 'package:story_view/story_view.dart';
import 'package:http/http.dart' as http;
import 'package:selby/core/configuration.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/models/autos_model.dart';
import 'package:selby/presentation/product/autos_details_screen.dart';
import 'package:selby/provider/autos_provider.dart';

class StoriesWidget extends StatefulWidget {
  StoriesWidget({super.key});

  @override
  State<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  final StoryController controller = StoryController();

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
    // TODO: implement initState
    super.initState();
    setState(() {
      city = Provider.of<CscProvider>(context, listen: false).city.toString();
    });
    getProducts();
    scrollController.addListener(loadMoreData);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AutosProvider>(context, listen: false);
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Container(
          //     height: 135,
          //     width: double.infinity,
          //     child: Stories(),
          //   ),
          // ),
          // Divider(
          //   color: Colors.black12,
          // ),
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stories",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black12,
                      fontWeight: FontWeight.w900),
                ),
                // Row(
                //   children: <Widget>[
                //     Icon(
                //       Ionicons.eye_outline,
                //       color: AppColors.main,
                //       size: 18,
                //     ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     Text("See All",
                //         style: TextStyle(
                //             fontWeight: FontWeight.w500,
                //             fontSize: 12,
                //             color: AppColors.main))
                //   ],
                // )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 84,
              child:
                  // FutureBuilder(
                  //     future: provider.fetchAllAutos(),
                  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //       if (!snapshot.hasData) {
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       } else {
                  //         List<AutosModel> products = snapshot.data;

                  // print("${Config.imageUrl}${products[0].image}");

                  ListView.separated(
                itemCount: products.length <= 50 ? products.length : 50,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (context, index) => Material(
                  child: InkWell(
                    onTap: () {
                      final List<String> images = [];
                      for (var items in products[index].image!) {
                        images.add('${Configuration.imageUrl}$items');
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MoreStories(
                                images: images,
                                title: products[index].title.toString(),
                                productId: products[index].sId.toString(),
                              )));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.width / 5,
                            imageUrl:
                                '${Configuration.imageUrl}${products[index].image!.first.toString()}',
                            imageBuilder: (context, imageProvider) => Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.main, width: 2),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),

                        // CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //       '${Config.imageUrl}${products[index].image!.first.toString()}'),
                        // ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(width: 10),

                // children: <Widget>[
                //   Material(
                //     child: InkWell(
                //       onTap: () {
                //         Navigator.of(context).push(MaterialPageRoute(
                //             builder: (context) => MoreStories(
                //                   image:
                //                       "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                //                 )));
                //       },
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //           CircleAvatar(
                //             backgroundColor: Colors.purple,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ],
              ),
              //   }
              // }
              // ),
            ),
          ),
        ],
      ),
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
            '${Configuration.baseUrl}${Configuration.fetchAllAutosUrl}/$limit/${products.length}/$city'),
      );
      // print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        // print(result);
        //print(result['totalRecords']);
        result['data']?.forEach((value) => {
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
        //return autos;
      }
    } catch (e) {
      print(e);
    }
  }
}

class MoreStories extends StatefulWidget {
  List<String> images;
  String title;
  String productId;
  MoreStories({
    Key? key,
    required this.images,
    required this.title,
    required this.productId,
  }) : super(key: key);

  List<StoryItem> img = [];

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();
  // List<StoryItem> quotes = [
  //   //"Quote" is the the name of the class of the second dart file.

  //   "2",
  //   "3",
  // ];
  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  for (var items in widget.images) {
    //                     widget.img.add('${Config.imageUrl}$items');
    //                   }
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AutosDetailsScreen(
                        autosId: widget.productId,
                      )),
            )
          },
          child: Text(
            "Click Here to View",
            style: TextStyle(
                fontSize: 15,
                color: AppColors.main,
                overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      body: StoryView(
        storyItems: [
          for (var img in widget.images)
            StoryItem.pageImage(
              url: img,
              caption: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              controller: storyController,
            ),
        ],
        onStoryShow: (storyItem, index) {},
        onComplete: () {
          Navigator.pop(context);
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
