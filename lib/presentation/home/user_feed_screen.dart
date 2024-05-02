import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/category/select_category_screen.dart';
import 'package:selby/presentation/widgets/autos_widget.dart';
import 'package:selby/presentation/widgets/categories_list.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:selby/presentation/widgets/rent_car_banner.dart';
import 'package:selby/presentation/widgets/stories_widget.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({super.key});

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
          // ListView(
          //   children: [
          //     // const GapWidget(),
          //     StoriesWidget(),
          //     CategoriesList(),
          //     const GapWidget(),
          //     // RentCarBanner(),
          //     const GapWidget(),
          AutosWidget(),
      //   ],
      // ),
    );
  }
}
