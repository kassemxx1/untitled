import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Bloc%20Provider/Bloc_State.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Counter_Screen.dart';
import '../Main_Screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/Constants.dart';

class BlocPro extends Cubit<BlocState> {
  BlocPro() : super(initState());
  static BlocPro get(BuildContext context) {
    return BlocProvider.of(context);
  }

  void getclients() async {
    var clientdesc = [];
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    clientdesc.clear();
    Main_Screen.suggestions.clear();
    Main_Screen.loading = true;
    var url = Uri.parse(UrlHeroku.toString());
    var response = await http.get(url);
    var data = json.decode(response.body);
    for (var i in data['recordsets'][0]) {
      var id = i['clientcode'].toString();
      var name = i['clientName'].toString();
      var address = i['address'].toString();
      var box = i['boxcode'].toString();
      var phone = i['smsmobile'].toString();
      var areacode = i['areacode'].toString();

      clientdesc.add({
        'id': id,
        'name': name,
        'address': address,
        'box': box,
        'phone': phone,
        'areacode': areacode,
      });
    }
    _prefs.setString('lastupdate', DateTime.now().toString());
    _prefs.remove('allclients');
    _prefs.setString('allclients', json.encode(clientdesc));
    _prefs.setBool('first', false);
    Main_Screen.lastUpdate = formatDate(
            DateTime.parse(_prefs.getString('lastupdate').toString()),
            [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
        ': آخر تحديث';
    EasyLoading.dismiss();
    Main_Screen.loading = false;
    emit(getallclientcounterState());
  }

  void getlast() async {
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('first') == false) {
      Main_Screen.lastUpdate = formatDate(
              DateTime.parse(_prefs.getString('lastupdate').toString()),
              [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
          ': آخر تحديث';
    } else {
      Main_Screen.lastUpdate = 'Please Update';
    }
    EasyLoading.dismiss();
    emit(getlastupdateState());
  }

  void getsuggestion(String type) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allclients').toString());

    Main_Screen.suggestions.clear();
    for (var i in Clients) {
      if (type == 'name') {
        Main_Screen.suggestions.add(i['name'].toString());
      }
      if (type == 'box') {
        Main_Screen.suggestions.add(i['box'].toString());
      }
      if (type == 'id') {
        Main_Screen.suggestions.add(i['id'].toString());
      }
    }
    Counter_Screen.SearchController.text = ' ';
    Counter_Screen.SearchController.clear();
    emit(getsuggestionState());
  }

  void getmonth() async {
    Main_Screen.selectedmonths.clear();
    EasyLoading.show();
    var url = Uri.parse(UrlHeroku + 'getmonth');
    var response = await http.get(url);
    var data = json.decode(response.body);
    if (data['recordsets'][0].length > 0) {
      for (var i in data['recordsets'][0]) {
        Main_Screen.selectedmonths.add(i['schCtrNbr'].toString() +
            ':' +
            i['ctrMonth'].toString() +
            '-' +
            i['MonthAr'].toString() +
            '-' +
            i['ctrYear'].toString());
      }
      EasyLoading.dismiss();
    } else {
      Main_Screen.selectedmonths.add('no record');
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();

    emit(getmonthSTate());
  }

  void GetInfo(String value, String Type) async {
    EasyLoading.show();
    Counter_Screen.TempList.clear();
    setcontname(String n) {
      var n = TextEditingController();
      return n;
    }

    var url = Uri.parse(UrlHeroku + 'getcounters');
    Map<String, dynamic> bbb = {
      'Option': Type == 'box' ? 2 : 1,
      //   'CodeId': Type == 'box' ? Value : getId(Value),
      'month': DateTime.now().month,
    };
    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      for (var i in data['recordsets'][0]) {
        Counter_Screen.TempList.add(client(
          i['clientcode'].toString(),
          i['clientName'].toString(),
          i['prevCtr'].toString(),
          i['newCtr'].toString(),
          setcontname(
              'controller' + Counter_Screen.Clients.indexOf(i).toString()),
          false,
        ));

        EasyLoading.dismiss();
      }
      if (data['recordsets'].lengh == 0) {
        Fluttertoast.showToast(
            msg: "غير مسموح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (err) {
      Fluttertoast.showToast(
          msg: "internet problem",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      EasyLoading.dismiss();
    }

    EasyLoading.dismiss();
  }
}
