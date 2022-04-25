import 'package:compta_2/app/db/global_service.dart';
import 'package:get/get.dart';

import '../model/expenditure.dart';
import '../model/income.dart';

class GlobalProvider {
  final incomeService = Get.put(GlobalService());

  Future<List<Income>> getAll() async {
    return await incomeService.getAll();
  }

  Future<Income> save(Income income) async {
    return await incomeService.save(income);
  }

  Future<List<Income>> get(id) async {
    return await incomeService.get(id);
  }

  Future<Income> update(Income income) async {
    return await incomeService.update(income);
  }

  Future<int> delete(int incomeId) async {
    return await incomeService.delete(incomeId);
  }

  final expenditureProvider = Get.find<GlobalService>();

  Future<List<Expenditure>> getAllExpenditures() async {
    return await expenditureProvider.getAllExpenditures();
  }

  Future<Expenditure> saveExpenditure(Expenditure expenditure) async {
    return await expenditureProvider.saveExpenditure(expenditure);
  }

  Future<List<Expenditure>> getExpenditure(id) async {
    return await expenditureProvider.getExpenditure(id);
  }

  Future<Expenditure> updateExpenditure(Expenditure expenditure) async {
    return await expenditureProvider.updateExpenditure(expenditure);
  }

  Future<int> deleteExpenditure(int incomeId) async {
    return await expenditureProvider.delete(incomeId);
  }
}
