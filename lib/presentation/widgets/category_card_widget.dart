import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';

class CategoryCard extends StatelessWidget {
  final String? image;
  final String? title;
  const CategoryCard({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Column(
        children: [
          CachedNetworkImage(
              width: MediaQuery.of(context).size.width / 3, imageUrl: image!),
          const GapWidget(),
          Text(
            title!,
            style: TextStyle(color: AppColors.main, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
