import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Bloc%20Provider/BLocProvider.dart';
import 'package:untitled/Bloc%20Provider/Bloc_State.dart';
import 'Counter_Screen.dart';
import 'Login_Screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class Main_Screen extends StatelessWidget {
  static const String id = 'Main_Screen';
  static List<String> suggestions = [];
  static bool loading = false;
  static var lastUpdate = '';
  static List<String> selectedmonths =[];
  const Main_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>BlocPro(),
      child: BlocConsumer<BlocPro, BlocState>(
        listener: (BuildContext context, state) {},
    builder: (BuildContext context, state){
    BlocPro blocpro = BlocPro.get(context);
      return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(onPressed: (){} ,
                icon: Icon(Icons.exit_to_app)),

          ],
          iconTheme: IconThemeData(color: Colors.black),

        ),

        drawer: Drawer(

            child: Container(

              child: ListView(
                  children:[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.yellowAccent,
                      height: MediaQuery.of(context).size.height/4,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(100),bottomRight: Radius.elliptical(100, 100))
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    MaterialButton(
                      onPressed: (){
                       // Navigator.pushNamed(context, Setting_Secreen.id);

                      },
                      child: Center(
                          child: Container(
                              color: Colors.blueGrey,
                              height: 50,
                              width: MediaQuery.of(context).size.width/2,
                              child: Center(child: Text('Setting',style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,

                              ),)))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      onPressed: () async{
                        SharedPreferences _prefs = await SharedPreferences.getInstance();
                        _prefs.remove('user');
                        _prefs.remove('pass');
                        Navigator.pushNamed(context, Login_Screen.id);
                      },
                      child: Center(
                        child: Container(
                          color: Colors.blueGrey,
                          height: 50,
                          width: MediaQuery.of(context).size.width/2,
                          child: Center(
                            child: Text('Sign Out',style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,

                            )),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            )
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  blocpro.getlast();
                  blocpro.getmonth();
                  blocpro.getsuggestion('name');
                  Navigator.pushNamed(context, Counter_Screen.id);
                },
                child: Card(
                  elevation: 20,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lightbulb,color: Colors.yellow,size: 50,),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Counter',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,color: Colors.black),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     elevation: 20,
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: CircularStepProgressIndicator(
            //         totalSteps: int.parse(totalcounter.toString()),
            //         currentStep: int.parse(counter.toString()),
            //         stepSize: 10,
            //         selectedStepSize: 25,
            //         unselectedStepSize: 25,
            //         selectedColor: Colors.red,
            //         unselectedColor: Colors.purple[400],
            //         child: Center(child: Text(counter.toString() +'/' + totalcounter.toString(),style: TextStyle(
            //           fontSize: 15,
            //         ),)),
            //
            //         roundedCap: (_, __) => true,
            //
            //
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                 // Navigator.pushNamed(context, Bill_Screen.id);
                },
                child: Card(
                  elevation: 20,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.article_outlined,color: Colors.pinkAccent,size: 50,),
                        SizedBox(height: 20,),
                        Text('Bills',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,color: Colors.black),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     elevation: 20,
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: CircularStepProgressIndicator(
            //         totalSteps: totalBills ,
            //         currentStep: bills,
            //         stepSize: 10,
            //         selectedStepSize: 25,
            //         unselectedStepSize: 25,
            //         selectedColor: Colors.greenAccent,
            //         unselectedColor: Colors.yellowAccent,
            //         child: Center(child: Text(bills.toString() +'/' + totalBills.toString(),style: TextStyle(
            //           fontSize: 15,
            //         ),)),
            //
            //         roundedCap: (_, __) => true,
            //
            //
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                 // Navigator.pushNamed(context, Setting_Secreen.id);
                },
                child: Card(
                  elevation: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings,color: Colors.blue,size: 50,),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Setting',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,color: Colors.black),),


                    ],
                  ),
                ),
              ),
            )
          ],
        ),

      );

    }
      ));
  }
}
