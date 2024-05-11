/****************************************************************************
 **                              DÜZCE ÜNİVERSİTESİ
 **                          LİSANSÜSTÜ EĞİTİM ENSTİTÜSÜ
 **                       BİLGİSAYAR MÜHENDİLİĞİ ANABİLİM DALI
 **                       ÖĞRENCİ ADI :          ARDA ÖZYAMAN
 **                       ÖĞRENCİ NUMARASI :     2345007016
 **
 ****************************************************************************/

import 'dart:async';
import 'package:carmaintainapp/models/operation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/appointment.dart';
import '../models/car.dart';
import '../models/users/user.dart';
class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  late Database _database;

  Future<Database> get database async {
    _database = await initDatabase();
    return _database;
  }

  DbHelper.internal();

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'appdb.db');

    var database = await openDatabase(path,
        version: 1,
        onCreate: _createDb,
        onUpgrade: _onUpgrade,
        onDowngrade: _onUpgrade);
    return database;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Eski tabloları sil
    await db.execute('DROP TABLE IF EXISTS userdata');
    await db.execute('DROP TABLE IF EXISTS cars');
    await db.execute('DROP TABLE IF EXISTS appointments');
    await db.execute('DROP TABLE IF EXISTS operations');

    // Yeni tabloları oluştur
    await _createDb(db, newVersion);
  }

  Future<void> _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE userdata (
        id INTEGER PRIMARY KEY,
        name TEXT,
        surname TEXT,
        pass TEXT,
        mail TEXT,
        phone TEXT,
        personImage TEXT,
        type INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE cars (
        id INTEGER PRIMARY KEY,
        customerId INTEGER,
        licenseId TEXT,
        brand TEXT,
        modelName TEXT,
        FOREIGN KEY(customerId) REFERENCES userdata(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY,
        customerId INTEGER,
        carId INTEGER,
        employeeId INTEGER,
        appointmentDate TEXT,
        state TEXT,
        description TEXT,
        FOREIGN KEY(customerId) REFERENCES userdata(id),
        FOREIGN KEY(carId) REFERENCES cars(id),
        FOREIGN KEY(employeeId) REFERENCES userdata(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE operations (
        id INTEGER PRIMARY KEY,
        appointmentId INTEGER,
        operationType TEXT,
        cost TEXT,
        FOREIGN KEY(appointmentId) REFERENCES appointments(id)
      )
    ''');
  }

  Future<int> insertUserData(User user) async {
    Database db = await database;
    return await db.insert('userdata', user.toMap());
  }

  Future<int> insertCar(Car car) async {
    Database db = await database;
    return await db.insert('cars', car.toMap());
  }

  Future<int> insertAppointment(Appointment appointment) async {
    Database db = await database;
    return await db.insert('appointments', appointment.toMap());
  }

  Future<int> insertOperation(Operation operation) async {
    Database db = await database;
    return await db.insert('operations', operation.toMap());
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete('userdata', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCar(int id) async {
    Database db = await database;
    return await db.delete('cars', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAppointment(int id) async {
    Database db = await database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteOperations(int id) async {
    Database db = await database;
    return await db.delete('operations', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateUserData(User user) async {
    Database db = await database;
    return await db.update(
      'userdata',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateCar(Car car) async {
    Database db = await database;
    return await db.update(
      'cars',
      car.toMap(),
      where: 'id = ?',
      whereArgs: [car.id],
    );
  }

  Future<int> updateAppointment(Appointment appointment) async {
    Database db = await database;
    return await db.update(
      'appointments',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<int> updateOperation(Operation operation) async {
    Database db = await database;
    return await db.update(
      'operations',
      operation.toMap(),
      where: 'id = ?',
      whereArgs: [operation.id],
    );
  }

  Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    Database db = await database;
    return db.query(tableName);
  }

  Future<List<User>> getAllUsers() async {
    List<Map<String, dynamic>> results = await getAll('userdata');
    return results.map((map) => User.fromMap(map)).toList();
  }

  Future<List<Car>> getAllCars() async {
    List<Map<String, dynamic>> results = await getAll('cars');
    return results.map((map) => Car.fromMap(map)).toList();
  }

  Future<List<Appointment>> getAllAppointments() async {
    List<Map<String, dynamic>> results = await getAll('appointments');
    return results.map((map) => Appointment.fromMap(map)).toList();
  }

  Future<List<Operation>> getAllOperations() async {
    List<Map<String, dynamic>> results = await getAll('operations');
    return results.map((map) => Operation.fromMap(map)).toList();
  }

  Future<List<Map<String, dynamic>>> getByCustomerId(
      String tableName, int customerId) async {
    Database db = await database;
    return db
        .query(tableName, where: 'customerId = ?', whereArgs: [customerId]);
  }

  Future<List<Car>> getCarsByCustomerId(int customerId) async {
    List<Map<String, dynamic>> results =
        await getByCustomerId('cars', customerId);
    return results.map((map) => Car.fromMap(map)).toList();
  }

  Future<List<Appointment>> getAppointmentsByCustomerId(int customerId) async {
    List<Map<String, dynamic>> results =
        await getByCustomerId('appointments', customerId);
    return results.map((map) => Appointment.fromMap(map)).toList();
  }

  Future<List<Map<String, dynamic>>> getByAppointmentId(
      String tableName, int appointmentId) async {
    Database db = await database;
    return db.query(tableName,
        where: 'appointmentId = ?', whereArgs: [appointmentId]);
  }

  Future<List<Operation>> getOperationsByAppointmentId(
      int appointmentId) async {
    List<Map<String, dynamic>> results =
        await getByAppointmentId('operations', appointmentId);
    return results.map((map) => Operation.fromMap(map)).toList();
  }

  Future<List<Appointment>> getAppointmentsByEmployeeId(int employeeId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'appointments',
      where: 'employeeId = ?',
      whereArgs: [employeeId],
    );
    return results.map((map) => Appointment.fromMap(map)).toList();
  }

  Future<User?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'userdata',
      where: 'mail = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }


}
