import 'package:flutter/material.dart';
import 'dart:math';
//import 'package:flutter/cupertino.dart';
import 'package:listener/main.dart' as Main;
import 'package:listener/WebSocket.dart';
import 'package:listener/LocalColors.dart';
import 'package:listener/common/touch_callback.dart';
import 'package:date_format/date_format.dart';
import 'package:url_launcher/url_launcher.dart' show launch;

class Articles extends StatefulWidget {
  @override
  ArticlesState createState() => new ArticlesState();
}

class ArticlesState extends State<Articles> {
  //final List<Article> _articles = <Article>[];

  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getMoreData() async {
    debugPrint('下拉刷新中');
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      await LoadFromServer().getArticles();
      setState(() {
        debugPrint('下拉刷新成功');
        final snackBar = new SnackBar(
          content: new Text(
            '刷新成功',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 3), // 持续时间
          //animation,
        );
        Scaffold.of(context).showSnackBar(snackBar);

        isPerformingRequest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final wordPair = new Article.random(); // 删掉 ...
    //return new Text(wordPair.asPascalCase); // ... 这两行
    return new Scaffold(
        body: RefreshIndicator(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: Main.articlesList.length,
                itemBuilder: (BuildContext context, int index) {
                  //  Main.articlesList.add(new Article('title', 'article', DateTime.now()));
                  // return new Article(Main.articlesList[index].title, Main.articlesList[index].article, Main.articlesList[index].date);
                  return Main.articlesList[index];
                }),
            onRefresh: _refresh));
  }

  Future<Null> _refresh() async {
//    _dataList.clear();
//    await _loadFirstListData();
//    return;
  }
}

class Article extends StatefulWidget {
  //implements Comparable{
  final String pic;
  final String author;
  final String title;
  final String date;
  final String content;
//ArticleState articleState;

  Article(this.title, this.content, this.date, this.pic, this.author);

  // Override hashCode
  @override
  int get hashCode {
    int result = title.hashCode;
    result = 37 * result + author.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! Article) return false;
    Article a = other;
    return (a.title == this.title &&
        a.pic == this.pic &&
        a.author == this.author &&
        a.content == this.content &&
        a.date == this.date);
  }

//  int compareTo(var a){
//    if(a.title == this.title &&
//        a.pic == this.pic &&
//        a.author == this.author &&
//        a.content == this.content &&
//        a.date == this.date)return 1;
//    else return -1;
//
//  }

  ArticleState createState() {
//    articleState=
    return ArticleState(title, content, date, pic, author);
//    return articleState;
  }
}

class ArticleState extends State<Article> {
  final String pic;
  final String author;
  final String title;
  final String date;
  final String content;

  ArticleState(this.title, this.content, this.date,
      [this.pic, this.author = '匿名']);

  @override
  Widget build(BuildContext context) {
    //setState(() {});
    colorsIndex = Random().nextInt(localColors.length);
    return Container(
        decoration: BoxDecoration(
          color: Color(0xaa000000 + localColors[colorsIndex]),
          //color:Color(0xff151515),
          //border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
        ),
        height: 150,
        margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5, bottom: 5),
        child: TouchCallBack(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //图片
              Container(
                //外边距
                margin: const EdgeInsets.only(left: 13.0, right: 13.0),
                child: pic != null
                    ? Image.network(
                        pic,
                        width: 100.0,
                        height: 100.0,
                      )
                    : Image.network(
                        'https://www.easyicon.net/api/resizeApi.php?id=1179067&size=96',
                        width: 100.0,
                        height: 100.0,
                      ),
//                    : Container(
//                        child: Icon(Icons.format_list_numbered),
//                        width: 120.0,
//                        height: 120.0,
//                      ),
              ),
              Expanded(
                //主标题与子标题，垂直布局
                child: Column(
                  //垂直方向居中
                  mainAxisAlignment: MainAxisAlignment.center,
                  //水平方向靠左
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16.0,
                          color: Colors.white),
                      maxLines: 1,
                      //overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                    ),
                    Text(
                      "（" + author + "） " + content,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 14.0,
                          color: Colors.white), //Color(0xFFa9a9a9)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),

              Column(
                  //垂直方向居中
                  mainAxisAlignment: MainAxisAlignment.center,
                  //水平方向靠左
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      //时间顶部对齐
                      alignment: AlignmentDirectional.topStart,
                      margin: const EdgeInsets.only(right: 25.0, bottom: 30.0),
                      child: Text(
                        date.substring(2, 10),
                        style: TextStyle(
                          decoration: TextDecoration.none,

                          fontSize: 14.0,
                          color: Colors.white, //Color(0xFFa9a9a9),
                        ),
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.topStart,
                      margin: const EdgeInsets.only(right: 25.0, bottom: 5.0),
                      child: Icon(
                        Main.likedArticles.contains(
                                Article(title, content, date, pic, author))
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Main.likedArticles.contains(
                                Article(title, content, date, pic, author))
                            ? Colors.red
                            : Colors.white, //Colors.grey,
                      ),
                    )
                  ])
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ShowArticle(
                        article:
                            new Article(title, content, date, pic, author))));
          },
        ));
  }
}

class LikedArticles extends StatefulWidget {
  LikedArticlesState createState() => new LikedArticlesState();
}

