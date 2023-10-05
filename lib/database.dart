import 'package:flutter_blog_explorer/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'blog_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorite_blogs(
           id TEXT PRIMARY KEY,
           imageUrl TEXT,
           title TEXT,
           is_favorite INTEGER
          )
        ''');
      },
    );
  }

  Future insertFavorite(Blog blog, bool isFavorite) async {
    final db = await database;
    await db.insert(
      'favorite_blogs',
        {
          'id': blog.id,
          'imageUrl': blog.image_Url,
          'title': blog.title,
          'is_favorite': isFavorite ? 1 : 0,
        }
    );
  }

  Future<void> removeFavorite(int blogId) async {
    final db = await database;
    await db.delete(
      'favorite_blogs',
      where: 'blog_id = ?',
      whereArgs: [blogId],
    );
  }
  Future fetchData()async{
    final db = await database;
    var data = await db.query("favorite_blogs");
    return data;
  }

  Future deleteBlog(String id) async {
    final db = await database;
    await db.delete(
      'favorite_blogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

