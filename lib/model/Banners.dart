class BannerBean {
  final List<BannerInfo> banners;
  final List<CategoryTitleInfo> categoryTitleInfos;

  BannerBean(this.banners, this.categoryTitleInfos);
}

class BannerInfo {
  String url;
  String src;

  BannerInfo.fromJson(Map<String, dynamic> jsonRes) {
    this.url = jsonRes['url'];
    this.src = jsonRes['src'];
  }

  @override
  String toString() {
    return "url = $url , src = $src";
  }
}

class CategoryTitleInfo {
  int count;
  String eName;
  String rName;
  String coverTemp;
  String name;
  String cover;
  int rank;
  int sn;
  String iCover;
  double aTime;
  int type;
  String id;
  String picassoCover;

  CategoryTitleInfo.fromJson(Map<String, dynamic> jsonRes) {
    count = jsonRes['count'];
    eName = jsonRes['ename'];
    rName = jsonRes['rname'];
    coverTemp = jsonRes['cover_temp'];
    name = jsonRes['name'];
    cover = jsonRes['cover'];
    rank = jsonRes['rank'];
    sn = jsonRes['sn'];
    iCover = jsonRes['icover'];
    aTime = jsonRes['atime'];
    type = jsonRes['type'];
    id = jsonRes['id'];
    picassoCover = jsonRes['picasso_cover'];
  }
}
