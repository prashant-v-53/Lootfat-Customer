import 'package:flutter/material.dart';

typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final double? size;
  final bool border;

  const StarRating({
    Key? key,
    this.starCount = 5,
    this.rating = .0,
    required this.onRatingChanged,
    required this.color,
    this.size,
    this.border = false,
  }) : super(key: key);

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(border ? Icons.star_border_outlined : Icons.star,
          size: size ?? 16, color: Colors.black.withOpacity(0.3));
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        size: size ?? 16,
        color: Color(0xffFFB427),
      );
    } else {
      icon = Icon(
        Icons.star,
        size: size ?? 16,
        color: Color(0xffFFB427),
      );
    }
    return InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children:
            List.generate(starCount, (index) => buildStar(context, index)));
  }
}
