import 'package:flutter/cupertino.dart';
import 'package:selby/core/ui.dart';

class LinkButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  const LinkButton(
      {super.key,
      required this.text,
      this.onPressed,
      this.color,
      this.fontSize,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Text(
        text,
        style: TextStyle(
            color: color ?? AppColors.main,
            fontSize: fontSize,
            fontWeight: fontWeight),
      ),
    );
  }
}
