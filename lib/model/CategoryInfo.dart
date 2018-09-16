class CategoryInfo {
  int views;
  int ncos;
  int rank;
  String wp; // 超大高清
  bool xr;
  bool cr;
  int favs;
  double aTime;
  String id;
  String desc;
  String thumb; // 小图
  String img; // 大图
  String preview; // 超大高清

  CategoryInfo.fromJson(Map<String, dynamic> jsonRes) {
    views = jsonRes['views'];
    ncos = jsonRes['ncos'];
    rank = jsonRes['rank'];
    wp = jsonRes['wp'];
    xr = jsonRes['xr'];
    cr = jsonRes['cr'];
    favs = jsonRes['favs'];
    aTime = jsonRes['atime'];
    id = jsonRes['id'];
    desc = jsonRes['desc'];
    thumb = jsonRes['thumb'];
    img = jsonRes['img'];
    preview = jsonRes['preview'];
  }
}
