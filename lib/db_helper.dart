import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  String carDatabaseName = "carDatabase.db";
  String carTableName = "car";
  String expenseTableName = "expense";
  String notificationTableName = "notificationl";
  final int _version = 1;
  late Database database;

  Future<void> open() async {
    database = await openDatabase(
      join(await getDatabasesPath(), carDatabaseName),
      version: _version,
      onCreate: (db, version) {
        db.execute("""
          CREATE TABLE $carTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            make TEXT, 
            model TEXT, 
            volume TEXT, 
            gasolineType TEXT, 
            power TEXT, 
            drive TEXT, 
            transmission TEXT, 
            engineType TEXT, 
            carBody TEXT
          );
          """);
        db.execute("""
          CREATE TABLE $expenseTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            carId INTEGER, 
            expenseName TEXT, 
            expensePrice TEXT,
            FOREIGN KEY(carId) REFERENCES $carTableName(id)
          );
          """);
        db.execute("""
          CREATE TABLE $notificationTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            carId INTEGER,
            nameNoti TEXT,
            dateTime TEXT,
            FOREIGN KEY(carId) REFERENCES $carTableName(id)
          );
          """);
      },
    );

    print("Database opened");
  }

  Future<void> addCarData(
    String make,
    String model,
    String volume,
    String gasolineType,
    String power,
    String drive,
    String transmission,
    String engineType,
    String carBody,
  ) async {
    await open(); // Ensure database is opened before any operation

    await database.insert(
      carTableName,
      {
        'make': make,
        'model': model,
        'volume': volume,
        'gasolineType': gasolineType,
        'power': power,
        'drive': drive,
        'transmission': transmission,
        'engineType': engineType,
        'carBody': carBody,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCarData() async {
    await open(); // Ensure database is opened before any operation

    return await database.query(carTableName);
  }

  Future<void> addExpensesData(
    int carID,
    String expenseName,
    String expensePrice,
  ) async {
    await open(); // Ensure database is opened before any operation

    await database.insert(
      expenseTableName,
      {
        'carId': carID,
        'expenseName': expenseName,
        'expensePrice': expensePrice,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getExpenseData() async {
    await open(); // Ensure database is opened before any operation

    return await database.query(expenseTableName);
  }

  Future<void> addNotificationData(
    int carID,
    String name,
    String notifiTime,
  ) async {
    await open(); // Ensure database is opened before any operation

    await database.insert(
      notificationTableName,
      {
        'carId': carID,
        'dateTime': notifiTime,
        'nameNoti': name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getNotificationData() async {
    await open(); // Ensure database is opened before any operation

    return await database.query(notificationTableName);
  }

  // Car table update and delete methods
  Future<void> updateCarData(
    int id,
    String make,
    String model,
    String volume,
    String gasolineType,
    String power,
    String drive,
    String transmission,
    String engineType,
    String carBody,
  ) async {
    await open();
    await database.update(
      carTableName,
      {
        'make': make,
        'model': model,
        'volume': volume,
        'gasolineType': gasolineType,
        'power': power,
        'drive': drive,
        'transmission': transmission,
        'engineType': engineType,
        'carBody': carBody,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCarData(int id) async {
    await open();
    await database.delete(
      carTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Expense table update and delete methods
  Future<void> updateExpenseData(
    int id,
    int carID,
    String expenseName,
    String expensePrice,
  ) async {
    await open();
    await database.update(
      expenseTableName,
      {
        'carId': carID,
        'expenseName': expenseName,
        'expensePrice': expensePrice,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteExpenseData(int id) async {
    await open();
    await database.delete(
      expenseTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Notification table update and delete methods
  Future<void> updateNotificationData(
    int id,
    int carID,
    String name,
    String notifiTime,
  ) async {
    await open();
    await database.update(
      notificationTableName,
      {
        'carId': carID,
        'nameNoti': name,
        'dateTime': notifiTime,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNotificationData(int id) async {
    await open();
    await database.delete(
      notificationTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
