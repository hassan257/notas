import 'package:flutter/material.dart';
import 'package:notas/src/pages/home_page.dart';

import 'src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas',
      initialRoute: 'home',
      routes: getApplicationRoutes(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => HomePage());
      },
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
    );
  }
}
