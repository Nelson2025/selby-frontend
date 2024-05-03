/* This is Categories Widget*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/models/category_model.dart';
import 'package:selby/presentation/product/productList.dart';
import 'package:selby/presentation/product/productSubCategory.dart';
import 'package:selby/provider/category_provider.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    const double defaultPadding = 1.0;
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 4,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black12,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 84,
            child: FutureBuilder(
                future: provider.fetchAllCategories(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<CategoryModel> cdata = snapshot.data;
                    return ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: cdata.length,
                      itemBuilder: (context, index) => CategoryCard(
                        icon: cdata[index].image.toString(),
                        title: cdata[index].title.toString(),
                        press: () {
                          if (cdata[index].title == 'Autos' ||
                              cdata[index].title == 'Books' ||
                              cdata[index].title == 'Rent Car' ||
                              cdata[index].title == 'Arts & Crafts') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductList(
                                        subcategoryId: '',
                                        categoryId:
                                            cdata[index].sId.toString())));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductSubCategory(
                                          category: cdata[index],
                                        )));
                          }
                        },
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: defaultPadding),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.press,
  }) : super(key: key);

  static const double defaultBorderRadius = 20.0;
  static const double defaultPadding = 16.0;
  final String icon, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.transparent),
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: defaultPadding / 2, horizontal: defaultPadding / 4),
        child: Column(
          children: [
            Opacity(
              opacity: 0.8,
              child: CachedNetworkImage(
                imageUrl: Configuration.imageUrl + icon,
                height: 40,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
