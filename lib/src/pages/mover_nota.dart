import 'package:flutter/material.dart';
import 'package:notas/src/blocs/blocs.dart';
import 'package:notas/src/models/models.dart';
import 'package:notas/src/providers/db_provider.dart';

class MoverNotaPage extends StatefulWidget {
  @override
  _MoverNotaPageState createState() => _MoverNotaPageState();
}

class _MoverNotaPageState extends State<MoverNotaPage> {
  NotasBloc _notas = NotasBloc();

  NotaModel parent = NotaModel(id: -1, parentid: -1);

  @override
  Widget build(BuildContext context) {
    // final int objetivoId = ModalRoute.of(context)!.settings.arguments as int;
    final MoverNotaArguments argumentos =
        ModalRoute.of(context)!.settings.arguments as MoverNotaArguments;
    final int? objetivoId = argumentos.idObjetivo;
    _notas = argumentos.notasBloc;

    _notas.showBloque(0);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mover Nota'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        builder:
            (BuildContext context, AsyncSnapshot<List<NotaModel>?> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, int index) {
                // print(parent.toJson());
                // print('INDEX: $index');
                // print('PARENT ID: ${parent.id}');
                if (index == 0 && parent.id! > 0) {
                  return Column(
                    children: [
                      Container(
                        child: TextButton(
                          onPressed: _atras,
                          child: Row(children: [
                            Icon(Icons.arrow_back),
                            Text('Atrás')
                          ]),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.black26,
                        elevation: 2.0,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                snapshot.data![index].title ?? '',
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                snapshot.data![index].body ?? '',
                                textAlign: TextAlign.center,
                              ),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                parent = snapshot.data![index];
                                _notas.showBloque(parent.id);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      if (objetivoId !=
                                          snapshot.data![index].id) {
                                        _notas.updateParent(objetivoId,
                                            snapshot.data![index].id);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Seleccionar')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
                if (index == 0 && parent.id == -1) {
                  return Card(
                    shadowColor: Colors.black26,
                    elevation: 2.0,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Raíz',
                            textAlign: TextAlign.center,
                          ),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            parent = snapshot.data![index];
                            _notas.showBloque(0);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // TextButton(
                            //     onPressed: () {}, child: Text('Ver Notas')),
                            TextButton(
                                onPressed: () {
                                  _notas.updateParent(objetivoId, 0);
                                  Navigator.pop(context);
                                },
                                child: Text('Seleccionar')),
                          ],
                        )
                      ],
                    ),
                  );
                }
                if (parent.id! >= 0) {
                  return Card(
                    shadowColor: Colors.black26,
                    elevation: 2.0,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            snapshot.data![index].title ?? '',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            snapshot.data![index].body ?? '',
                            textAlign: TextAlign.center,
                          ),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            parent = snapshot.data![index];
                            _notas.showBloque(parent.id);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // TextButton(
                            //     onPressed: () {}, child: Text('Ver Notas')),
                            TextButton(
                                onPressed: () {
                                  if (objetivoId != snapshot.data![index].id) {
                                    _notas.updateParent(
                                        objetivoId, snapshot.data![index].id);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Seleccionar')),
                          ],
                        )
                      ],
                    ),
                  );
                }
                return Center(
                  child: Container(),
                );
              },
              itemCount: snapshot.data!.length,
            );
          }
          if (parent.parentid != 0) {
            return Container(
              child: TextButton(
                onPressed: _atras,
                child: Row(children: [Icon(Icons.arrow_back), Text('Atrás')]),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
        stream: _notas.notas2Stream,
      ),
    );
  }

  void _atras() async {
    final int? destino = parent.parentid;
    final NotaModel datosPadre = await DBProvider.db.getNotasById(destino);
    parent = datosPadre;
    print('va hacia $destino');
    _notas.showBloque(destino);
  }
}

class MoverNotaArguments {
  @required
  int? idObjetivo;
  @required
  NotasBloc notasBloc;
  MoverNotaArguments(this.idObjetivo, this.notasBloc);
}
