/* This is Primary Button Widget*/
import 'package:flutter/cupertino.dart';
import 'package:selby/core/ui.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;

  const PrimaryButton(
      {super.key, required this.text, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 16),
        onPressed: onPressed,
        color: color ?? AppColors.main,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
