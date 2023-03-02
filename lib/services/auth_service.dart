import 'package:sqflite/sqflite.dart';
import 'package:gymapp/models/user.dart';

// The AuthService class is used to handle authentication.
class AuthService {
  // The setup method is used to setup the database.
  static Future<void> setup() async {
    // Open or create the database
    await openDatabase('user.db', version: 1,
        onCreate: (Database db, int version) async {
      // Create the user table
      await db.execute('''
    CREATE TABLE user (
    id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    password TEXT
    )
    ''');
    });
  }

// The signup method is used to create a new user.
  static Future<User> signup(String name, String email, String password) async {
    // Add code to hash the password and store the user information in the SQLite database
    Database db = await openDatabase('user.db');
    await db.execute('''
    create table if not exists user (
    id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    password TEXT
    )
    ''');
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO user(name, email, password) VALUES("$name", "$email", "$password")');
      print(id1);
    });
    // return the created user
    return User(name: name, email: email);
  }

// The login method is used to login a user.
  static Future<User> login(String email, String password) async {
    // Add code to check if the email and password match the information in the SQLite database
    var db = await openDatabase('user.db');
    var user = await db.query('user', where: "email = ?", whereArgs: [email]);
    if (user.length > 0) {
      if (user[0]['password'] == password) {
        return User(name: user[0]['name'], email: user[0]['email']);
      }
    }
    return null;
  }

// The forgotPassword method is used to reset the user's password.
  static Future<void> forgotPassword(String email) async {
    // Add code to send an email with reset password link
    print("Reset link sent to $email");
    var db = await openDatabase('user.db');
    // Reset the user's password to 123456
    await db.rawUpdate(
        'UPDATE user SET password = ? WHERE email = ?', ['123456', email]);
  }

// The reset method is used to reset the database.
  static Future<void> reset() async {
    // Add code to reset the database
    var db = await openDatabase('user.db');
    await db.delete('user');
    await db.close();
  }
}
