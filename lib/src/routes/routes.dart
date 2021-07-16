import 'package:flutter/material.dart';
import 'package:notas/src/pages/home_page.dart';
import 'package:notas/src/pages/modificar_nota_page.dart';
import 'package:notas/src/pages/nueva_nota_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes(){

  return <String, WidgetBuilder>{
    'home': (BuildContext context) => HomePage(),
    'addNote': (BuildContext context) => NuevaNotaPage(),
    'modNote': (BuildContext context) => ModificarNotaPage()
  };

}