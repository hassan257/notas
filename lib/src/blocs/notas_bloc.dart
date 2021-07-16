import 'dart:async';

import 'package:notas/src/models/nota_model.dart';
import 'package:notas/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class NotasBloc {
  final _notasStreamController = new BehaviorSubject<List<NotaModel>?>();
  Stream<List<NotaModel>?> get notasStream => _notasStreamController.stream;

  final _idStreamController = StreamController<int>.broadcast();
  Stream<int> get idStream => _idStreamController.stream;
  int id = 0;

  void index() async {
    final notas = await DBProvider.db.getNotas();
    _notasStreamController.sink.add(notas);
  }

  void show(int? id) async {
    final notas = await DBProvider.db.getNotaById(id);
    _notasStreamController.sink.add(notas);
  }

  void store(NotaModel nota) async {
    await DBProvider.db.nuevaNota(nota);
    if (nota.parentid == 0) {
      index();
    } else {
      show(nota.parentid);
    }
  }

  void destroy(int? id) async {
    await DBProvider.db.borrarNota(id);
    index();
  }

  void updateId(int newValue) {
    id = newValue;
    _idStreamController.sink.add(newValue);
  }

  void updateActive(NotaModel nota) async {
    await DBProvider.db.updateActive(nota);
    index();
  }

  void update(NotaModel nota) async {
    await DBProvider.db.update(nota);
    index();
  }

  dispose() {
    _notasStreamController.close();
    _idStreamController.close();
  }
}
