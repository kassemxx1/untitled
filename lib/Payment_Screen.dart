import 'dart:convert';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:untitled/Constants.dart';
import 'Main_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
class Payment_Screen extends StatefulWidget {
  static const String id = 'Payment_Screen';
  static var ID = '';
  static var name = '';
  static var month = '';
  static var Year = '';
  static var Balance = '';
  static var netAmount = '';
  static var billnumb = '';
  static var MonthAr = '';
  static var AcountCode = '';
  static var schType = '';
  static var schCtrNbr = '';
  static var old = '';
  static var New = '';
  static var Fixed = '';
  static var extra = '';
  static var price = '';
  static var Counter = '';

  const Payment_Screen({Key? key}) : super(key: key);

  @override
  _Payment_ScreenState createState() => _Payment_ScreenState();
}

class _Payment_ScreenState extends State<Payment_Screen> {
  TextEditingController AmountController = TextEditingController();
  //BlueThermalPrinter printer = BlueThermalPrinter.instance;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  // List<BluetoothDevice> devices = [];
  // BluetoothDevice? selectedDevice;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;


  void getdevicefromecache() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try  {
      _devices = await bluetooth.getBondedDevices();

    } on PlatformException {
      // TODO - Error
    }
    if(_devices.isEmpty){
      Fluttertoast.showToast(
          msg: 'no printer found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else{
      _devices.forEach((device) {
        if (device.address.toString() == _prefs.getString('device')) {
          setState(() {
            _device = device;
          });
          try{
            bluetooth.connect(_device!);
            if(bluetooth.isConnected ==true ){
              Fluttertoast.showToast(
                  msg: 'printer connected',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }

          }
          catch(err){
            Fluttertoast.showToast(
                msg: 'printer not connected',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }


        }
      });
    }


  }



  void getSumOfCounter() {
    if (int.parse(Payment_Screen.New) - int.parse(Payment_Screen.old) < 0) {
      setState(() {
        Payment_Screen.Counter = '0';
      });
    } else {
      setState(() {
        Payment_Screen.Counter =
            (int.parse(Payment_Screen.New) - int.parse(Payment_Screen.old))
                .toString();
      });
    }
    setState(() {
      AmountController.text = Payment_Screen.Balance;
    });
  }
  void Pay() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    EasyLoading.show();
    var url = Uri.parse(UrlHeroku + 'Pay');
    Map<String, dynamic> bbb = {
      'Option': 1 ,
      'PostCode':'',
      'schNumber':int.parse(Payment_Screen.schCtrNbr),
      'schMonth':int.parse(Payment_Screen.month),
      'schYear':int.parse(Payment_Screen.Year),
      'clientId':Payment_Screen.ID,
      'AccountCode':Payment_Screen.AcountCode,
      'fctnbr':int.parse(Payment_Screen.billnumb),
      'paidType':Payment_Screen.schType,
      'PaidAmount':double.tryParse(AmountController.text),
      'userName':_prefs.getString('user'),
    };
    try{
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      if (data['state'] == 1) {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength:
            Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        // setState(() {
        //   Bill_Screen.client = Payment_Screen.ID;
        // });

        EasyLoading.dismiss();
        invoices();
        Navigator
            .of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => Main_Screen()));
        // PrintPDf();
      }
      if (data['state'] == 0) {
        Fluttertoast.showToast(
            msg: "something wrong",
            toastLength:
            Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        EasyLoading.dismiss();
      }
      if (data['state'] == 2) {
        Fluttertoast.showToast(
            msg: "error",
            toastLength:
            Toast.LENGTH_SHORT,
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
          msg: "connection error",
          toastLength:
          Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      EasyLoading.dismiss();
    }

  }
//   Future<void> PrintPDf() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
//     final font = await PdfGooglexSansArabicRegular();
//     // final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.roll80,
//         build: (pw.Context context) => pw.Center(
//           child: pw.Column(children: [
//             pw.Row(
//               children: [
//                 pw.Text('Collector',),
//                 pw.Text(_prefs.getString('user').toString())
//               ]
//             ),
//             pw.Row(
//                 children: [
//                   pw.Text('Invoice Number',),
//                   pw.Text(Payment_Screen.billnumb)
//                 ]
//             ),
//             pw.Row(
//                 children: [
//                   pw.Text('Client Name',),
//                   pw.Text(Payment_Screen.name)
//                 ]
//             ),
//             pw.Row(
//                 children: [
//                   pw.Text('Month',),
//                   pw.Text(Payment_Screen.MonthAr)
//                 ]
//             ),
//
//
//
//           ]),
//         ),
//       ),
//     );
//     final output = await getTemporaryDirectory();
//     final file = File('${output.path}/example.pdf');
// //   await file.writeAsBytes(await pdf.save());
//   //  await Printing.sharePdf(bytes: await pdf.save(), filename: 'example.pdf');
//      await Printing.layoutPdf(
//          onLayout: (PdfPageFormat format) async => pdf.save());
//
//     // await PdfPreview(
//     //    build: (format) => pdf.save(),
//     //  );
//   }
  void invoices() {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.printNewLine();
    bluetooth.printCustom('  اشتراك الوفا  ', 3, 1);
    bluetooth.printCustom(' بترو الشرق - محطة غبريس  ', 1, 1);
    bluetooth.printCustom('  03215209   70215209  ', 1, 1);
    bluetooth.printCustom('  07766765   76449856  ', 1, 1);
    bluetooth.printCustom( ' '+' kassem abboud ' + '  اسم الجابي ', 1, 1);
    bluetooth.printCustom(' ' + DateTime.now().toString(), 1, 1);
    bluetooth.printCustom('  ------------------  ', 3, 1);
    bluetooth.printCustom( Payment_Screen.billnumb + '  عن '+' '+Payment_Screen.MonthAr , 1, 1);
    bluetooth.printCustom(  ' المشترك '+' '+Payment_Screen.name , 2, 1);
    bluetooth.printCustom(  '  = 1 kilowatt ' +''+Payment_Screen.price , 1, 1);
    bluetooth.printCustom( ' '+Payment_Screen.old + '  عداد سابق ', 1, 1);
    bluetooth.printCustom( ' '+Payment_Screen.New + '  عداد حالي ', 1, 1);
    bluetooth.printCustom( ' '+Payment_Screen.Counter + '  الكمية ', 1, 1);
    bluetooth.printCustom('  ------------------  ', 3, 1);
    bluetooth.printCustom( ' '+Payment_Screen.Balance.toCurrencyString(thousandSeparator: ThousandSeparator.Comma) + '  المبلغ ', 3, 1);
    bluetooth.printCustom( ' '+AmountController.text.toCurrencyString(thousandSeparator: ThousandSeparator.Comma) + '  دفعة ', 3, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom(  '  نشكر تعاونكم ', 3, 1);
    bluetooth.printNewLine();
    bluetooth.printNewLine();


  }


  @override
  void initState() {
    getdevicefromecache();
    getSumOfCounter();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [

          SizedBox(
            height: 20,
          ),

          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  'شهر',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  Payment_Screen.MonthAr +
                                      '/' +
                                      Payment_Screen.Year,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  'رقم الفاتورة',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  Payment_Screen.billnumb,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  'المبلغ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  Payment_Screen.Balance,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'التفاصيل',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  'عداد سابق',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  Payment_Screen.old,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  'عداد حالي',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  Payment_Screen.New,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  'المصروف',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  Payment_Screen.Counter,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: AmountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(32.0),
                        ),
                      ),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: MaterialButton(
              color: Colors.blue,
              child: Text(
                'PAY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Pay();
              },
            ),
          ),
        ],
      ),
    );
  }
}
