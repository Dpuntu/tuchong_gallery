import 'package:flutter/material.dart';
import 'package:tuchong/model/Banners.dart';

class PageSelector extends StatelessWidget {
  const PageSelector({this.banners});

  final List<BannerInfo> banners;

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);

    return SafeArea(
        top: false,
        bottom: false,
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: IconTheme(
                          data: IconThemeData(
                              color: Theme.of(context).accentColor),
                          child: TabBarView(
                              controller: controller,
                              children: banners.map((BannerInfo banner) {
                                return Container(
                                    child: Image.network(banner.src,
                                        fit: BoxFit.fill));
                              }).toList())))
                ],
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: TabPageSelector(
                      indicatorSize: 8.0, controller: controller)))
        ]));
  }
}
