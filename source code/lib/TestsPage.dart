import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
import 'package:listener/main.dart' as Main;
import 'package:listener/common/touch_callback.dart';
import 'package:date_format/date_format.dart';
import 'package:url_launcher/url_launcher.dart' show launch;
import 'package:listener/LocalColors.dart';

class Tests extends StatefulWidget {
  @override
  TestsState createState() => new TestsState();
}

class TestsState extends State<Tests> {
  final List<Test> _tests = <Test>[];

  @override
  Widget build(BuildContext context) {
    //final wordPair = new Test.random(); // 删掉 ...
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
                  primary: true,
                  //是否预留高度
                  forceElevated: false,
                  automaticallyImplyLeading: true,
                  titleSpacing: NavigationToolbar.kMiddleSpacing,
                  snap: false,
                  //与floating结合使用
                  expandedHeight: 200.0,
                  //展开高度
                  floating: false,
                  //是否随着滑动隐藏标题
                  pinned: true,
                  //是否固定在顶部
                  flexibleSpace: FlexibleSpaceBar(
                      //可以展开区域，通常是一个FlexibleSpaceBar
                      centerTitle: true,
                      title: Text("测评",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              decoration: TextDecoration.none)),
                      background: Image.network(
                        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558105141415&di=8023dabc933edfb7c89440bd9525cf33&imgtype=0&src=http%3A%2F%2Fimg1.cache.netease.com%2Fcatchpic%2F5%2F5A%2F5A280C2AB1C3893F526DDFF61692280F.jpg",
                        fit: BoxFit.fill,
                      )),
                ),
              ];
            },
            body: Center(
                child: ListView.builder(
                    itemCount: Main.testsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      //  Main.testsList.add(new Test('test_id', 'test', DateTime.now()));
                      // return new Test(Main.testsList[index].test_id, Main.testsList[index].test, Main.testsList[index].date);
                      return Main.testsList[index];
                    }))));
  }
}

class Test extends StatelessWidget {
  final String test_id;
  final String test_name;
  final String date;
  final String content;
  final String pic;

  Test(this.test_id, this.content, this.date, this.pic, this.test_name);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white, //Color(0x05050505),
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
                        'https://t9.baidu.com/it/u=2071786586,4039887217&fm=191&app=48&size=h300&n=0&g=4n&f=JPEG?sec=1853310920&t=3d0142bb5b2b98b7fb3ee4d18da40289',
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
                      test_id,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16.0,
                          color: Color(0xFF353535)),
                      maxLines: 1,
                      //overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                    ),
                    Text(
                      "（" + test_name + "） " + content,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 14.0,
                          color: Color(0xFFa9a9a9)),
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
                          color: Color(0xFFa9a9a9),
                        ),
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.topStart,
                      margin: const EdgeInsets.only(right: 25.0, bottom: 5.0),
                      child: Icon(
                        Main.likedTests.contains(this)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Main.likedTests.contains(this)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    )
                  ])
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ShowTest(test: this)));
          },
        ));
  }
}

class LikedTests extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Scaffold();
  }
}

class ShowTest extends StatelessWidget {
  final Test test;
  ShowTest({Key key, @required this.test}) : super(key: key);
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(test.test_name),
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Main.likedTests.contains(test)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    Main.likedTests.contains(test) ? Colors.red : Colors.white,
              ),
              onPressed: () {
                //TODO add to done_Tests
//                Main.likedTests.contains(test)
//                    ? Main.likedTests.remove(test) : Main.likedTests.add(test);
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
            child: Column(

                //垂直方向靠上
                mainAxisAlignment: MainAxisAlignment.start,
                //水平方向居中
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 15),
                      //title
                      child: Text(
                        test.test_id,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40, color: Colors.black),
                      )),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 15),
                    //info
                    child: Text(
                      test.test_name + "   " + test.date,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 15, color: Colors.black45),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      //test
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white, //Color(0x05050505),
//                          border: Border(
//                              top: BorderSide(width: 0.5, color: Colors.grey))
                      ),
                      child: Text(
                        test.content,
                        style: TextStyle(fontSize: 20, color: Colors.black87),
                      )),
                ])));
  }
}
