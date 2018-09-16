// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Based on https://material.uplabs.com/posts/google-newsstand-navigation-pattern
// See also: https://material-motion.github.io/material-motion/documentation/

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tuchong/model/Banners.dart';
import 'package:tuchong/pages/ImageListPager.dart';
import 'package:tuchong/pages/PageSelector.dart';
import 'package:tuchong/pages/Widgets.dart';

const Color _kAppBackgroundColor = Color(0xFF353662);
const Duration _kScrollDuration = Duration(milliseconds: 400);
const Curve _kScrollCurve = Curves.fastOutSlowIn;

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _AllSectionsLayout extends MultiChildLayoutDelegate {
  _AllSectionsLayout({
    this.translation,
    this.tColumnToRow,
    this.tCollapsed,
    this.cardCount,
    this.selectedIndex,
  });

  final Alignment translation;
  final double tColumnToRow;
  final double tCollapsed;
  final int cardCount;
  final double selectedIndex;

  Rect _interpolateRect(Rect begin, Rect end) {
    return Rect.lerp(begin, end, tColumnToRow);
  }

  Offset _interpolatePoint(Offset begin, Offset end) {
    return Offset.lerp(begin, end, tColumnToRow);
  }

  @override
  void performLayout(Size size) {
    final double columnCardX = size.width / 5.0;
    final double columnCardWidth = size.width - columnCardX;
    final double columnCardHeight = size.height / cardCount;
    final double rowCardWidth = size.width;
    final Offset offset = translation.alongSize(size);
    double columnCardY = 0.0;
    double rowCardX = -(selectedIndex * rowCardWidth);
    final double columnTitleX = size.width / 10.0;
    final double rowTitleWidth = size.width * ((1 + tCollapsed) / 2.25);
    double rowTitleX =
        (size.width - rowTitleWidth) / 2.0 - selectedIndex * rowTitleWidth;
    const double paddedSectionIndicatorWidth = kSectionIndicatorWidth + 8.0;
    final double rowIndicatorWidth = paddedSectionIndicatorWidth +
        (1.0 - tCollapsed) * (rowTitleWidth - paddedSectionIndicatorWidth);
    double rowIndicatorX = (size.width - rowIndicatorWidth) / 2.0 -
        selectedIndex * rowIndicatorWidth;
    for (int index = 0; index < cardCount; index++) {
      // Layout the card for index.
      final Rect columnCardRect = new Rect.fromLTWH(
          columnCardX, columnCardY, columnCardWidth, columnCardHeight);
      final Rect rowCardRect =
          new Rect.fromLTWH(rowCardX, 0.0, rowCardWidth, size.height);
      final Rect cardRect =
          _interpolateRect(columnCardRect, rowCardRect).shift(offset);
      final String cardId = 'card$index';
      if (hasChild(cardId)) {
        layoutChild(cardId, new BoxConstraints.tight(cardRect.size));
        positionChild(cardId, cardRect.topLeft);
      }

      // Layout the title for index.
      final Size titleSize =
          layoutChild('title$index', new BoxConstraints.loose(cardRect.size));
      final double columnTitleY =
          columnCardRect.centerLeft.dy - titleSize.height / 2.0;
      final double rowTitleY =
          rowCardRect.centerLeft.dy - titleSize.height / 2.0;
      final double centeredRowTitleX =
          rowTitleX + (rowTitleWidth - titleSize.width) / 2.0;
      final Offset columnTitleOrigin = new Offset(columnTitleX, columnTitleY);
      final Offset rowTitleOrigin = new Offset(centeredRowTitleX, rowTitleY);
      final Offset titleOrigin =
          _interpolatePoint(columnTitleOrigin, rowTitleOrigin);
      positionChild('title$index', titleOrigin + offset);

      // Layout the selection indicator for index.
      final Size indicatorSize = layoutChild(
          'indicator$index', new BoxConstraints.loose(cardRect.size));
      final double columnIndicatorX =
          cardRect.centerRight.dx - indicatorSize.width - 16.0;
      final double columnIndicatorY =
          cardRect.bottomRight.dy - indicatorSize.height - 16.0;
      final Offset columnIndicatorOrigin =
          new Offset(columnIndicatorX, columnIndicatorY);
      final Rect titleRect =
          new Rect.fromPoints(titleOrigin, titleSize.bottomRight(titleOrigin));
      final double centeredRowIndicatorX =
          rowIndicatorX + (rowIndicatorWidth - indicatorSize.width) / 2.0;
      final double rowIndicatorY = titleRect.bottomCenter.dy + 16.0;
      final Offset rowIndicatorOrigin =
          new Offset(centeredRowIndicatorX, rowIndicatorY);
      final Offset indicatorOrigin =
          _interpolatePoint(columnIndicatorOrigin, rowIndicatorOrigin);
      positionChild('indicator$index', indicatorOrigin + offset);

      columnCardY += columnCardHeight;
      rowCardX += rowCardWidth;
      rowTitleX += rowTitleWidth;
      rowIndicatorX += rowIndicatorWidth;
    }
  }

  @override
  bool shouldRelayout(_AllSectionsLayout oldDelegate) {
    return tColumnToRow != oldDelegate.tColumnToRow ||
        cardCount != oldDelegate.cardCount ||
        selectedIndex != oldDelegate.selectedIndex;
  }
}

