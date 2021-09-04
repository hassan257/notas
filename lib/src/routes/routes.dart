import 'package:flutter/material.dart';
import 'package:notas/src/pages/modificar_nota_page.dart';
import 'package:notas/src/pages/pages.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'home': (BuildContext context) => HomePage(),
    'addNote': (BuildContext context) => NuevaNotaPage(),
    'modNote': (BuildContext context) => ModificarNotaPage(),
    'note': (BuildContext context) => NotaPage(),
    'moveNota': (BuildContext context) => MoverNotaPage(),
  };
}
