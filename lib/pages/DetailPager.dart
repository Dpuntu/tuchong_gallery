import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tuchong/model/CategoryInfo.dart';
import 'package:tuchong/pages/CustomProgress.dart';

class DetailPager extends StatefulWidget {
  CategoryInfo categoryInfo;

  DetailPager({this.categoryInfo});

  @override
  State<StatefulWidget> createState() {
    return DetailPagerState();
  }
}

class DetailPagerState extends State<DetailPager> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        body: Container(
            height: mediaQueryData.size.height + mediaQueryData.padding.top,
            child: CachedNetworkImage(
                placeholder:
                    Center(child: CustomProgress(size: Size(40.0, 8.0))),
                imageUrl: widget.categoryInfo.img,
                errorWidget: Icon(Icons.error),
                fit: BoxFit.fill)));
  }
}
