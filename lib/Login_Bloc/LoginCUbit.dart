import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Bloc%20Provider/Bloc_State.dart';
import 'package:untitled/Login_Bloc/Login_States.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:untitled/Main_Screen.dart';
import 'package:untitled/Constants.dart';
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(initLogin()) {
        (BuildContext con) async {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      print(_prefs.getString('user').toString() + 'mnmnnmm');
      emit(initLogin());
    };
  }
  static LoginCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  void Login(String user, String pass, BuildContext cont) async {
    var url = Uri.parse(UrlHeroku +'login');
    Map<String, dynamic> bbb = {
      'user': user,
      'password': pass,
    };
    EasyLoading.show();

    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      if (data['rowsAffected'][0] > 0) {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('user', user);
        _prefs.setString('pass', pass);
        _prefs.setString(
            'username',
            data['recordset'][0]['firstName'].toString() +
                ' ' +
                data['recordset'][0]['lastName'].toString());
        _prefs.setString(
            'userRole', data['recordset'][0]['userRole'].toString());
        _prefs.setString(
            'postCode', data['recordset'][0]['postCode'].toString());
        _prefs.setString(
            'BiosSerial', data['recordset'][0]['BiosSerial'].toString());
        EasyLoading.dismiss();
        Navigator.pushReplacement(
            cont,
            new MaterialPageRoute(
                builder: (BuildContext context) => new Main_Screen()));
      } else if (data['rowsAffected'][0] == 0) {
        Fluttertoast.showToast(
            msg: "Wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        EasyLoading.dismiss();
      }
    } catch (err) {
      Fluttertoast.showToast(
          msg: "connection error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      EasyLoading.dismiss();
    }
    emit(LoginFunc());
  }





}
