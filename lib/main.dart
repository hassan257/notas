import 'package:flutter/material.dart';
import 'package:notas/src/pages/home_page.dart';
import 'package:notas/src/providers/db_provider.dart';
import 'package:provider/provider.dart';

import 'src/routes/routes.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DBProvider.db,
          lazy: false,
        ),
      ],
      child: MyApp(),
    );
  }
}

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
