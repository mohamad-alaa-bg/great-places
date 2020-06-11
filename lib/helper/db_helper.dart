import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import '../providers/great_places.dart';

class DBHelper {
  //هنا استخدمنا ال static حيث يمكن استدعائها في الملفات الاخرى بدون انشاء object فقط عن طريق اسم الكلاس واسم التابع
   static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();  // مسار الداتا بيز
    //هنا هذا التابع يعيد future من نوع داتابيز حيث في حال كانت الداتابيز موجودة يعيدها
    // في حال كانت غير موجودة يقوم بانشاء واحدة جديدة
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT )'); // اسم ال table هو user_places
      },
      version: 1,
    );
  }

   static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace, // عندما يتم ادخال مرة ثانية عنصر بنفس ال primary key فيقوم بمسح القديم اي استبداله
    );
  }

   static Future<List<Map<String,dynamic>>> getData(String table) async {
     final db = await DBHelper.database();
     return db.query(table);

  }
}
