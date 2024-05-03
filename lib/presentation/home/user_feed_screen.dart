/*This is the User Feed Screen*/
import 'package:flutter/material.dart';
import 'package:selby/presentation/widgets/product_widget.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({super.key});

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProductWidget(),
    );
  }
}
