import 'package:flutter/widgets.dart';
import 'model/dog.dart';
import 'sqlite_database.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  final database = SqliteDatabase.instance;

  await database.openConnect();
  // Create a Dog and add it to the dogs table
  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  await database.insertDog(fido);

  // Now, use the method above to retrieve all the dogs.
  print("listDog after insertDog");
  print(await database.listDog()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await database.updateDog(fido);

  print("listDog after updateDog");
  // Print the updated results.
  print(await database.listDog()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await database.deleteDog(fido.id);

  print("listDog after deleteDog");
  // Print the list of dogs (empty).
  print(await database.listDog());
}
