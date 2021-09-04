import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notas/src/models/nota_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider extends ChangeNotifier {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database?> initDB() async {
    // Path de donde se almacena la BD
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'notasDB.db');
    print(path);
    // Crear BD
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE notas(
            id INTEGER PRIMARY KEY,
            parentid INTEGER,
            title TEXT,
            body TEXT,
            active INTEGER
          )
        ''');
    });
  }

  Future<int> nuevaNota(NotaModel nuevaNota) async {
    final db = await database;
    final res = await db!.insert('notas', nuevaNota.toJson());
    return res;
  }

  Future<List<NotaModel>?> getNotaById(int? id) async {
    final db = await database;
    final res = await db!.query('notas',
        where: 'id = ? OR parentid = ?',
        whereArgs: [id, id],
        orderBy: 'active DESC');
    return res.isNotEmpty
        ? res.map((s) => NotaModel.fromJson(s)).toList()
        : null;
  }

  Future<List<NotaModel>?> getNotasByParentId(int? id) async {
    final db = await database;
    final res = await db!.query('notas',
        where: 'parentid = ?', whereArgs: [id], orderBy: 'active DESC');
    // print(res);
    return res.isNotEmpty
        ? res.map((s) => NotaModel.fromJson(s)).toList()
        : null;
  }

  Future<NotaModel> getNotasById(int? id) async {
    final db = await database;
    final res = await db!.query('notas', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      final elementos = res.map((e) => NotaModel.fromJson(e)).toList();
      return elementos[0];
    }
    return new NotaModel(id: 0, parentid: 0);
  }

  Future<List<NotaModel>?> getNotas() async {
    final db = await database;
    final res = await db!.query('notas', where: 'parentid = ?', whereArgs: [0]);
    return res.isNotEmpty
        ? res.map((s) => NotaModel.fromJson(s)).toList()
        : null;
  }

  Future<int> borrarNota(int? id) async {
    // print('BORRANDO $id');
    final db = await database;
    final res = await db!.delete('notas', where: 'id = ?', whereArgs: [id]);
    await db.delete('notas', where: 'parentid = ?', whereArgs: [id]);
    return res;
  }

  Future<int> updateActive(NotaModel nota) async {
    final db = await database;
    final res = await db!
        .update('notas', nota.toJson(), where: 'id = ?', whereArgs: [nota.id]);
    return res;
  }

  Future<int> update(NotaModel nota) async {
    final db = await database;
    final res = await db!
        .update('notas', nota.toJson(), where: 'id = ?', whereArgs: [nota.id]);
    return res;
  }

  Future<int> updateParent(int? id, int? newParent) async {
    final NotaModel nota = await getNotasById(id);
    nota.parentid = newParent;
    final db = await database;
    final res = await db!
        .update('notas', nota.toJson(), where: 'id = ?', whereArgs: [nota.id]);
    return res;
  }
}
