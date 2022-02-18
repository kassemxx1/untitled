import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:untitled/Bills_Screen.dart';
import 'package:untitled/Constants.dart';
import 'package:untitled/Counter_Screen.dart';
import 'package:untitled/Login_Screen.dart';
import 'package:untitled/Payment_Screen.dart';
import 'package:untitled/Setting_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Main_Screen.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp( Power());
}

class Power extends StatefulWidget {
  const Power({Key? key}) : super(key: key);

  @override
  _PowerState createState() => _PowerState();
}

class _PowerState extends State<Power> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (context) => Splash(),
        Login_Screen.id:(context) =>Login_Screen(),
        Main_Screen.id:(context) =>Main_Screen(),
        Counter_Screen.id:(context) =>Counter_Screen(),
        Bills_Screen.id:(context) => Bills_Screen(),
        Payment_Screen.id:(context) =>Payment_Screen(),
        Setting_Secreen.id:(context) => Setting_Secreen(),
      },
    );
  }
}


class Splash extends StatefulWidget {
  static const String id = 'main';
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var Name = '';
  var Pass = '';
  var postcode ='';
  void initialization() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getString('user') == null) {
      Navigator.pushNamed(context, Login_Screen.id);
    } else {
      setState(() {
        Name = _prefs.getString('user').toString();
        Pass = _prefs.getString('pass').toString();
        postcode = _prefs.getString('postcode').toString();

      });
      print(Name);
      login(Name, Pass,postcode);
    }
  }

  void login(String user, String pass,String postcode) async {
    var url = Uri.parse(UrlHeroku.toString() + 'login');
    Map<String, dynamic> bbb = {
      'user': user,
      'password': pass,
      'postcode':postcode,
    };
    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      if (data['recordset'][0].length >0 ) {
        // Navigator.pushNamed(context, Main_Screen.id);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Main_Screen()));
      }
      else
      {
        // Navigator.pushNamed(context, Login_Screen.id);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Login_Screen()));
        print('ksm0');
      }

    } catch (err) {
      //Navigator.pushNamed(context, Login_Screen.id);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Login_Screen()));
      print('ksm3');
    }
  }

  @override
  void initState() {
    initialization();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.yellowAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children:[

              Hero(
                tag: 'test',
                child: Text(
                  '                          ISC-Power',
                  style: TextStyle(
                    fontSize: 30,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                '                                    APP',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              // Center(
              //     child: Container(
              //       decoration: BoxDecoration(
              //           image: DecorationImage(
              //               image: AssetImage("images/g.jpg"),
              //               fit: BoxFit.scaleDown)),
              //     )),

]
        )
        ),
      ),
    );
  }
}