import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuchong/model/Banners.dart';
import 'package:tuchong/pages/Category.dart';
import 'package:tuchong/pages/PageSelector.dart';

class HomePager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePagerState();
  }
}

class HomePagerState extends State<HomePager> {
  BannerBean bannerBean = BannerBean([], []);

  _postData() async {
    List<BannerInfo> banners = [];
    List<CategoryTitleInfo> categories = [];

    await http.get("https://api.tuchong.com/discover-app").then((tuchong) {
      var tuchongRes = json.decode(tuchong.body);
      for (var item in tuchongRes['banners']) {
        banners.add(BannerInfo.fromJson(item));
      }
      http
          .get("http://service.picasso.adesk.com/v1/vertical/category")
          .then((picasso) {
        var picassoRes = json.decode(picasso.body);
        for (var item in picassoRes['res']['category']) {
          categories.add(CategoryTitleInfo.fromJson(item));
        }

        setState(() {
          bannerBean = BannerBean(banners, categories);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _postData();
  }

  Widget buildAnimation() {
    if (bannerBean.banners != null &&
        bannerBean.categoryTitleInfos != null &&
        bannerBean.banners.isNotEmpty &&
        bannerBean.categoryTitleInfos.isNotEmpty)
      return AnimationDemoHome(bannerBean: bannerBean);
    else
      return Center();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildAnimation());
  }
}
