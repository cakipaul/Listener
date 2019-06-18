import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

import 'package:listener/Articles.dart';
import 'package:listener/WebSocket.dart';
import 'package:listener/main.dart' as Main;
import 'dart:convert';

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

class LoginPage extends StatefulWidget {
//  final TextEditingController emailTextEditingController =
//      TextEditingController();
//  final TextEditingController passwordTextEditingController =
//      TextEditingController();

  @override
  _LoginPageState createState() {
//    Future<String> email = get("email");
//    email.then((String email) {
//      debugPrint("本地email读取成功：$email\n");
//      emailTextEditingController.text = email;
//    });
//
//    Future<String> password = get("password");
//    password.then((String password) {
//      debugPrint("本地password读取成功：$password\n");
//      passwordTextEditingController.text = password;
//    });

    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  // String _email, _password;
  bool _isObscure = true;
  Color _eyeColor;
  List _loginMethod = [
    {
      "title": "facebook",
      "icon": GroovinMaterialIcons.facebook,
    },
    {
      "title": "google",
      "icon": GroovinMaterialIcons.google,
    },
    {
      "title": "twitter",
      "icon": GroovinMaterialIcons.twitter,
    },
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<String> email = get("email");
    email.then((String email) {
      debugPrint("本地email读取成功：$email\n");
      // _email = email;
      emailTextEditingController.text = email;
//      setState(() {
//      });
    });
    Future<String> password = get("password");
    password.then((String password) {
      debugPrint("本地password读取成功：$password\n");
      //    _password = password;
      passwordTextEditingController.text = password;
//      setState(() {
//      });
    });
  }

  @override
  Widget build(BuildContext context) {
    LoadFromServer().getArticles();
    LoadFromServer().getTests();

    emailTextEditingController.addListener(() {
      debugPrint('email listener detected');

      // save("email", emailTextEditingController.text);
      // _email= emailTextEditingController.text;
      //debugPrint("email本地存储成功:$emailTextEditingController.text");
    });

    passwordTextEditingController.addListener(() {
      debugPrint('password listener detected');
      //  save("password", passwordTextEditingController.text);
      //    _password=passwordTextEditingController.text;
      //   debugPrint("password本地存储成功:$passwordTextEditingController.text");
    });

    return Scaffold(
        key: _scaffoldKey,
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 70.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
//                buildOtherLoginText(),
//                buildOtherMethod(context),
                buildRegisterText(context),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                //TODO 跳转到注册页面
                debugPrint('去注册');
                //               Navigator.pop(context);
//                Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SignupPage()) );
                Navigator.pushNamed(context, '/signuppage');
              },
            ),
          ],
        ),
      ),
    );
  }

  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(
                builder: (context) {
                  return IconButton(
                      icon: Icon(item['icon'],
                          color: Theme.of(context).iconTheme.color),
                      onPressed: () {
                        //TODO : 第三方登录方法
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("${item['title']}登录"),
                          action: new SnackBarAction(
                            label: "取消",
                            onPressed: () {},
                          ),
                        ));
                      });
                },
              ))
          .toList(),
    );
  }

  Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他账号登录',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Login',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.black,
          onPressed: () async {
            await LoadFromServer()
                .login(emailTextEditingController.text,
                passwordTextEditingController.text, context);
           // await new Future.delayed(new Duration(milliseconds: 500));
            _login(context);

            String userMessage;

            Main.loginInfo['username'] != null&&Main.loginInfo['username'] != ''
                ? userMessage = 'username: ' + Main.loginInfo['username']
                : userMessage = '';
            debugPrint("message:" +
                Main.loginInfo['message'] +
                "    username:" +
                Main.loginInfo['username']);

            showDialog<Null>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Message'),
                    children: <Widget>[
                      SimpleDialogOption(
                        child: Text(Main.loginInfo['message']),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SimpleDialogOption(
                        child: Text(userMessage),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            '忘记密码？',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: passwordTextEditingController,
      onSaved: (String value) {
        save("password", passwordTextEditingController.text);
        //    _password=passwordTextEditingController.text;
        debugPrint("password本地存储成功:$passwordTextEditingController.text");
      },
      obscureText: _isObscure,
      validator: (String value) {
        //      if (value.isEmpty)
        //         _password = value = passwordTextEditingController.text;
        if (passwordTextEditingController.text.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildEmailTextField() {
//    String emailText;
//    Future<String> email = get("email");
//    email.then((String email) {
//      debugPrint("本地email读取成功：$email\n");
//      emailText=email;
//    });

    return TextFormField(
      controller: emailTextEditingController,
      decoration: InputDecoration(
        labelText: 'Emall Address',
      ),
      validator: (String value) {
        //if (value.isEmpty) value = _email = emailTextEditingController.text;
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(value) &&
            !emailReg.hasMatch(emailTextEditingController.text)) {
          return '请输入正确的邮箱地址';
        }
      },
      onSaved: (String value) {
        save("email", emailTextEditingController.text);
        //    _password=passwordTextEditingController.text;
        debugPrint("email本地存储成功:$emailTextEditingController.text");
      },
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }

  void _login(BuildContext context) {
    Main.loginInfo['email'] = emailTextEditingController.text;
    if (_formKey.currentState.validate()) {
      ///只有输入的内容符合要求通过才会到达此处
      _formKey.currentState.save();
      //TODO 执行登录方法
      //             Navigator.pop(context);
      save("email", emailTextEditingController.text);
      save("password", passwordTextEditingController.text);
      debugPrint('本地存储并登录：email:' +
          emailTextEditingController.text +
          ' password:' +
          passwordTextEditingController.text);
      //           Navigator.push(context,new MaterialPageRoute(builder: (context)=>new Layout()) );

      //await

//      LoadFromServer()
//          .login(emailTextEditingController.text,
//              passwordTextEditingController.text, context);

      //    .whenComplete(() {
        // await new Future.delayed(new Duration(milliseconds: 200));


        Future<String> liked = get("likedArticles");
        liked.then((String liked) {
          Map<String, dynamic> articles;
          if (liked != 'null' && liked != '') {
            articles = json.decode(liked);
            debugPrint("读取本地收藏：" + articles.toString().substring(0, 10));

            //TODO 完善读取收藏
            for (int num = 10000; num > 9900; num--) {
              if (articles['article_id:$num'] != null) {
                Main.likedArticles.add(new Article(
                    articles['article_id:$num']['title'],
                    articles['article_id:$num']['content'],
                    articles['article_id:$num']['date'],
                    articles['article_id:$num']['pic'],
                    articles['article_id:$num']['author']));
              }
            }
          }//if liked
        });

        if (Main.loginInfo['flag'] != null &&
            Main.loginInfo['flag'] == 'true') {
          debugPrint(
              "navigator popAndPush success! context:" + context.toString());

          Main.loginInfo['flag'] == 'false';

//                  debugPrint('awaiting now');
//                  await new Future.delayed(new Duration(milliseconds: 1000));
//                  debugPrint('after await');

//          new Future((){
          debugPrint("navigator jump to main page");
      Navigator.pushReplacementNamed(context,'/home');

//          });

          //   return Navigator.popAndPushNamed(context, '/home');
        } else {
          debugPrint("navigator jump to login page");
          //return Navigator.popAndPushNamed(context, '/loginpage');
        }

//              //await
//              new Future.delayed(new Duration(milliseconds: 500))
//                  .whenComplete(() {
//                debugPrint("after delay");
//                return ;
//              });
    //  }); //whenComplete

      // flag=0;
    }
  }
}
