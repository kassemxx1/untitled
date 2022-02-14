import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/Login_Bloc/LoginCUbit.dart';
import 'package:untitled/Login_Bloc/Login_States.dart';

class Login_Screen extends StatelessWidget {
  static const String id = 'Login_Screen';
  TextEditingController UserController = TextEditingController();
  TextEditingController PassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          cubit.state;
          return Scaffold(
            backgroundColor: Colors.yellow,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Text(
                    '                          ISC-Power',
                    style: TextStyle(
                      fontSize: 30,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    '                                    APP',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  // Center(
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //               image: AssetImage("images/g.jpg"),
                  //               fit: BoxFit.scaleDown)),
                  //     )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: TextField(
                        controller: UserController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'User Name',
                          border: OutlineInputBorder(),
                          suffixIcon: UserController.text.isEmpty
                              ? Container(
                                  width: 0,
                                )
                              : IconButton(
                                  onPressed: () {
                                    UserController.clear();
                                  },
                                  icon: Icon(Icons.close),
                                ),
                        ),
                        keyboardType: TextInputType.name,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: TextField(
                        controller: PassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: PassController.text.isEmpty
                              ? Container(
                                  width: 0,
                                )
                              : IconButton(
                                  onPressed: () {
                                    PassController.clear();
                                  },
                                  icon: Icon(Icons.close),
                                ),
                        ),
                        keyboardType: TextInputType.name,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: Colors.blue,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        cubit.Login(
                            UserController.text, PassController.text, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
