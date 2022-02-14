import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:untitled/Counter_Screen.dart';
import 'package:untitled/Login_Screen.dart';

import 'Main_Screen.dart';
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
      initialRoute: Login_Screen.id,
      routes: {
        Splash.id: (context) => Splash(),
        Login_Screen.id:(context) =>Login_Screen(),
        Main_Screen.id:(context) =>Main_Screen(),
        Counter_Screen.id:(context) =>Counter_Screen(),
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




  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.blue,
          )),
    );
  }
}

