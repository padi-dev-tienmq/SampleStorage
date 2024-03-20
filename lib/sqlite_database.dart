import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/dog.dart';

class SqliteDatabase {
  static SqliteDatabase? _instance;
  static SqliteDatabase get instance => _instance ??= SqliteDatabase._();

  static Database? db;

  SqliteDatabase._();

  Future<void> openConnect() async {
    db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'doggie_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

// Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db?.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // await db.rawInsert(
    //     'INSERT INTO dogs(id, name, age) VALUES(${dog.id}, "${dog.name}", ${dog.age})');
  }

// A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>?> listDog() async {
    // Query the table for all the dogs.
    final List<Map<String, Object?>>? dogMaps = await db?.query('dogs');
    // final List<Map<String, Object?>> dogMaps = await db.rawQuery("SELECT * FROM dogs");

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return dogMaps?.map((e) => Dog(
              id: e["id"] as int,
              name: e["name"] as String,
              age: e["age"] as int))
            .toList();
  }

  Future<void> updateDog(Dog dog) async {
    // Update the given Dog.
    await db?.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );

    // int count = await db.rawUpdate(
    //     'UPDATE dogs SET id = ?, name = ?, age WHERE id = ?',
    //     [dog.id, dog.name, dog.age, dog.id]);
  }

  Future<void> deleteDog(int id) async {
    // Remove the Dog from the database.
    await db?.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
    // int count = await db.rawDelete('DELETE FROM dogs WHERE id = ?', [id]);
  }

  Future<void> close() async {
    // Close the database
    db?.close();
  }
}