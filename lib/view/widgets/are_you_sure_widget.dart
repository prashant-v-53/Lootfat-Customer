import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_user/utils/colors.dart';

onMenuClicked(
        {required String? title,
        required String? description,
        required Function() onTap,
        context}) =>
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: TextStyleExample(
          name: title!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        content: TextStyleExample(
          name: description!,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: TextStyleExample(
              name: 'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
            onPressed: () {
              finish(context);
            },
          ),
          CupertinoDialogAction(
              child: TextStyleExample(
                name: 'Logout',
                style: TextStyle(
                  color: AppColors.appColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              onPressed: onTap),
        ],
      ),
    );

class TextStyleExample extends StatelessWidget {
  const TextStyleExample({
    super.key,
    required this.name,
    required this.style,
  });

  final String name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(1.0),
      child: Text(name, style: style.copyWith(letterSpacing: 1.0)),
    );
  }
}

void finish(BuildContext context, [Object? result]) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context, result);
  }
}
