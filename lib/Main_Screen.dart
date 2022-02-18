import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Bills_Screen.dart';
import 'package:untitled/Bloc%20Provider/BLocProvider.dart';
import 'package:untitled/Bloc%20Provider/Bloc_State.dart';
import 'Counter_Screen.dart';
import 'Login_Screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Setting_Screen.dart';
class Main_Screen extends StatelessWidget {

  static const String id = 'Main_Screen';
  static List<String> suggestions = [];
  static bool loading = false;
  static var lastUpdate = '';
  static List<String> selectedmonths = [];
  static List<String> suggestionsbill = [];
  static bool loadingbill = false;
  static var lastBillUpdate = '';
  static var counter =0;
  static var totalcounter=0;
  const Main_Screen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => BlocPro(),
        child: BlocConsumer<BlocPro, BlocState>(

            listener: (BuildContext context, state) {

            },
            builder: (BuildContext context, state) {
             // BlocProvider.of<BlocPro>(context).getrecords(3);
              BlocPro blocpro = BlocPro.get(context);
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Hero(
                      tag: 'test',
                      child: Text('Home',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),)),
                  actions: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.exit_to_app)),
                  ],
                  iconTheme: IconThemeData(color: Colors.black),
                ),
                drawer: Drawer(
                    child: Container(
                  child: ListView(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.yellowAccent,
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,width: 2),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(100),
                                bottomRight: Radius.elliptical(100, 100))),
                        child:Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.yellowAccent,
                            height: MediaQuery.of(context).size.height / 4,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey,width: 2),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(100),
                                    bottomRight: Radius.elliptical(100, 100))),


                          ),
                        ) ,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, Setting_Secreen.id);
                      },
                      child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey,width: 2),
                              ),


                              height: 50,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Center(
                                  child: Text(
                                'Setting',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                ),
                              )))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        SharedPreferences _prefs =
                            await SharedPreferences.getInstance();
                        _prefs.remove('user');
                        _prefs.remove('pass');
                        Navigator.pushNamed(context, Login_Screen.id);
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,width: 2),
                          ),
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          child: Center(
                            child: Text('Sign Out',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                                )),
                          ),
                        ),
                      ),
                    ),
                  ]),
                )),
                body: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          blocpro.getlast(Main_Screen.lastUpdate);
                          Counter_Screen.TempList.clear();
                          blocpro.getsuggestion('name');
                          Navigator.pushNamed(context, Counter_Screen.id);
                        },
                        child: Card(
                          elevation: 20,
                          child: Container(

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey,width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lightbulb,
                                      color: Colors.yellow,
                                      size: 50,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Counter',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          blocpro.getlast(Main_Screen.lastBillUpdate);
                          blocpro.setInfobill('', '');
                          blocpro.getbillsuggestion("names");
                          Navigator.pushNamed(context, Bills_Screen.id);
                          Bills_Screen.SearchController.text = ' ';
                        },
                        child: Card(
                          elevation: 20,
                          child: Container(

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey,width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.article_outlined,
                                      color: Colors.pinkAccent,
                                      size: 50,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Bills',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Card(
                          elevation: 20,
                          child: Container(

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey,width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('عدادات',style: TextStyle(fontSize: 15,color: Colors.red,),),

                                    Text(Main_Screen.counter.toString(),style: TextStyle(fontSize: 25,color: Colors.greenAccent,fontWeight: FontWeight.bold),),
                                    Divider(
                                      color: Colors.black,
                                    ),
                                    Text(Main_Screen.totalcounter.toString(),style: TextStyle(fontSize: 25,color: Colors.red,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                           Navigator.pushNamed(context, Setting_Secreen.id);
                        },
                        child: Card(
                          elevation: 20,
                          child: Container(

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey,width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      color: Colors.blue,
                                      size: 50,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Setting',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              );
            }));
  }
}
