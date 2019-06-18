import 'package:flutter/material.dart';
//import 'package:listener/RandomList.dart';
import 'package:listener/UserAccountsSideBar.dart';
import 'package:listener/SignupPage.dart';
import 'package:listener/LoginPage.dart';
import 'package:listener/ChatServer.dart';
import 'package:listener/Articles.dart';
import 'package:listener/WebSocket.dart';
import 'package:listener/TestsPage.dart';
import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provide/provide.dart';
import 'package:listener/store/index.dart' show Store;
import 'package:listener/store/models/config_state_model.dart' show ConfigModel;

//import 'dart:collection';
var themeData = ThemeData(
    fontFamily: 'Raleway',
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    accentColor: Colors.blue);

final List<Article> articlesList = new List<Article>();
final Set<Article> likedArticles = new Set<Article>();

final List<Test> testsList = new List<Test>();
final Set<Test> likedTests = new Set<Test>();

final Map<String, dynamic> loginInfo = new Map<String, dynamic>();
final Map<String, dynamic> signupInfo = new Map<String, dynamic>();
ThemeData theme = ThemeData.dark();

saveArticles() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//for(Article article:likedArticles){}
  int num = 10000;
  Map<String, Map<String, dynamic>> aMap =
      new Map<String, Map<String, dynamic>>();
  List<Article> aList = likedArticles.toList();
  for (int i = 0; i < aList.length; i++) {
    aMap['article_id:$num'] = new Map<String, dynamic>();
    aMap['article_id:$num']["title"] = aList[i].title;
    aMap['article_id:$num']["author"] = aList[i].author;
    aMap['article_id:$num']["content"] = aList[i].content;
    aMap['article_id:$num']["pic"] = aList[i].pic;
    aMap['article_id:$num']["date"] = aList[i].date;

    debugPrint("正在存储第 " + (i + 1).toString() + "个，序号：" + num.toString());
    num--;
  }

  String str = json.encode(aMap);

  prefs.setString("likedArticles", str);
  debugPrint("本地存储成功：" + aMap.toString());
}

save(String saveKey, String saveValue) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(saveKey, saveValue);
}

Future<String> get(String getkEY) async {
  var userName;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String getValue = prefs.getString(getkEY);
  return getValue;
}

void main() {
//  Map<String, dynamic> articles = json.decode();
  runApp(Store.init(child: MainPage()));
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    // TODO: implement createState
    return new _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future t=get('theme');
    t.then((value){
      if(value!=null&&value!=''){
        value=='dark'?theme=ThemeData.dark():theme=ThemeData.light();
        debugPrint('本地theme获取成功：'+value.toString());
        Store.value<ConfigModel>(context).$setTheme('red');
      }
    });


  }
  @override
  Widget build(BuildContext context) {

    return Store.connect<ConfigModel>(builder: (context, child, model) {
      return new MaterialApp(
        title: 'Listener',
        //color: Colors.black87,
        theme: //ThemeData(primaryColor: Color(model.theme)),
        theme,

        home: //MainLayout(),
            LoginPage(),

        routes: <String, WidgetBuilder>{
          '/signuppage': (BuildContext context) => new SignupPage(),
          '/loginpage': (BuildContext context) => new LoginPage(),
          '/home': (BuildContext context) => new MainLayout(),
          '/testpage': (BuildContext context) => new Tests(),
          '/chatpage': (BuildContext context) => new ChatServer(),
          '/likedpage': (BuildContext context) => new LikedArticles(),
        },
        //initialRoute: '/home',
        // initialRoute: '/loginpage',
      );
    });
  }
}

//class RandomList extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Startup Name Generator main',
//      theme: new ThemeData(
//        // 新增代码开始...
//        primaryColor: Colors.black87,
//      ), // ... 代码新增结束
//      home: new RandomWords(),
//    );
//  }
//}

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(articlesList==null)LoadFromServer().getArticles();
    //while (loginInfo['username'] == null || loginInfo['email'] == null) {}

    UserAccountsSideBar user = new UserAccountsSideBar(loginInfo['username'],
        loginInfo['email'], loginInfo['avatar'], null, context);

    return new Scaffold(
      appBar: AppBar(
        title: Text('Listener'),
      ),
      drawer: user.getSideBar(),
      body: new Articles(),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chatpage');
        },
        tooltip: 'chat',
        child: Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