class _AllSectionsView extends AnimatedWidget {
  _AllSectionsView({
    Key key,
    this.sectionIndex,
    @required this.categoryTitleInfos,
    @required this.selectedIndex,
    this.minHeight,
    this.midHeight,
    this.maxHeight,
    this.sectionCards = const <Widget>[],
  })  : assert(categoryTitleInfos != null),
        assert(sectionCards != null),
        assert(sectionCards.length == categoryTitleInfos.length),
        assert(sectionIndex >= 0 && sectionIndex < categoryTitleInfos.length),
        assert(selectedIndex != null),
        assert(selectedIndex.value >= 0.0 &&
            selectedIndex.value < categoryTitleInfos.length.toDouble()),
        super(key: key, listenable: selectedIndex);

  final int sectionIndex;
  final List<CategoryTitleInfo> categoryTitleInfos;
  final ValueNotifier<double> selectedIndex;
  final double minHeight;
  final double midHeight;
  final double maxHeight;
  final List<Widget> sectionCards;

  double _selectedIndexDelta(int index) {
    return (index.toDouble() - selectedIndex.value).abs().clamp(0.0, 1.0);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final Size size = constraints.biggest;
    final double tColumnToRow = 1.0 -
        ((size.height - midHeight) / (maxHeight - midHeight)).clamp(0.0, 1.0);

    final double tCollapsed = 1.0 -
        ((size.height - minHeight) / (midHeight - minHeight)).clamp(0.0, 1.0);

    double _indicatorOpacity(int index) {
      return 1.0 - _selectedIndexDelta(index) * 0.5;
    }

    double _titleOpacity(int index) {
      return 1.0 - _selectedIndexDelta(index) * tColumnToRow * 0.5;
    }

    double _titleScale(int index) {
      return 1.0 - _selectedIndexDelta(index) * tColumnToRow * 0.15;
    }

    final List<Widget> children = new List<Widget>.from(sectionCards);

    for (int index = 0; index < categoryTitleInfos.length; index++) {
      final CategoryTitleInfo category = categoryTitleInfos[index];
      children.add(new LayoutId(
          id: 'title$index',
          child: new CategoryTitle(
              category: category,
              scale: _titleScale(index),
              opacity: _titleOpacity(index))));
    }

    for (int index = 0; index < categoryTitleInfos.length; index++) {
      children.add(new LayoutId(
          // ignore: must_be_immutable
          id: 'indicator$index',
          child: new CategoryIndicator(opacity: _indicatorOpacity(index))));
    }

    return new CustomMultiChildLayout(
        delegate: new _AllSectionsLayout(
            translation: new Alignment(
                (selectedIndex.value - sectionIndex) * 2.0 - 1.0, -1.0),
            tColumnToRow: tColumnToRow,
            tCollapsed: tCollapsed,
            cardCount: categoryTitleInfos.length,
            selectedIndex: selectedIndex.value),
        children: children);
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: _build);
  }
}

class AnimationDemoHome extends StatefulWidget {
  BannerBean bannerBean;

  AnimationDemoHome({this.bannerBean});

  @override
  _AnimationDemoHomeState createState() => _AnimationDemoHomeState();
}

