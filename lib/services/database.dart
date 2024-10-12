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
   print("hello");
    if (_database != null){
      
return _database!;
    } 
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        pseudoName TEXT,
        phoneNumber TEXT
      )
    ''');
    
    await createUser("wajdi@gmail.com", "wajdi123", "wajda9");
    
  }
  Future<void> createInitialUserIfNotExists() async {
    final db = await database;
    final existingUser = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: ['wajdi@g.com'],
    );

    if (existingUser.isEmpty) {
      await createUser('wajdi@g.com', '12345678', 'Initial User');
    }
  }

  Future<bool> createUser(String email, String password, String name) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);
    try {
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
    final db = await database;
    final hashedPassword = _hashPassword(password);
    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );
    return results.isNotEmpty;
  }

  Future<void> setLoggedInUser(String email, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_user', email);
    await prefs.setBool('remember_me', rememberMe);
  }

  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('logged_in_user');
  }

  Future<bool> isRememberMeChecked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember_me') ?? false;
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user');
    await prefs.remove('remember_me');
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
