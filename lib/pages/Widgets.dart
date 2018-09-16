import 'package:flutter/material.dart';
import 'package:tuchong/model/Banners.dart';

const double kSectionIndicatorWidth = 32.0;

class CategoryCard extends StatelessWidget {
  CategoryCard({Key key, @required this.categoryTitleInfo})
      : assert(categoryTitleInfo != null),
        super(key: key);

  final CategoryTitleInfo categoryTitleInfo;

  @override
  Widget build(BuildContext context) {
    return Semantics(
        label: categoryTitleInfo.rName,
        button: true,
        child: Image.network(categoryTitleInfo.cover,
            colorBlendMode: BlendMode.modulate, fit: BoxFit.cover));
  }
}

class CategoryTitle extends StatelessWidget {
  static TextStyle sectionTitleStyle = TextStyle(
      fontFamily: 'Raleway',
      inherit: false,
      fontSize: 16.0,
      fontWeight: FontWeight.w300,
      color: Colors.white,
      textBaseline: TextBaseline.alphabetic);

  CategoryTitle({
    Key key,
    @required this.category,
    @required this.scale,
    @required this.opacity,
  })  : assert(category != null),
        assert(scale != null),
        assert(opacity != null && opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  final CategoryTitleInfo category;
  final double scale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        child: Opacity(
            opacity: opacity,
            child: Transform(
                transform: Matrix4.identity()..scale(scale),
                alignment: Alignment.center,
                child: Text(category.rName, style: sectionTitleStyle))));
  }
}

class CategoryIndicator extends StatelessWidget {
  CategoryIndicator({Key key, this.opacity = 1.0}) : super(key: key);

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        child: Container(
            width: kSectionIndicatorWidth,
            height: 1.0,
            color: Colors.white.withOpacity(opacity)));
  }
}
