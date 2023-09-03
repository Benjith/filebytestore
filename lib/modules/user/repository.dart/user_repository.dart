import 'package:filebytestore/core/app_constants.dart';
import 'package:filebytestore/modules/user/model/user_model.dart';
import 'package:filebytestore/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<List<UserModel>> fetchList(String? keyword, int pageIndex) async {
    try {
      var database = await dbHelper.database;
      List<Map<String, Object?>> data = await database.query(
        AppConstants.tableName,
        orderBy: '${AppConstants.columnId} DESC',
        where: keyword == null ? null : '${AppConstants.columnName} LIKE ?',
        whereArgs: keyword == null ? null : ['%$keyword%'],
      );

      return List.generate(
          data.length, (index) => UserModel.fromJson(data[index]));
    } catch (e) {
      rethrow;
    }
  }

  addUpdateUser(UserModel model) async {
    try {
      print(model.imgUrl?.path);
      var database = await dbHelper.database;
      if (model.id != null) {
        await database.update(AppConstants.tableName, model.toJson(),
            where: '${AppConstants.columnId} = ?', whereArgs: [model.id]);
      } else {
        await database.insert(AppConstants.tableName, model.toJson(),
            conflictAlgorithm: ConflictAlgorithm.abort);
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> delete(int? id) async {
    try {
      var database = await dbHelper.database;
      await database.delete(AppConstants.tableName,
          where: '${AppConstants.columnId} = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
