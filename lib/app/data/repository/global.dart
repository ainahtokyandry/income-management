import 'package:compta_2/app/data/provider/global.dart';

import '../model/expenditure.dart';
import '../model/income.dart';

class GlobalRepository {
  final GlobalProvider api;
  GlobalRepository(this.api);

  getAll() {
    return api.getAll();
  }

  get(id) {
    return api.get(id);
  }

  save(Income income) {
    return api.save(income);
  }

  update(Income income) {
    return api.update(income);
  }

  delete(int id) {
    return api.delete(id);
  }

  getAllExpenditures() {
    return api.getAllExpenditures();
  }

  getExpenditure(id) {
    return api.getExpenditure(id);
  }

  saveExpenditure(Expenditure expenditure) {
    return api.saveExpenditure(expenditure);
  }

  updateExpenditure(Expenditure expenditure) {
    return api.updateExpenditure(expenditure);
  }

  deleteExpenditure(int id) {
    return api.deleteExpenditure(id);
  }
}
