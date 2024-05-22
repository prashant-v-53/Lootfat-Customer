import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lootfat_user/utils/colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? prefixIcon;
  final bool? icon;
  final String? keyValue;
  final String? hintText;
  final String? initialValue;
  final Widget? suffixIcon;
  final String? Function(String?)? validate;
  final Function(String)? onChange;
  final Function(String)? onSubmitted;
  final Function(String)? onFieldSubmitted;
  final bool obscureText;
  final bool border;
  final bool shadow;
  final TextInputType keyboardType;
  final int maxLines;
  final Color? color;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorMessage;
  final String? inputTitle;
  final bool readonly;
  final Function()? onTap;
  final double? radius;
  final double? contentPadding;
  final double? contentVerticalPadding;
  final bool isTitleText;
  final String titleText;

  const AppTextField({
    Key? key,
    this.keyValue = "1",
    this.hintText,
    this.initialValue,
    this.validate,
    this.onChange,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.color,
    this.border = false,
    this.shadow = false,
    this.prefixIcon,
    this.inputFormatters,
    this.controller,
    this.errorMessage,
    this.readonly = false,
    this.onTap,
    this.onSubmitted,
    this.radius,
    this.contentPadding = 10,
    this.icon = true,
    this.contentVerticalPadding = 0,
    this.titleText = "",
    this.isTitleText = false,
    this.inputTitle = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText.isNotEmpty
            ? Text(
                titleText,
                style: TextStyle(
                  color: AppColors.main,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )
            : SizedBox(),
        titleText.isNotEmpty ? SizedBox(height: 6) : SizedBox(),
        if (inputTitle!.isNotEmpty) inputTitleText(inputTitle),
        TextField(
          onTap: onTap,
          onSubmitted: onSubmitted,
          readOnly: readonly,
          controller: controller,
          onChanged: onChange,
          inputFormatters: inputFormatters,
          cursorColor: AppColors.main,
          obscureText: obscureText,
          maxLines: maxLines,
          style: const TextStyle(
            color: AppColors.main,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            // filled: true,
            // fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
                vertical: 16, horizontal: contentPadding ?? 10),
            labelStyle: const TextStyle(
              color: AppColors.main,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: prefixIcon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, bottom: 10, right: 10),
                        child: SvgPicture.asset(
                          prefixIcon!,
                          height: 15,
                          width: 15,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 22,
                        width: 2,
                        decoration: BoxDecoration(
                          color: AppColors.main.withOpacity(0.1),
                        ),
                      ),
                    ],
                  )
                : null,
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 13.0,
              color: AppColors.main,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 6),
              borderSide: BorderSide(color: AppColors.textLight, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textLight, width: 1),
              borderRadius: BorderRadius.circular(radius ?? 6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.appColor.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.circular(radius ?? 6),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textLight, width: 1),
              borderRadius: BorderRadius.circular(radius ?? 6),
            ),
          ),
        ),
        errorMessage!.isNotEmpty
            ? inputErrorMessage(errorMessage)
            : Container(),
      ],
    );
  }

  static inputTitleText(title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.main,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static inputErrorMessage(errorMessage) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 25,
        padding: EdgeInsets.only(top: 3),
        color: Colors.transparent,
        child: Text(
          errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
    );
  }
}
