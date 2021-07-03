import 'package:chat/pages/register_page.dart';
import 'package:chat/routes/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: RegisterPage.routeName,
      routes: appRoutes,
    );
  }
}