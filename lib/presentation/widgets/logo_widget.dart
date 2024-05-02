import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final dynamic size;
  const LogoWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/selby_logo_color.png',
      width: MediaQuery.of(context).size.width / size,
    );
  }
}
