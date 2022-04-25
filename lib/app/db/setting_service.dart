import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/model/setting.dart';

class SettingService extends GetxService {
  late Database db;

  Future<SettingService> init() async {
    db = await _getDatabase();
    save(Setting(name: 'currency', value: 'MGA'));
    return this;
  }

  Future<Database> _getDatabase() async {
    var databasesPath = await getDatabasesPath();
    return db = await openDatabase(
      join(databasesPath, 'settings.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE settings (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(32), value VARCHAR(32), created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL)');
        return db.execute('CREATE UNIQUE INDEX idx_name ON settings (name)');
      },
      version: 1,
    );
  }

  Future<List<Setting>> getAll() async {
    final result =
        await db.rawQuery('SELECT * FROM settings ORDER BY updated_at');
    return result.map((json) => Setting.fromJson(json)).toList();
  }

  Future<Setting> save(Setting setting) async {
    final id = await db.rawInsert(
        'INSERT OR REPLACE INTO settings (name, value, created_at, updated_at) VALUES (?, ?, datetime("now", "localtime"), datetime("now", "localtime"))',
        [setting.name, setting.value]);
    return setting.copy(id: id);
  }

  Future<Setting> update(Setting setting) async {
    final id = await db.rawUpdate(
        'UPDATE settings SET name = ? value = ?, updated_at = datetime("now", "localtime") WHERE id = ?',
        [setting.name, setting.value, setting.id]);
    return setting.copy(id: id);
  }

  Future<int> delete(int settingId) async {
    final id =
        await db.rawDelete('DELETE FROM settings WHERE id = ?', [settingId]);
    return id;
  }

  Future close() async {
    db.close();
  }
}
