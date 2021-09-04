import 'dart:async';

import 'package:notas/src/models/nota_model.dart';
import 'package:notas/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class NotasBloc {
  final _notasStreamController = new BehaviorSubject<List<NotaModel>?>();
  Stream<List<NotaModel>?> get notasStream => _notasStreamController.stream;

  final _notas2StreamController = new BehaviorSubject<List<NotaModel>?>();
  Stream<List<NotaModel>?> get notas2Stream => _notas2StreamController.stream;

  final _idStreamController = StreamController<int>.broadcast();
  Stream<int> get idStream => _idStreamController.stream;
  int idBloc = 0;

  void index() async {
    final notas = await DBProvider.db.getNotas();
    _notasStreamController.sink.add(notas);
  }

  void show(int? id) async {
    final notas = await DBProvider.db.getNotaById(id);
    idBloc = id as int;
    _notasStreamController.sink.add(notas);
  }

  void showBloque(int? id) async {
    final notas = await DBProvider.db.getNotasByParentId(id);
    // print(notas);
    // idBloc = id as int;
    _notas2StreamController.sink.add(notas);
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
    idBloc = newValue;
    _idStreamController.sink.add(newValue);
  }

  void updateActive(NotaModel nota) async {
    await DBProvider.db.updateActive(nota);
    idBloc = nota.id as int;
    if (nota.parentid == 0) {
      index();
    } else {
      show(nota.parentid);
    }
  }

  void update(NotaModel nota) async {
    await DBProvider.db.update(nota);
    print(nota.parentid);
    if (nota.parentid == 0) {
      index();
    } else {
      show(nota.parentid);
    }
  }

  void updateParent(int? id, int? newParent) async {
    await DBProvider.db.updateParent(id, newParent);
    if (newParent == 0) {
      index();
      showBloque(newParent);
    } else {
      show(newParent);
      showBloque(newParent);
    }
  }

  dispose() {
    _notasStreamController.close();
    _notas2StreamController.close();
    _idStreamController.close();
  }
}
