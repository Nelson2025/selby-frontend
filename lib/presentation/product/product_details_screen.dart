/* This is Product Details Screen*/
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/models/product_model.dart';
import 'package:selby/presentation/chat/individual_chat_screen.dart';
import 'package:selby/provider/msg_provider.dart';
import 'package:selby/provider/products_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String autosId;

  const ProductDetailsScreen({super.key, required this.autosId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? userId;
  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.get('userId').toString();
  }

  @override
  void initState() {
    getUserId();
    setState(() {
      userId;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,000');
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: AppColors.main,
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
          ],
        ),
        body: FutureBuilder(
            future: provider.fetchProductById(widget.autosId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<ProductModel> cdata = snapshot.data;
                final List<String> images = [];
                final List flist = [];
                for (var items in cdata[0].image!) {
                  images.add('${Configuration.imageUrl}$items');
                }

                for (var items in cdata[0].features!) {
                  flist.add('$items');
                }

                return ListView.builder(
                    itemCount: cdata.length,
                    itemBuilder: (BuildContext context, index) {
                      return Stack(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Stack(children: <Widget>[
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: 320.0,
                                      viewportFraction: 1.0,
                                      enableInfiniteScroll: false,
                                    ),
                                    items: images.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 320,
                                            child: Image.network(
                                              i,
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 320,
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  Container(
                                    height: 110.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        gradient: LinearGradient(
                                            begin: FractionalOffset.topCenter,
                                            end: FractionalOffset.bottomCenter,
                                            colors: [
                                              AppColors.main.withOpacity(0.3),
                                              Colors.grey.withOpacity(0.1),
                                            ],
                                            stops: const [
                                              0.01,
                                              1.0
                                            ])),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 15, 0),
                                    child: SizedBox(
                                      height: 120.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Ionicons.share_social,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 10, 0),
                                        child: Text(
                                          '\u{20B9} ${formatter.format(int.parse(cdata[index].price.toString()))}',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 48, 52, 1),
                                              letterSpacing: .1,
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 15, 5, 0),
                                        child: Text(
                                            "${cdata[index].title}"
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 48, 52, 1),
                                                letterSpacing: .1,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 5, 10),
                                        child: Text(
                                            "${cdata[index].description}",
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 48, 52, 1),
                                                letterSpacing: .1,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 3, 5, 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Details",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 48, 52, 1),
                                                    letterSpacing: .1,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            for (var i in flist)
                                              Text(
                                                "$i",
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 48, 52, 1),
                                                    letterSpacing: .1,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 10),
                                      ),
                                    ],
                                  ),
                                ),
                                if (userId != cdata[0].userId)
                                  MaterialButton(
                                    onPressed: () async {
                                      final msgProv =
                                          Provider.of<MessageProvider>(context,
                                              listen: false);

                                      await msgProv.getRoomId(
                                          clientModel:
                                              cdata[index].userId.toString(),
                                          myModel: userId,
                                          productId: widget.autosId);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IndividualChatScreen(
                                                      productId: cdata[index]
                                                          .sId
                                                          .toString(),
                                                      userId: userId.toString(),
                                                      receiver: cdata[index]
                                                          .userId
                                                          .toString())));
                                    },
                                    child: const Text("Chat"),
                                  ),
                              ],
                            ),
                          )
                        ],
                      );
                    });
              }
            }));
  }
}
