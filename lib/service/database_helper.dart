import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:usb_app/service/toast_service.dart';
import 'dart:io';
import '../models/user_model.dart';
import '../models/ornament_model.dart';

class DatabaseHelper extends GetxController {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  // Database initialization
  Future<DatabaseHelper> init() async {
    // Desktop ke liye FFI initialize karo
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit(); // Important: Desktop ke liye yeh call karo
      databaseFactory = databaseFactoryFfi; // FFI factory set karo
    }

    await getDatabase();
    return this;
  }

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Database path lo - Desktop par alag folder mein save hoga
    String path;

/*    if (Platform.isWindows) {
      // Windows par: C:\Users\USERNAME\AppData\Roaming\jewelry_app\database
      final appDocDir = await getApplicationSupportDirectory();
      path = join(appDocDir.path, 'jewelry_app.db');
    } else {
      // Mobile ya other platforms
      path = join(await getDatabasesPath(), 'jewelry_app.db');
    }*/

    if (Platform.isWindows) {
      final exeDir = File(Platform.resolvedExecutable).parent;
      path = join(exeDir.path, 'jewelry_app.db');
    } else {
      path = join(await getDatabasesPath(), 'jewelry_app.db');
    }

    print('Database path: $path'); // Debug ke liye

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Creating database tables...');

        // Users table
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            phone TEXT,
            created_at TEXT NOT NULL
          )
        ''');

        // Ornaments table
        await db.execute('''
          CREATE TABLE ornaments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            person_name TEXT NOT NULL,
            ornament_type TEXT NOT NULL,
            weight REAL NOT NULL,
            rate REAL NOT NULL,
            interest REAL NOT NULL,
            total_price REAL NOT NULL,
            date TEXT NOT NULL,
            notes TEXT,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');

        print('Database tables created successfully');
      },
      onOpen: (db) {
        print('Database opened successfully');
      },
    );

    return _database!;
  }

  // ==================== USER OPERATIONS ====================

  // Sign Up - Naya user register karo
  Future<int> registerUser(UserModel user) async {
    final db = await getDatabase();
    try {
      return await db.insert('users', user.toMap());
    } catch (e) {
      print('Register error: $e');
      return -1;
    }
  }

  // Login - User check karo
  Future<UserModel?> loginUser(String email, String password) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // Check if email exists
  Future<bool> isEmailExists(String email) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return maps.isNotEmpty;
  }

  // Get user by ID
  Future<UserModel?> getUserById(int id) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // ==================== ORNAMENT OPERATIONS ====================

  // Naya ornament add karo
  Future<int> addOrnament(OrnamentModel ornament) async {
    final db = await getDatabase();
    return await db.insert('ornaments', ornament.toMap());
  }

  // Saare ornaments lao (specific user ke)
  Future<List<OrnamentModel>> getUserOrnaments(int userId) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> maps = await db.query(
      'ornaments',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return OrnamentModel.fromMap(maps[i]);
    });
  }

  // Ornament update karo
  Future<int> updateOrnament(OrnamentModel ornament) async {
    final db = await getDatabase();
    return await db.update(
      'ornaments',
      ornament.toMap(),
      where: 'id = ?',
      whereArgs: [ornament.id],
    );
  }

  // Ornament delete karo
  Future<int> deleteOrnament(int id) async {
    final db = await getDatabase();
    return await db.delete(
      'ornaments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Total calculation (user ke total ornaments ka)
  Future<Map<String, double>> getTotalStats(int userId) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> maps = await db.query(
      'ornaments',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    double totalWeight = 0;
    double totalPrice = 0;

    for (var map in maps) {
      totalWeight += map['weight'] as double;
      totalPrice += map['total_price'] as double;
    }

    return {
      'totalWeight': totalWeight,
      'totalPrice': totalPrice,
      'totalItems': maps.length.toDouble(),
    };
  }

  // Kisi specific person ke saare ornaments
  Future<List<OrnamentModel>> getPersonOrnaments(int userId, String personName) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> maps = await db.query(
      'ornaments',
      where: 'user_id = ? AND person_name = ?',
      whereArgs: [userId, personName],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return OrnamentModel.fromMap(maps[i]);
    });
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}