import 'package:news/src/models/item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class NewsDbProvider {
  Database? db;

  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
        CREATE TABLE Items
          (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            deleted INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
          """);
      },
    );
  }

  fetchItem(int id) async {
    final maps = await db!.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  addItem(ItemModel item) {
    return db!.insert(
      "Items",
      item.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
