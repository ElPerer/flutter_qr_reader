import 'dart:io';

import 'package:flutter_qr_reader/models/scan_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;

  //La siguiente línea es para instanciar la propia clase DBProvider, lo que se ve como ._ es un constructor privado
  static final DBProvider db = DBProvider._();

  //Esto es un constructor privado
  DBProvider._();

  Future<Database> get database async {

    //Si la propiedad _database es distinto de null retorna la misma instancia ya creada, es decir cuando accedemos a la propiedad va a verificar si la BD ya está instanciada
    if(_database != null) return _database!;

    //En caso contrario que sea la primera vez toma el valor del método initDb() y retorna dicho valor
    _database = await initDb();
    return _database!;

  }

  Future<Database> initDb() async{
    //Path de donde almacenaremos la base de datos
    //Esto está aparte de la aplicación, si se borra la aplicación la Base de Datos también se eliminará
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    //Crear base de datos
    //El siguiente método crea o abre la Base de datos
    //Cada vez que se cambia la estructura de la base de datos es necesario incrementar el número de la versión
    //Si la versión es la misma cuando se vuelve a llamar este método entonces no va a ejecutar la rutina de creación de las tablas solo se dispara cuando la versión cambia
    return await openDatabase(
      path, 
      version: 1, 
      onOpen: (db) {}, 
      onCreate: (Database db, int version) async {
        //Para poder hacer una consulta o una QUERY es necesario colocar la siguiente línea
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          );
        ''');
      } 
    );
  }

  //El siguiente método es el encargado de cualquier interacción con la base de datos ya creada anteriormente
  Future<int> nuevoScanRaw(ScanModel scanModel) async{

    final id = scanModel.id;
    final tipo = scanModel.tipo;
    final valor = scanModel.valor;

    //El siguiente database es nuestro GET que está definido anteriormente y nos dice si la BD ya está instanciada o creada, si no la crea
    final db = await database;

    //En los método de rawInsert y demás se manda el SQL literlamente
    final res = await db.rawInsert('''
      INSERT INTO Scans( id, tipo, valor) VALUES ( $id, '$tipo', '$valor')
    ''');

    return res;
  }

  Future<int> nuevoScan(ScanModel scanModel) async {
    final db = await database;

    //En el método que viene del objeto instanciado de DataBase llamado insert dentro de los parentesis tendremos que poner el nombre de la tabla y espera un JSON el cual ya
    //tenemos en nuestro modelo llamado scan_model que es el que recibimos como parámetro llamado scanModel
    final res = await db.insert('Scans', scanModel.toJson());
    
    //El res es el último ID del registro insertado
    return res;
  }

  //En el tipo de retorno se puede poner un ? para indicar que lo que puede retornar es un valor null
  Future<ScanModel?> getScanById(int id) async{
    final db = await database;

    //El método query obtiene todos los registros de la tabla que definamos, en este caso es Scans
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  //Obtener todos los registros de la tabla llamada Scans en este caso
  Future<List<ScanModel>?> getAllScans() async{
    final db = await database;

    //El método query obtiene todos los registros de la tabla que definamos, en este caso es Scans
    final res = await db.query('Scans');
    return res.isNotEmpty ? res.map((scan) => ScanModel.fromJson(scan)).toList(): [];
  }

  Future<List<ScanModel>?> getScansPorTipo(String tipo) async{
    final db = await database;

    //El método query obtiene todos los registros de la tabla que definamos, en este caso es Scans
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');
    return res.isNotEmpty ? res.map((scan) => ScanModel.fromJson(scan)).toList(): null;
  }

  Future<int> updateScan(ScanModel scanModel) async{
    final db = await database;

    //En la parte del whereArgs tenemos que colocar entre los [] en el mismo orden que colocamos los argumentos en el where anterior de esa misma línea
    final res = await db.update('Scans', where: 'id = ?', whereArgs:[scanModel.id], scanModel.toJson());

    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;

    //Esto hace es borrar el registro que contenga el mismo ID
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;

    //El delete cuando simplemente le pasamos el nombre de la tabla de la BD simplemente borra todos los registros
    // final res = await db.delete('Scans');

    //Otra forma de realizarlo es
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}