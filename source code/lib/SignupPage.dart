//
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:listener/WebSocket.dart';
import 'package:listener/main.dart' as Main;
//

//class SignupPage extends StatelessWidget {
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(title: Text('login')),
////        navigationBar: CupertinoNavigationBar(middle: Text('Login'),),
//        body: Center(
//            child: RaisedButton(
//                child: Text('enter'),
//                onPressed: () {
//                  Navigator.pop(context);
//                  Navigator.pushNamed(context, '/first');
//                })));
//  }
//}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _SignupKey = GlobalKey<FormState>();
  String _email, _password, _username;
  bool _isObscure = true;
  Color _eyeColor;
  List _SignupMethod = [
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _SignupKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 70.0),
                buildUsernameTextField(context),
                SizedBox(height: 30.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
//                buildForgetPasswordText(context),
                SizedBox(height: 60.0),
                buildSignupButton(context),
//                SizedBox(height: 30.0),
//                buildOtherSignupText(),
//                buildOtherMethod(context),
//                buildRegisterText(context),
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
                print('去注册');
                Navigator.pop(context);
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
      children: _SignupMethod.map((item) => Builder(
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
          )).toList(),
    );
  }

  Align buildOtherSignupText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他账号登录',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  Align buildSignupButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Signup',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.black,
          onPressed: () async {
            if (_SignupKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _SignupKey.currentState.save();
              //TODO 执行登录方法
              await LoadFromServer()
                  .signup(_username, _email, _password, context);

              // await new Future.delayed(new Duration(milliseconds: 500));
              debugPrint(Main.signupInfo['message']);
              Navigator.of(context).pop();

              _login(context);

            }
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

  TextFormField buildUsernameTextField(BuildContext context) {
    return TextFormField(
        onSaved: (String value) => _username = value,
        //obscureText: _isObscure,
        validator: (String value) {
          if (value.isEmpty) {
            return '请输入用户名';
          }
        },
        decoration: InputDecoration(
          labelText: 'Username',
        ));
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
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
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Emall Address',
      ),
      validator: (String value) {
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(value)) {
          return '请输入正确的邮箱地址';
        }
      },
      onSaved: (String value) => _email = value,
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
        'Signup',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }

  _login(BuildContext context){

    showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Message'),
            children: <Widget>[
//                        SimpleDialogOption(
//                          child: Text(Main.loginInfo['message']),
//                          onPressed: () {
//                            Navigator.of(context).pop();
//                          },
//                        ),
              SimpleDialogOption(
                child: Text(Main.signupInfo['message']),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    //Navigator.pop(context);
    print('email:$_email , password:$_password');
  }
}
