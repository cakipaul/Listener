import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart' show launch;
import 'package:listener/WebSocket.dart';
import 'package:listener/main.dart' as Main;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:listener/store/index.dart' show Store;
import 'package:listener/store/models/config_state_model.dart' show ConfigModel;
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountsSideBar {
  String name;
  String mail;
  String avatar;
  String url;
  BuildContext context;

  UserAccountsSideBar(
    this.name,
    this.mail,
    this.avatar,
    this.url,
    this.context,
  );

  Drawer getSideBar() {
    //用户名，邮箱，头像，链接
    return new Drawer(
        child: ListView(children: <Widget>[
      //用户信息
      UserAccountsDrawerHeader(
        accountName: new Text(name),
        accountEmail: new Text(mail),
        currentAccountPicture: avatar == null
            ? new CircleAvatar(
                child: Icon(
                Icons.portrait,
                color: Colors.white,
              ))
            : new Image.network(
                avatar,
//                width: 100.0,
//                height: 100.0,
              ),
        onDetailsPressed: () {
          url != null ? launch(url) : null;
        },
      ),
      ListTile(
        leading: new CircleAvatar(
          child: Icon(Icons.speaker_notes, color: Colors.white),
        ),
        title: Text('测试'),
        onTap: () {
          LoadFromServer().getTests();
          Navigator.pushNamed(context, '/testpage');
        },
      ),
      Divider(
        color: Colors.transparent,
      ),
      ListTile(
        leading: new CircleAvatar(
          child: Icon(Icons.attach_file, color: Colors.white),
        ),
        title: Text('收藏'),
        onTap: () {
          Navigator.pushNamed(context, '/likedpage');
        },
      ),
      Divider(
        color: Colors.transparent,
      ),
      ListTile(
        leading: new CircleAvatar(
          child: Icon(Icons.cloud_upload, color: Colors.white),
        ),
        title: Text('上传'),
        onTap: () {
          //TODO 上传
        },
      ),
      Divider(
        color: Colors.transparent,
      ),
      ListTile(
        leading: new CircleAvatar(
          child: Icon(Icons.color_lens, color: Colors.white),
        ),
        title: Text('主题'),
        onTap: () async {
          if (Main.theme == ThemeData.dark()) {
            Main.theme = ThemeData.light();
          } else
            Main.theme = ThemeData.dark();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String t;
          Main.theme == ThemeData.dark() ? t = 'dark' : t = 'light';
          prefs.setString('theme', t).then((v) {
            debugPrint('本地theme存储成功：' + t.toString());
          });

          Store.value<ConfigModel>(context).$setTheme('red');
          // Main.MainPageState.changeTheme();
        },
      ),
      Divider(
        color: Colors.transparent,
      ),
      ListTile(
        leading: new CircleAvatar(
          child: Icon(Icons.account_circle, color: Colors.white),
        ),
        title: Text('重登'),
        onTap: () {
          Navigator.popAndPushNamed(context, '/loginpage');
        },
      ),
      Divider(
        color: Colors.transparent,
      ),
      ListTile(
          leading: new CircleAvatar(
            child: Icon(Icons.account_circle, color: Colors.white),
          ),
          title: Text('退出'),
          onTap: () {
            exit(0);
          }),
    ]));
  }
}
