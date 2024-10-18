import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:tpmobile/models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        pseudoName TEXT,
        phoneNumber TEXT
      )
    ''');
  }

  Future<void> createInitialUserIfNotExists() async {
    try {
      final db = await database;
      final existingUser = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: ['wajdi@gmail.com'],
      );

      if (existingUser.isEmpty) {
        await createUser('wajdi@gmail.com', 'wajdi123', 'wajda9');
      }
    } catch (e) {
      print("Error creating initial user: $e");
    }
  }

  Future<bool> createUser(String email, String password, String name) async {
    try {
      final db = await database;
      if (db == null) return false;

      final hashedPassword = _hashPassword(password);
      await db.insert('users', {
        'email': email,
        'password': hashedPassword,
        'name': name,
      });
      return true;
    } catch (e) {
      print("Error creating user: $e");
      return false;
    }
  }

  Future<bool> authenticateUser(String email, String password) async {
    try {
      final db = await database;
      if (db == null) return false;

      final hashedPassword = _hashPassword(password);
      final results = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, hashedPassword],
      );
      return results.isNotEmpty;
    } catch (e) {
      print("Error during authentication: $e");
      return false;
    }
  }

  Future<void> setLoggedInUser(String email, bool rememberMe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_in_user', email);
      await prefs.setBool('remember_me', rememberMe);
    } catch (e) {
      print("Error setting logged in user: $e");
    }
  }

  Future<String?> getLoggedInUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('logged_in_user');
    } catch (e) {
      print("Error getting logged in user: $e");
      return null;
    }
  }

  Future<bool> isRememberMeChecked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('remember_me') ?? false;
    } catch (e) {
      print("Error checking remember me: $e");
      return false;
    }
  }

  Future<void> logoutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('logged_in_user');
      await prefs.remove('remember_me');
    } catch (e) {
      print("Error logging out user: $e");
    }
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Contact CRUD operations
  Future<int> insertContact(Contact contact) async {
    try {
      final db = await database;
      if (db == null) return -1;
      return await db.insert('contacts', contact.toMap());
    } catch (e) {
      print("Error inserting contact: $e");
      return -1;
    }
  }

  Future<List<Contact>> getContacts() async {
    try {
      final db = await database;
      if (db == null) return [];
      final List<Map<String, dynamic>> maps = await db.query('contacts');
      return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
    } catch (e) {
      print("Error getting contacts: $e");
      return [];
    }
  }

  Future<int> updateContact(Contact contact) async {
    try {
      final db = await database;
      if (db == null) return 0;
      return await db.update(
        'contacts',
        contact.toMap(),
        where: 'id = ?',
        whereArgs: [contact.id],
      );
    } catch (e) {
      print("Error updating contact: $e");
      return 0;
    }
  }

  Future<int> deleteContact(int id) async {
    try {
      final db = await database;
      if (db == null) return 0;
      return await db.delete(
        'contacts',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting contact: $e");
      return 0;
    }
  }

  // User operations
  // Future<User?> getUserByEmail(String email) async {
  //   try {
  //     final db = await database;
  //     if (db == null) return null;
  //     final results = await db.query(
  //       'users',
  //       where: 'email = ?',
  //       whereArgs: [email],
  //     );
  //     if (results.isNotEmpty) {
  //       return User.fromMap(results.first);
  //     }
  //     return null;
  //   } catch (e) {
  //     print("Error getting user by email: $e");
  //     return null;
  //   }
  // }

  // Future<int> updateUser(User user) async {
  //   try {
  //     final db = await database;
  //     if (db == null) return 0;
  //     return await db.update(
  //       'users',
  //       user.toMap(),
  //       where: 'id = ?',
  //       whereArgs: [user.id],
  //     );
  //   } catch (e) {
  //     print("Error updating user: $e");
  //     return 0;
  //   }
  // }

  Future<void> initializeDatabase() async {
    try {
      final db = await database;
      await createInitialUserIfNotExists();
      print("Database initialized successfully");
    } catch (e) {
      print("Error during database initialization: $e");
    }
  }
}
