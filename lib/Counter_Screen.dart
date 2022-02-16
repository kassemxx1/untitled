import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/Bloc%20Provider/BLocProvider.dart';
import 'package:untitled/Bloc%20Provider/Bloc_State.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:untitled/Constants.dart';
import 'Main_Screen.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
class Counter_Screen extends StatelessWidget {
  static const String id = 'Counter_Screen';
  static List<String> suggestions = [];
  static var TempList =[];
  static TextEditingController SearchController = TextEditingController();
  static var Clients = [];
  static var Value='';
  static var Type = '';
  static var ID ='';

  static var monthnumber='';
  bool checkifnum(String Numb) {
    if (int.tryParse(Numb) == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BlocPro(),
      child: BlocConsumer<BlocPro, BlocState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          BlocPro blocpro = BlocPro.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Counters',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                    onPressed: () {
                      blocpro.getnotfilled();
                    },
                    icon: Icon(Icons.filter_alt)),
                IconButton(
                    onPressed: () {
                      blocpro.getclients();
                    },
                    icon: Icon(Icons.refresh,size: 40,)),

              ],
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: ListView(
              children: [
                Center(
                  child: DropDown(
                    items:Main_Screen.selectedmonths,
                    hint: Text("month"),
                    onChanged: (value) =>{
                      monthnumber =value.toString() ,
                    },

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    Main_Screen.lastUpdate,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
                CustomRadioButton(
                  defaultSelected: 'name',
                  enableShape: false,
                  elevation: 0,
                  absoluteZeroSpacing: true,
                  unSelectedColor: Colors.grey,
                  selectedBorderColor: Colors.grey,
                  buttonLables: [
                    'name',
                    'box',
                    'id',
                  ],
                  buttonValues: [
                    "name",
                    "box",
                    "id",
                  ],
                  buttonTextStyle: ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.black,
                      textStyle: TextStyle(fontSize: 16, color: Colors.white)),
                  radioButtonValue: (value) {
                    Counter_Screen.TempList.clear();
                    blocpro.getsuggestion(value.toString());
                  },
                  selectedColor: Theme.of(context).backgroundColor,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: EasyAutocomplete(
                      controller: SearchController,
                      suggestions: Main_Screen.suggestions,
                      autofocus: false,
                      onChanged: (value) {

                        blocpro.setInfo(value.toString());


                      },
                    )),
                Container(
                  height: 40,
                  child: Center(
                    child: Text(
                      Counter_Screen.Value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Card(
                    elevation: 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      color: Colors.grey,
                      child: MaterialButton(
                        child: Text('Get',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          SearchController.clear();
                        //  blocpro.setId(Counter_Screen.Value,Counter_Screen.Type);

                          blocpro.GetInfo(Counter_Screen.Value, Counter_Screen.Type);
                        },
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 70,
                    columns: [
                      DataColumn(
                          label: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              'Name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              'Old Counter',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ))),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                      child: Text('New Counter',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ))),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Center(
                                      child: Text('#',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ))),
                                )
                              ],
                            ),
                          )),
                    ],
                    rows: TempList.map((client) =>
                        DataRow(selected: true, cells: [
                          DataCell(
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                client.name,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Center(
                                                child: Text(
                                                  client.LastCounter,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: TextField(
                                            controller: client.cont,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: client.CurrentCounter
                                                  .toString(),
                                              errorText: client._validate
                                                  ? 'Wrong Input'
                                                  : null,
                                            ),
                                            keyboardType: TextInputType.number,
                                          )),
                                      Expanded(
                                        flex: 4,
                                        child: MaterialButton(
                                          onPressed: () async {
                                            print(checkifnum(client.cont.text));
                                            if (checkifnum(client.cont.text
                                                .toString()) ==
                                                true ||
                                                int.parse(client.cont.text) <
                                                    int.parse(
                                                        client.LastCounter)) {

                                                client._validate = true;

                                            } else {

                                                client._validate = false;

                                              SharedPreferences _prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                              EasyLoading.show();
                                              var url = Uri.parse(
                                                  UrlHeroku+
                                                      'transaction');

                                              Map<String, dynamic> bbb = {
                                                'id': client.id.toString(),
                                                'counter':
                                                int.parse(client.cont.text),
                                                'userName': _prefs
                                                    .getString('user')
                                                    .toString(),

                                              };
                                              try {

                                                var response = await http.post(
                                                    url,
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                      'application/x-www-form-urlencoded; charset=UTF-8',
                                                    },
                                                    body: json.encode(bbb));
                                                var data =
                                                json.decode(response.body);
                                                if (data['state'] == 1) {
                                                  Fluttertoast.showToast(
                                                      msg: "Success",
                                                      toastLength:
                                                      Toast.LENGTH_SHORT,
                                                      gravity:
                                                      ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                      Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                  // client.cont.clear();
                                                  EasyLoading.dismiss();
                                                }
                                                if (data['state'] == 2) {
                                                  Fluttertoast.showToast(
                                                      msg: "error",
                                                      toastLength:
                                                      Toast.LENGTH_SHORT,
                                                      gravity:
                                                      ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                      Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                  EasyLoading.dismiss();
                                                }
                                              } catch (err) {
                                                Fluttertoast.showToast(
                                                    msg: "internet problem",
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity:
                                                    ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                    Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                EasyLoading.dismiss();
                                              }
                                            }

                                          },
                                          child: Text(
                                            'Submit',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20),
                                          ),
                                        ),
                                      )
                                    ],
                                  )), onLongPress: () {
                            var phonenumber = '';
                            for (var i in Clients) {
                              if (i['id'] == client.id) {

                                  phonenumber = i['phone'];

                              }
                            }
                            //print(getPhone(client.id));

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.yellowAccent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Text('id:' + client.id),
                                          Text('name:' + client.name),
                                          Text('PhoneNumber :' + phonenumber),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('done'),
                                      )
                                    ],
                                  );
                                });
                          }),
                        ])).toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class client {
  bool _validate;
  String id;
  String name;
  String LastCounter;
  String CurrentCounter;
  TextEditingController cont;
  client(this.id, this.name, this.LastCounter, this.CurrentCounter, this.cont,
      this._validate);
}