class LikedArticlesState extends State<LikedArticles> {
  @override
  Widget build(BuildContext context) {
    //final wordPair = new Article.random(); // 删掉 ...
    //return new Text(wordPair.asPascalCase); // ... 这两行
    return new Container(
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  //leading, // 在标题前面显示的一个控件，在首页通常显示应用的 logo；在其他界面通常显示为返回按钮
                  //title, // Toolbar 中主要内容，通常显示为当前界面的标题文字
                  //actions, // 一个 Widget 列表，代表 Toolbar 中所显示的菜单，对于常用的菜单，通常使用 IconButton 来表示；对于不常用的菜单通常使用 PopupMenuButton 来显示为三个点，点击后弹出二级菜单
                  //flexibleSpace,
                  //bottom,         //底部内容区域
                  //elevation, //阴影,纸墨设计中控件的 z 坐标顺序，默认值为 4，对于可滚动的 SliverAppBar，当 SliverAppBar 和内容同级的时候，该值为 0， 当内容滚动 SliverAppBar 变为 Toolbar 的时候，修改 elevation 的值
                  //flexibleSpace：一个显示在 AppBar 下方的控件，高度和 AppBar 高度一样，可以实现一些特殊的效果，该属性通常在 SliverAppBar 中使用
                  //backgroundColor,  // 背景色,APP bar 的颜色，默认值为 ThemeData.primaryColor。改值通常和下面的三个属性一起使用
                  //brightness,   // 主题明亮,App bar 的亮度，有白色和黑色两种主题，默认值为 ThemeData.primaryColorBrightness
                  //iconTheme,  // 图标主题,App bar 上图标的颜色、透明度、和尺寸信息。默认值为 ThemeData.primaryIconTheme
                  //textTheme,    //文字主题, App bar 上的文字样式。默认值为 ThemeData.primaryTextTheme
                  //centerTitle,     //标题是否居中, 标题是否居中显示，默认值根据不同的操作系统，显示方式不一样
                  primary: true, //是否预留高度
                  forceElevated: false,
                  automaticallyImplyLeading: true,
                  titleSpacing: NavigationToolbar.kMiddleSpacing,
                  snap: false, //与floating结合使用
                  expandedHeight: 200.0, //展开高度
                  floating: false, //是否随着滑动隐藏标题
                  pinned: true, //是否固定在顶部
                  flexibleSpace: FlexibleSpaceBar(
                      //可以展开区域，通常是一个FlexibleSpaceBar
                      centerTitle: true,
                      title: Text("收藏夹",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              decoration: TextDecoration.none)),
                      background: Image.network(
                        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558105141415&di=8023dabc933edfb7c89440bd9525cf33&imgtype=0&src=http%3A%2F%2Fimg1.cache.netease.com%2Fcatchpic%2F5%2F5A%2F5A280C2AB1C3893F526DDFF61692280F.jpg",
//                        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558104961710&di=c58292068f986ffc837e44e98a0b60d0&imgtype=0&src=http%3A%2F%2Fpcs4.clubstatic.lenovo.com.cn%2Fdata%2Fattachment%2Fforum%2F201601%2F29%2F153040dhgwgdg3sbgqwoxo.jpg",
                        fit: BoxFit.fill,
                      )),
                ),
              ];
            },
            body: Center(
              child: ListView.builder(
                  itemCount: Main.likedArticles.length,
                  itemBuilder: (BuildContext context, int index) {
                    //  Main.articlesList.add(new Article('title', 'article', DateTime.now()));
                    // return new Article(Main.articlesList[index].title, Main.articlesList[index].article, Main.articlesList[index].date);
                    // return Main.articlesList[index];
                    return Main.likedArticles.toList()[index];
                  }),
            )));
  }
}

class ShowArticle extends StatefulWidget {
  final Article article;
  ShowArticle({Key key, @required this.article}) : super(key: key);

  ShowArticleState createState() => new ShowArticleState(article: article);
}

class ShowArticleState extends State<ShowArticle> {
  final Article article;

  ShowArticleState({@required this.article});

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Reading'),
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Main.likedArticles.contains(article)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Main.likedArticles.contains(article)
                    ? Colors.red
                    : Colors.white,
              ),
              //   highlightColor: Colors.red,
              onPressed: () {
//                bool hasFav=false;
//                hasFav=false;
//                Main.likedArticles.forEach((Article a){
//                  if(a.compareTo(article)==0) hasFav==true;
//                  debugPrint('hasFav:'+hasFav.toString()+ a.compareTo(article).toString());
//
//                });
                if (Main.likedArticles.contains(article)) {
                  Main.likedArticles.remove(article);
                  debugPrint('移除成功');
                  Main.saveArticles();
                  //article.articleState.setState((){});
                  debugPrint("fav: " + Main.likedArticles.toString());
                } else {
                  Main.likedArticles.add(article);
                  //  article.articleState.setState((){});
                  debugPrint('收藏成功');
                  Main.saveArticles();
                  debugPrint("fav: " + Main.likedArticles.toString());
                }
                setState(() {});
              },
            )
          ],
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white, //Color(0x05050505),
              //border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
            ),
            margin: const EdgeInsets.only(
                left: 25.0, right: 25.0, top: 25, bottom: 25),
            child:
//            Column(
//
//                //垂直方向靠上
//                mainAxisAlignment: MainAxisAlignment.start,
//                //水平方向居中
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children:
                SingleChildScrollView(
                    child: ListBody(children: <Widget>[
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 15),
                  //title
                  child: Text(
                    article.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  )),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 15),
                //info
                child: Text(
                  article.author + "   " + article.date,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 15, color: Colors.black45),
                ),
              ),
              Container(
                width: double.infinity,
                //article
                margin: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white, //Color(0x05050505),
//                          border: Border(
//                              top: BorderSide(width: 0.5, color: Colors.grey))
                ),
                child: Text(
                  article.content,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              )
            ]))));
  }
}
