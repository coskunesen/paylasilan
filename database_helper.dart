import 'dart:io';

import 'package:flutter/services.dart';
import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/models/notlar.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // statik tanımladık sınıfa özgü değişkenler
  static DatabaseHelper? _databaseHelper;
  static Database?
      _database; // veri tabanı üzerinden tablolara ekleme silme güncelleme yapmamızı sağlıyor
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database?> _initializeDatabase() async {
    // Database _db;

    var databasesPath =
        await getDatabasesPath(); //(1) öncelikle var olan veritabanının yolu alınıyor.
    var path = join(databasesPath,
        "demo_asset_example.db"); //2-  uygulamak istediğimiz veri tabanının yolu alınıyor

// Check if the database exists  // burda ise db oluştu mu? kontrolü yapılıyor
    var exists = await databaseExists(path);

    if (!exists) {
      // eğer yoksa
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(
            recursive: true); // asset te belirtilen db den kopya oluşacak
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(url.join(
          "assets", "notlar.db")); //(2) uygulamak istenen db adı yazılır
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

// open the database
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await _getDatabase();

    var sonuc = await db.query('kategori');
    return sonuc;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('kategori', kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase();
    //tablonun adı, güncellenmiş değerleri içeren map, sonra ise koşul yazılır
    var sonuc = await db.update('kategori', kategori.toMap(),
        where: 'kategoriID= ?', whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<int> kategoriSil(int kategoriID) async {
    var db = await _getDatabase();
    //tablonun adı, güncellenmiş değerleri içeren map, sonra ise koşul yazılır
    var sonuc = await db
        .delete('kategori', where: 'kategoriID= ?', whereArgs: [kategoriID]);
    return sonuc;
  }

////////////////////

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();  

    var sonuc = await db.query('not',
        orderBy: 'notID DESC'); // DESC: En son eklenen not en başta görünecek
    return sonuc;
  }

  Future<List<Not>> notListesiniGetir() async {
    var notlarMapListesi = await notlariGetir();
    var notListesi = List<Not>(); // HATA ALINAN KISIM List<Not> altı çizili
    for (Map map in notlarMapListesi) {
      notListesi.add(Not.fromMap(map)); // HATA ALINAN KISIM map altı çizili
    }
    return notListesi;
  }

  Future<int> notGuncelle(Not not) async {
    var db = await _getDatabase();
    //tablonun adı, güncellenmiş değerleri içeren map, sonra ise koşul yazılır
    var sonuc = await db
        .update('not', not.toMap(), where: 'notID= ?', whereArgs: [not.notID]);
    return sonuc;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase();
    //tablonun adı, güncellenmiş değerleri içeren map, sonra ise koşul yazılır
    var sonuc = await db.delete('not', where: 'notID= ?', whereArgs: [notID]);
    return sonuc;
  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('not', not.toMap());
    return sonuc;
  }
}
