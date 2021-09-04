import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notas/src/blocs/notas_bloc.dart';
import 'package:notas/src/models/models.dart';
import 'package:notas/src/pages/mover_nota.dart';
import 'package:notas/src/pages/nota_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotasBloc _notas = NotasBloc();

  @override
  Widget build(BuildContext context) {
    _notas.idBloc = 0;
    _notas.show(0);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _notas.notasStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<NotaModel>?> snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: refrescar,
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      bool check = false;
                      if (snapshot.data![i].active == 1) check = true;
                      // print('notas: ${_notas.idBloc}');
                      // print('data: ${snapshot.data![i].id!}');
                      // if (_notas.idBloc == snapshot.data![i].id!) {
                      //   return Column(
                      //     children: [
                      //       Card(
                      //           margin: EdgeInsets.only(bottom: 20.0),
                      //           child: Column(
                      //             children: [
                      //               ListTile(
                      //                 onTap: () {
                      //                   _notas.idBloc =
                      //                       snapshot.data![i].parentid!;
                      //                   _notas.show(snapshot.data![i].parentid);
                      //                 },
                      //                 title: Text('Atrás'),
                      //                 leading: Icon(Icons.arrow_back),
                      //               ),
                      //               Container(
                      //                 padding: EdgeInsets.only(bottom: 20.0),
                      //                 child: Text(
                      //                   'NOTAS DE ${snapshot.data![i].title}'
                      //                       .toUpperCase(),
                      //                   style: TextStyle(
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 20.0,
                      //                   ),
                      //                   softWrap: true,
                      //                 ),
                      //               )
                      //             ],
                      //           )),
                      //     ],
                      //   );
                      // }
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                snapshot.data![i].title ?? '',
                                softWrap: true,
                              ),
                              subtitle: Text(
                                snapshot.data![i].body ?? '',
                                softWrap: true,
                              ),
                              onTap: () {
                                _notas.idBloc = snapshot.data![i].id!;
                                // _notas.show(snapshot.data![i].id);
                                Navigator.pushNamed(context, 'note',
                                    arguments: ArgumentosNotas(
                                        _notas,
                                        snapshot.data![i].id,
                                        snapshot.data![i].parentid));
                              },
                              trailing: Icon(Icons.arrow_forward),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, 'modNote',
                                                arguments: ArgumentosHome(
                                                    snapshot.data![i], _notas));
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _showMyDialog(
                                                snapshot.data![i].id, _notas);
                                          },
                                          icon: Icon(Icons.delete),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, 'moveNota',
                                                arguments: MoverNotaArguments(
                                                    snapshot.data![i].id,
                                                    _notas));
                                          },
                                          icon: Icon(Icons.drag_handle),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Switch(
                                      onChanged: (bool value) {
                                        setState(() {
                                          // check = value;
                                          snapshot.data![i].active =
                                              value == true ? 1 : 0;
                                          _notas
                                              .updateActive(snapshot.data![i]);
                                        });
                                      },
                                      value: check,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              );
            } else {
              return Center(
                child: Text('Agregue una nota para comenzar'),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'addNote', arguments: _notas);
        },
        child: Icon(Icons.add_comment),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> refrescar() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      _notas.index();
    });
  }

  Future<void> _showMyDialog(int? id, NotasBloc bloc) {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ADVERTENCIA'.toUpperCase()),
          content: Container(
              height: 100.0,
              child: Center(
                child: Text(
                    '¿Confirma que desea eliminar la nota? Al eliminarla también eliminará las notas que dependan de la misma.'),
              )),
          actions: <Widget>[
            TextButton(
              child: Text('CONFIRMAR'),
              onPressed: () {
                bloc.destroy(id);
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text('CANCELAR'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}

class ArgumentosHome {
  final NotaModel notaModel;
  final NotasBloc notasBloc;
  ArgumentosHome(this.notaModel, this.notasBloc);
}
