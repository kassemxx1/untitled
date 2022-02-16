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

import 'Payment_Screen.dart';
class Bills_Screen extends StatelessWidget {
  static var TempList = [];
  static const String id = 'Bill_Screen';
  static TextEditingController SearchController = TextEditingController();
  static var Value ='names';
  static var Type='';
  static var ID ='';
  const Bills_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => BlocPro(),
        child:BlocConsumer<BlocPro, BlocState>(
      listener: (BuildContext context, state) {},
    builder: (BuildContext context, state) {
      BlocPro blocpro = BlocPro.get(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Bills',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(onPressed: () {
              blocpro.getallBills();
            }, icon: Icon(Icons.update)),
          ],
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                    Main_Screen.lastBillUpdate,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            CustomRadioButton(
              defaultSelected:"names" ,
              enableShape: false,
              elevation: 0,
              absoluteZeroSpacing: true,
              unSelectedColor: Colors.grey,
              selectedBorderColor: Colors.blueGrey,
              buttonLables: [
                'Name',
                'ID',
                'Bill',
              ],
              buttonValues: [
                "names",
                "clientcode",
                "billnumb",
              ],
              buttonTextStyle: ButtonTextStyle(

                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle:
                  TextStyle(fontSize: 18, color: Colors.white)),
              radioButtonValue: (value) {
                Bills_Screen.Type=value.toString();
                blocpro.getbillsuggestion(value.toString());

              },
              selectedColor: Theme.of(context).backgroundColor,
            ),
            Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: EasyAutocomplete(
                  controller: Bills_Screen.SearchController,
                  suggestions: Main_Screen.suggestionsbill,

                  onChanged: (value) {

                     blocpro.setInfobill(value,Bills_Screen.Type);

                  },
                )),
            Container(
              height: 40,
              child: Center(
                child: Text(
                  Bills_Screen.Value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                color: Colors.blueGrey,
                child: MaterialButton(
                  child: Text('Get',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {

                    blocpro.getBill(Bills_Screen.ID);
                    SearchController.clear();
                  },
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
                        width: MediaQuery.of(context).size.width*1.3/5,
                        child: Text('الاسم',style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),),
                      )
                  ),
                  DataColumn(
                      label: Container(
                        width: MediaQuery.of(context).size.width*0.9/5,
                        child: Text('شهر',style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),),
                      )
                  ),
                  DataColumn(
                      label: Container(
                        width: MediaQuery.of(context).size.width*0.9/5,
                        child: Text('المبلغ',style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),),
                      )
                  )
                ],
                rows: TempList.map((Bill) =>
                    DataRow(
                        onLongPress: (){
                          Payment_Screen.ID = Bill.ID;
                          Payment_Screen.name = Bill.name;
                          Payment_Screen.AcountCode = Bill.AcountCode;
                          Payment_Screen.netAmount = Bill.netAmount;
                          Payment_Screen.Balance = Bill.Balance;
                          Payment_Screen.MonthAr = Bill.MonthAr;
                          Payment_Screen.month = Bill.month;
                          Payment_Screen.Year = Bill.Year;
                          Payment_Screen.billnumb = Bill.billnumb;
                          Payment_Screen.schType = Bill.schType;
                          Payment_Screen.schCtrNbr = Bill.schNumber;
                          Payment_Screen.old = Bill.Prev;
                          Payment_Screen.New = Bill.Current;
                          Payment_Screen.price = Bill.Price;




                          Navigator.pushNamed(context, Payment_Screen.id);

                        },
                        cells:[
                          DataCell(
                            Text(
                              Bill.name,style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                            ),
                            ),
                          ),
                          DataCell(
                            Text(
                              Bill.MonthAr,style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                            ),
                          ),
                          DataCell(
                            Text(
                              Bill.Balance,style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red
                            ),
                            ),
                          ),


                        ] )).toList(),
              ),
            ),
          ],
        )
      );
    }

    )
    );
  }
}



class Bill {
  String ID;
  String name;
  String month;
  String Year;
  String Balance;
  String netAmount;
  String billnumb;
  String MonthAr;
  String AcountCode;
  String schType;
  String schNumber;
  String Prev;
  String Current;
  String Price;


  Bill(this.ID,this.name,this.month,this.Year,this.Balance,this.netAmount,this.billnumb,this.MonthAr,this.AcountCode,this.schType,this.schNumber,this.Prev,this.Current,this.Price);
}