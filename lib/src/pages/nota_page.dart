import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notas/src/blocs/blocs.dart';
import 'package:notas/src/models/models.dart';

import 'home_page.dart';
import 'mover_nota.dart';

class NotaPage extends StatefulWidget {
  @override
  _NotaPageState createState() => _NotaPageState();
}

class _NotaPageState extends State<NotaPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgumentosNotas;
    final _notas = args.notasBloc;
    final id = args.id;
    final parentId = args.padreId;
    _notas.show(id);
    return WillPopScope(
      onWillPop: () async {
        if (parentId != null) {
          _notas.show(parentId);
        } else {
          _notas.show(0);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notas'),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'addNote', arguments: _notas);
          },
          child: Icon(Icons.add_comment),
        ),
        body: StreamBuilder(
            stream: _notas.notasStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<NotaModel>?> snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: refrescar,
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        bool check = false;
                        if (snapshot.data![i].active == 1) check = true;
                        if (_notas.idBloc == snapshot.data![i].id!) {
                          return Card(
                              margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                              child: Container(
                                padding:
                                    EdgeInsets.only(bottom: 20.0, top: 20.0),
                                child: Text(
                                  'NOTAS DE ${snapshot.data![i].title}'
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ));
                        }
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                      snapshot.data![i],
                                                      _notas));
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
                                            _notas.updateActive(
                                                snapshot.data![i]);
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
      ),
    );
  }

  Future<void> refrescar() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      final args =
          ModalRoute.of(context)!.settings.arguments as ArgumentosNotas;
      final _notas = args.notasBloc;
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

class ArgumentosNotas {
  @required
  NotasBloc notasBloc;
  @required
  int? id;
  @required
  int? padreId;
  ArgumentosNotas(this.notasBloc, this.id, this.padreId);
}
