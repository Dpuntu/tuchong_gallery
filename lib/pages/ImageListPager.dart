import 'dart:convert' show json;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuchong/model/Banners.dart';
import 'package:tuchong/model/CategoryInfo.dart';
import 'package:tuchong/pages/CustomProgress.dart';
import 'package:tuchong/pages/DetailPager.dart';

class ImageListPager extends StatefulWidget {
  CategoryTitleInfo categoryInfo;
  bool isSupportScroll;

  ImageListPager({this.categoryInfo, this.isSupportScroll});

  @override
  State<StatefulWidget> createState() => ImageListState();
}

class ImageListState extends State<ImageListPager> {
  int limit = 10;
  int skip = 0;
  List<CategoryInfo> categoryInfos = [];
  GlobalKey _key = GlobalKey();
  ScrollController _controller = ScrollController();
  bool isScrollUp = false;

  ScrollPhysics _upScrollPhysics() {
    if (widget.isSupportScroll && !isScrollUp)
      return AlwaysScrollableScrollPhysics();
    else {
      isScrollUp = false;
      return NeverScrollableScrollPhysics();
    }
  }

  _getData() async {
    await http
        .get(
            "http://service.picasso.adesk.com/v1/vertical/category/${widget.categoryInfo.id}/vertical?limit=${limit}&skip=${skip}&order=hot")
        .then((response) {
      var jsonRes = json.decode(response.body);
      List<CategoryInfo> categories = [];
      categories.addAll(categoryInfos);
      categoryInfos.clear();
      for (var item in jsonRes['res']['vertical']) {
        categories.add(CategoryInfo.fromJson(item));
      }
      skip = categories.length;
      setState(() {
        isScrollUp = false;
        categoryInfos = categories;
        limit = 30;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _getData();
      }
    });
    _getData();
  }

  void itemClick(CategoryInfo categoryInfo) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return DetailPager(categoryInfo: categoryInfo);
    }));
  }

  Widget buildItem(BuildContext context, CategoryInfo categoryInfo) {
    return GestureDetector(
        child: CachedNetworkImage(
            placeholder: Center(child: CustomProgress(size: Size(50.0, 10.0))),
            imageUrl: categoryInfo.thumb,
            errorWidget: Icon(Icons.error),
            fit: BoxFit.cover),
        onTap: () {
          itemClick(categoryInfo);
        });
  }

  Widget buildList(BuildContext context) {
    if (categoryInfos != null && categoryInfos.isNotEmpty) {
      return GridView.count(
          key: _key,
          controller: _controller,
          physics: _upScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
          childAspectRatio: 1.0,
          children: categoryInfos.map((categoryInfo) {
            return buildItem(context, categoryInfo);
          }).toList());
    } else
      return Center();
  }

  @override
  Widget build(BuildContext context) => buildList(context);
}
