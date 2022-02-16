import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Bills_Screen.dart';
import 'package:untitled/Bloc%20Provider/Bloc_State.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Counter_Screen.dart';
import '../Counter_Screen.dart';
import '../Main_Screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BlocPro extends Cubit<BlocState> {
  BlocPro() : super(initState());
  static BlocPro get(BuildContext context) {
    return BlocProvider.of(context);
  }
//get all information of clients and set to cache
  void getclients() async {
    var clientdesc = [];
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    clientdesc.clear();
    Main_Screen.suggestions.clear();
    Main_Screen.loading = true;
    var url = Uri.parse(UrlHeroku.toString() + 'getallclientcounter');
    try{

      var response = await http.get(url);
      var data = json.decode(response.body);
      if (data['rowsAffected'][0] >0){
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
      }
      else{
        Fluttertoast.showToast(
            msg: "not allowed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);

        EasyLoading.dismiss();
      }

    }
    catch(err){
      Fluttertoast.showToast(
          msg: "error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

      EasyLoading.dismiss();
    }

    emit(getallclientcounterState());
  }
//get the time of las update
  void getlast(String last) async {
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('first') == false) {
      last = formatDate(
              DateTime.parse(_prefs.getString('lastupdate').toString()),
              [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
          ': آخر تحديث';
    } else {
      last = 'Please Update';
    }
    EasyLoading.dismiss();
    emit(getlastupdateState());
  }
//get the suggestion list of clients
  void getsuggestion(String type) async {
    Counter_Screen.Type = type;
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
// get the months number
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
//get all info for selected value to enter the new counter
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
      'CodeId': Type == 'name' ? Counter_Screen.ID : Counter_Screen.Value,
      'month': 1,
    };
    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      if (data['recordsets'].length > 0) {
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
          Fluttertoast.showToast(
              msg: "success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          EasyLoading.dismiss();
        }
      }
      if (data['recordsets'].length == 0) {
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
      print(err);
      EasyLoading.dismiss();
    }
    print(Counter_Screen.TempList);
    EasyLoading.dismiss();
    emit(getInfoState());
  }
// set the value and get the id of selected client
  void setInfo(String value) async {
    Counter_Screen.Value = value;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allclients').toString());
    for (var i in Clients) {
      if (i['name'] == value) {
        Counter_Screen.ID = i['id'];
      }
    }

    emit(setInfoState());
  }
  //get all the clients not filled counter
  void getnotfilled() async {
    EasyLoading.show();

    Counter_Screen.TempList.clear();
    setcontname(String n) {
      var n = TextEditingController();
      return n;
    }

    var url = Uri.parse(UrlHeroku.toString() + 'getcounters');
    Map<String, dynamic> bbb = {
      'Option': 7,
      'CodeId': '',
      'month': 1,
    };
    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      if (data['recordsets'][0].length > 0) {
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
          Fluttertoast.showToast(
              msg: "success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          EasyLoading.dismiss();
        }
      }

      if (data['rowsAffected'][0].toString() == '0') {
        Fluttertoast.showToast(
            msg: "Completed or not allowed",
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
    emit(getNotFilledState());
  }

////////////////////bills///////////////////////////////////////////////////

  //Get the info of all bills
  void getallBills() async {
    var clientdesc = [];
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    clientdesc.clear();
    Main_Screen.suggestionsbill.clear();
    Main_Screen.loadingbill = true;
    var url = Uri.parse(UrlHeroku + 'getbills');
    try {
      var response = await http.get(url);
      var data = json.decode(response.body);
      for (var i in data['recordsets'][0]) {
        var monthnumb = i['schMonth'].toString();
        var yearnumb = i['schYear'].toString();
        var clientcode = i['ClientCode'].toString();
        var names = i['Names'].toString();
        var billnumb = i['fctnbr'].toString();
        var smsmobile = i['smsmobile'].toString();
        var PrevCounter = i['PrevCounter'].toString();
        var CurCounter = i['CurCounter'].toString();
        var FixCost = i['FixCost'].toString();
        var CtrQty = i['CtrQty'].toString();
        var XtraQty = i['XtraQty'].toString();
        var Uprice = i['Uprice'].toString();

        clientdesc.add({
          'monthnumb': monthnumb,
          'yearnumb': yearnumb,
          'clientcode': clientcode,
          'names': names,
          'billnumb': billnumb,
          'smsmobile': smsmobile,
          'PrevCounter': PrevCounter,
          'CurCounter': CurCounter,
          'FixCost': FixCost,
          'CtrQty': CtrQty,
          'XtraQty': XtraQty,
          'Uprice': Uprice,
        });
      }
      _prefs.setString('lastupdatebill', DateTime.now().toString());
      _prefs.remove('allbills');
      _prefs.setString('allbills', json.encode(clientdesc));
      _prefs.setBool('second', false);

      Main_Screen.lastBillUpdate = formatDate(
              DateTime.parse(_prefs.getString('lastupdatebill').toString()),
              [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
          ': آخر تحديث';

      EasyLoading.dismiss();
      print(data);
      Main_Screen.loadingbill = false;
    } catch (err) {
      print(err);
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
    emit(getallbillsState());
  }
//get the suggestion list of bills
  void getbillsuggestion(String type) async {
    Main_Screen.suggestionsbill.clear();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allbills').toString());
    for (var i in Clients) {
      if (type == 'names') {
        Main_Screen.suggestionsbill.add(i['names'].toString());
      }
      if (type == 'clientcode') {
        Main_Screen.suggestionsbill.add(i['clientcode'].toString());
      }
      if (type == 'billnumb') {
        Main_Screen.suggestionsbill.add(i['billnumb'].toString());
      }
    }
    Bills_Screen.SearchController.text = ' ';
    Bills_Screen.SearchController.clear();
    EasyLoading.dismiss();
    emit(getbillsuggestionState());
  }
// set the value and get the id of selected client
  void setInfobill(String value, String type) async {
    Bills_Screen.Value = value;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allbills').toString());
    if (type == 'names') {
      for (var i in Clients) {
        if (i['names'] == value) {
          Bills_Screen.ID = i['clientcode'].toString();
        }
      }
    }
    if (type == 'billnumb') {
      for (var i in Clients) {
        if (i['billnumb'] == value) {
          Bills_Screen.ID = i['clientcode'].toString();
        }
      }
    }
    if (type == 'clientcode') {
      Bills_Screen.ID = value;
    }
    emit(setInfobillState());
  }
// get the specific bill of selected client
  void getBill(String id) async {
    EasyLoading.show();
    Bills_Screen.TempList.clear();
    var url = Uri.parse(UrlHeroku + 'getSpecificbill');
    try {
      Map<String, dynamic> bbb = {
        'year': DateTime.now().year,
        'month': 2,
        'id': Bills_Screen.ID,
      };
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      for (var i in data['recordsets'][0]) {
        Bills_Screen.TempList.add(Bill(
            i['ClientCode'].toString(),
            i['Names'].toString(),
            i['schMonth'].toString(),
            i['schYear'].toString(),
            i['balance'].toString(),
            i['netAmount'].toString(),
            i['fctnbr'].toString(),
            i['MonthAr'],
            i['AccountCode'].toString(),
            i['schType'].toString(),
            i['schNumber'].toString(),
            i['PrevCounter'].toString(),
            i['CurCounter'].toString(),
            i['Uprice'].toString()));
      }
      EasyLoading.dismiss();
      print(Bills_Screen.TempList);
    } catch (err) {
      print(err);
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
    emit(getBillState());
  }
}
