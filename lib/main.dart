import 'package:flutter/material.dart';
import 'package:flutter_aten/formlogin/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aten/providers/user_provider.dart';

import 'formlogin/regiter.dart';
import 'page/insertProduct.dart';
import 'screen/AdminPage.dart';
import 'screen/UserPage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // กำหนด UserProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
          title: 'Login Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/home': (context) => UserPage(),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/admin': (context) => Adminpage(),
            '/insertProduct': (context) => insertProduct(),
          }),
    );
  }
}
