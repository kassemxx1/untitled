import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/Bloc%20Provider/BLocProvider.dart';
import 'package:untitled/Bloc%20Provider/Bloc_State.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'Main_Screen.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
class Counter_Screen extends StatelessWidget {
  static const String id = 'Counter_Screen';
  static List<String> suggestions = [];
  static var TempList =[];
  static TextEditingController SearchController = TextEditingController();
  static var Clients = [];

  static var monthnumber='';

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
                      blocpro.getclients();
                    },
                    icon: Icon(Icons.update)),
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

                      },
                    )),
                Container(
                  height: 40,
                  child: Center(
                    child: Text(
                      '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
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
