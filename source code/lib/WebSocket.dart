import 'package:flutter/material.dart';
//import 'dart:io';
import 'package:dio/dio.dart' as Dio;
import 'package:http/http.dart'as http;
import 'package:listener/Articles.dart';
import 'package:listener/TestsPage.dart';
import 'package:listener/main.dart' as Main;
import 'dart:convert';

class UserInfo {
  String email;
  String username;
  String password;
  int user_id;
}

class LoadFromServer {
  Future getArticles() async {


    Dio.Response response;
    Dio.Dio dio = new Dio.Dio();
    try {

      debugPrint("http尝试获取文章中");
      http.Response res=await http.get('http://132.232.213.145:21025/getArticles.php');
      debugPrint("http获取文章成功:"+    json.decode(res.body).toString().substring(0,25));
      Map<String, dynamic> articles = json.decode(res.body.toString());


//      debugPrint("dio尝试获取文章中");
//      response = await dio.get("http://132.232.213.145:21025/getArticles.php");
//      // debugPrint(response.data);
//      debugPrint("dio获取文章成功");
//
//      Map<String, dynamic> articles = json.decode(response.toString());

      Main.articlesList.clear();
      for (int num = 10000; num > 9900; num--) {
        if (articles['article_id:$num'] != null) {
          Main.articlesList.add(new Article(
              articles['article_id:$num']['title'],
              articles['article_id:$num']['content'],
              articles['article_id:$num']['datetime'],
              articles['article_id:$num']['pic'],
              articles['article_id:$num']['author']));
        }
        // Main.articlesList.add(new Article('title $num', 'article $num', DateTime.now(),'https://www.easyicon.net/api/resizeApi.php?id=1179067&size=96','author $num'));

      }
    } catch (msg) {
      debugPrint(msg.toString());
    }
  }

  Future getTests() async {

    Dio.Response response;
    Dio.Dio dio = new Dio.Dio();
    try {

      debugPrint("http尝试获取测试中");
      http.Response res=await http.get('http://132.232.213.145:21025/getTests.php');
      debugPrint("http获取测试成功:"+    json.decode(res.body).toString().substring(0,25));
      Map<String, dynamic> tests = json.decode(res.body.toString());

//
//      debugPrint("dio尝试获取测试中");
//      response = await dio.get("http://132.232.213.145:21025/getTests.php");
//      // debugPrint(response.data);
//      debugPrint("dio获取测试成功");
//
//      Map<String, dynamic> tests = json.decode(response.toString());



      Main.testsList.clear();
      for (int num = 10000; num > 9900; num--) {
        if (tests['test_id:$num'] != null) {
          Main.testsList.add(new Test(
              tests['test_id:$num']['test_id'],
              tests['test_id:$num']['content'],
              tests['test_id:$num']['datetime'],
              tests['test_id:$num']['pic'],
              tests['test_id:$num']['test_name']));
        }
        // Main.articlesList.add(new Article('title $num', 'article $num', DateTime.now(),'https://www.easyicon.net/api/resizeApi.php?id=1179067&size=96','author $num'));

      }
    } catch (msg) {
      debugPrint(msg.toString());
    }
  }


  Future login(String email, String password, BuildContext context) async {
    Dio.Response response;
    Dio.Dio dio = new Dio.Dio();
    //todo fulfill func of cookieJar
   // dio.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor());
    try {
      debugPrint("http尝试登陆中");
      http.Response res=await http.post( "http://132.232.213.145:21025/login.php?email=$email&&password=$password");
      debugPrint("http登陆成功:"+    json.decode(res.body).toString().substring(0,25));

      Main.loginInfo.clear();
      Main.loginInfo.addAll(json.decode(res.body.toString()));

//      debugPrint("dio尝试登陆中");
//      response = await dio.post(
//          "http://132.232.213.145:21025/login.php?email=$email&&password=$password");
//      // debugPrint(response.data);
//      debugPrint("dio登陆成功");
//
//
//      debugPrint(
//          'url: http://132.232.213.145:21025/login.php?email=$email&&password=$password');
//      debugPrint("data:" + response.data);
//      debugPrint("headers:" + response.headers.toString());
//      debugPrint("request:" + response.request.toString());
//      // debugPrint(statusCode);

//      Main.loginInfo.clear();
//      Main.loginInfo.addAll(json.decode(response.toString()));




      if (Main.loginInfo['username'] != null &&
          Main.loginInfo['username'] != '')
        Main.loginInfo['flag'] = 'true';
      else
        Main.loginInfo['flag'] = 'false';
    } catch (msg) {
      debugPrint(msg.toString());
    }

  }

  Future signup(String username,String email, String password, BuildContext context) async {
    Dio.Response response;
    Dio.Dio dio = new Dio.Dio();
    //todo fulfill func of cookieJar
    // dio.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor());
    try {
      debugPrint("http尝试注册中");
      http.Response res=await http.post( "http://132.232.213.145:21025/signup.php?username="+username+"&email=$email&password=$password");
      debugPrint("http注册成功:"+    json.decode(res.body).toString().substring(0,25));

      Main.signupInfo.clear();
      Main.signupInfo.addAll(json.decode(res.body.toString()));

//      debugPrint("dio尝试登陆中");
//      response = await dio.post(s
//          "http://132.232.213.145:21025/login.php?email=$email&&password=$password");
//      // debugPrint(response.data);
//      debugPrint("dio登陆成功");
//
//
//      debugPrint(
//          'url: http://132.232.213.145:21025/login.php?email=$email&&password=$password');
//      debugPrint("data:" + response.data);
//      debugPrint("headers:" + response.headers.toString());
//      debugPrint("request:" + response.request.toString());
//      // debugPrint(statusCode);

//      Main.loginInfo.clear();
//      Main.loginInfo.addAll(json.decode(response.toString()));

    } catch (msg) {
      debugPrint(msg.toString());
    }

  }

}