class _AnimationDemoHomeState extends State<AnimationDemoHome> {
  final ScrollController _scrollController = ScrollController();
  final PageController _headingPageController = PageController();
  final PageController _detailsPageController = PageController();
  ScrollPhysics _headingScrollPhysics = NeverScrollableScrollPhysics();
  ValueNotifier<double> selectedIndex = ValueNotifier<double>(0.0);
  double appBarMaxHeight;
  bool isSupportScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        isSupportScroll = _scrollController.offset == appBarMaxHeight;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build bannerBean");
    return Builder(
      builder: _buildBody,
    );
  }

  void _maybeScroll(double midScrollOffset, int pageIndex, double xOffset) {
    isSupportScroll = true;
    if (_scrollController.offset < midScrollOffset) {
      _headingPageController.animateToPage(pageIndex,
          curve: _kScrollCurve, duration: _kScrollDuration);
      _scrollController.animateTo(midScrollOffset,
          curve: _kScrollCurve, duration: _kScrollDuration);
    } else {
      final double centerX =
          _headingPageController.position.viewportDimension / 2.0;
      final int newPageIndex =
          xOffset > centerX ? pageIndex + 1 : pageIndex - 1;
      _headingPageController.animateToPage(newPageIndex,
          curve: _kScrollCurve, duration: _kScrollDuration);
    }
  }

  bool _handlePageNotification(ScrollNotification notification,
      PageController leader, PageController follower) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      selectedIndex.value = leader.page;
      if (follower.page != leader.page)
        follower.position.jumpToWithoutSettling(
            leader.position.pixels); // ignore: deprecated_member_use
    }
    return false;
  }

  Iterable<Widget> _allHeadingItems(
      BuildContext context, double maxHeight, double midScrollOffset) {
    List<Widget> sectionCards = <Widget>[];
    for (int index = 0;
        index < widget.bannerBean.categoryTitleInfos.length;
        index++) {
      sectionCards.add(LayoutId(
          id: 'card$index',
          child: InkWell(
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: CategoryCard(
                      categoryTitleInfo:
                          widget.bannerBean.categoryTitleInfos[index]),
                  onTapUp: (TapUpDetails details) {
                    final double xOffset = details.globalPosition.dx;
                    setState(() {
                      _maybeScroll(midScrollOffset, index, xOffset);
                    });
                  }))));
    }

    final List<Widget> headings = <Widget>[];
    for (int index = 0;
        index < widget.bannerBean.categoryTitleInfos.length;
        index++) {
      headings.add(Container(
          color: _kAppBackgroundColor,
          child: ClipRect(
              child: _AllSectionsView(
                  sectionIndex: index,
                  categoryTitleInfos: widget.bannerBean.categoryTitleInfos,
                  selectedIndex: selectedIndex,
                  minHeight: 200.0,
                  midHeight: 200.0,
                  maxHeight: maxHeight,
                  sectionCards: sectionCards))));
    }
    return headings;
  }

  Widget _buildBody(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    appBarMaxHeight = mediaQueryData.size.height;
    final double appBarMidScrollOffset = appBarMaxHeight + 200.0;

    return new SizedBox.expand(
        child: Stack(children: <Widget>[
      NotificationListener<ScrollNotification>(
          child:
              CustomScrollView(controller: _scrollController, slivers: <Widget>[
        // Section Headings
        SliverToBoxAdapter(
            child: Container(
                height: 200.0,
                child: DefaultTabController(
                    length: widget.bannerBean.banners.length,
                    child: PageSelector(banners: widget.bannerBean.banners)))),
        SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
                minHeight: 200.0,
                maxHeight: appBarMaxHeight,
                child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      return _handlePageNotification(notification,
                          _headingPageController, _detailsPageController);
                    },
                    child: PageView(
                        physics: _headingScrollPhysics,
                        controller: _headingPageController,
                        children: _allHeadingItems(context, appBarMaxHeight,
                            appBarMidScrollOffset))))),
        // Details
        SliverToBoxAdapter(
            child: SizedBox(
                height: appBarMaxHeight - 200,
                child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      return _handlePageNotification(notification,
                          _detailsPageController, _headingPageController);
                    },
                    child: PageView(
                        controller: _detailsPageController,
                        children: widget.bannerBean.categoryTitleInfos
                            .map((CategoryTitleInfo category) {
                          return ImageListPager(
                              categoryInfo: category,
                              isSupportScroll: isSupportScroll);
                        }).toList()))))
      ]))
    ]));
  }
}
