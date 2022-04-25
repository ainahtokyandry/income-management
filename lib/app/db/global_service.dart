import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/model/expenditure.dart';
import '../data/model/income.dart';

class GlobalService extends GetxService {
  late Database db;
  late Database expenditureDb;

  Future<GlobalService> init() async {
    db = await _getDatabase();
    expenditureDb = await _getExpenditureDatabase();
    return this;
  }

  Future<Database> _getDatabase() async {
    var databasesPath = await getDatabasesPath();
    return db = await openDatabase(
      join(databasesPath, 'incomes.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE incomes (id INTEGER PRIMARY KEY AUTOINCREMENT, motif TEXT, value REAL, created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL)');
      },
      version: 1,
    );
  }

  Future<List<Income>> getAll() async {
    final result =
        await db.rawQuery('SELECT * FROM incomes ORDER BY updated_at');
    return result.map((json) => Income.fromJson(json)).toList();
  }

  Future<Income> save(Income income) async {
    String now = DateTime.now().toString();
    final id = await db.rawInsert(
      'INSERT INTO incomes (motif, value, created_at, updated_at) VALUES (?, ?, ?, ?)',
      [
        income.motif.toString().isEmpty ? '' : income.motif,
        income.value,
        now,
        now
      ],
    );
    return income.copy(id: id);
  }

  Future<List<Income>> get(id) async {
    final result = await db.rawQuery('SELECT * FROM incomes WHERE id=?', [id]);
    return result.map((json) => Income.fromJson(json)).toList();
  }

  Future<Income> update(Income income) async {
    final id = await db.rawUpdate(
        'UPDATE incomes SET motif=?, value = ?, updated_at = ?) WHERE id = ?',
        [income.motif, income.value, income.id, DateTime.now().toString()]);
    return income.copy(id: id);
  }

  Future<int> delete(int incomeId) async {
    final id =
        await db.rawDelete('DELETE FROM incomes WHERE id = ?', [incomeId]);
    final deletedExpenditure = await expenditureDb
        .rawDelete('DELETE FROM expenditures WHERE income_id = ?', [incomeId]);
    return id;
  }

  Future close() async {
    db.close();
  }

  Future<Database> _getExpenditureDatabase() async {
    var databasesPath = await getDatabasesPath();
    return expenditureDb = await openDatabase(
      join(databasesPath, 'expenditures.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE expenditures (id INTEGER PRIMARY KEY AUTOINCREMENT, motif TEXT, value REAL, income_id INT, created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL)');
      },
      version: 1,
    );
  }

  Future<List<Expenditure>> getAllExpenditures() async {
    final result = await expenditureDb
        .rawQuery('SELECT * FROM expenditures ORDER BY updated_at');
    return result.map((json) => Expenditure.fromJson(json)).toList();
  }

  Future<Expenditure> saveExpenditure(Expenditure expenditure) async {
    String now = DateTime.now().toString();
    final id = await expenditureDb.rawInsert(
        'INSERT INTO expenditures (motif, value, income_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)',
        [expenditure.motif, expenditure.value, expenditure.incomeId, now, now]);
    return expenditure.copy(id: id);
  }

  Future<List<Expenditure>> getExpenditure(id) async {
    final result = await expenditureDb
        .rawQuery('SELECT * FROM expenditures WHERE id=?', [id]);
    return result.map((json) => Expenditure.fromJson(json)).toList();
  }

  Future<Expenditure> updateExpenditure(Expenditure expenditure) async {
    final id = await expenditureDb.rawUpdate(
        'UPDATE expenditures SET motif=?, value = ?, income_id = ?, updated_at = ? WHERE id = ?',
        [
          expenditure.motif,
          expenditure.value,
          expenditure.incomeId,
          expenditure.id,
          DateTime.now().toString()
        ]);
    return expenditure.copy(id: id);
  }

  Future<int> deleteExpenditure(int incomeId) async {
    final id = await expenditureDb
        .rawDelete('DELETE FROM expenditures WHERE id = ?', [incomeId]);
    return id;
  }

  Future closeExpenditure() async {
    expenditureDb.close();
  }
}
