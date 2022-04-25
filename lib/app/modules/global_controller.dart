import 'package:compta_2/app/data/repository/global.dart';
import 'package:compta_2/app/modules/settings/setting_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../scripts/currency_formatter.dart';
import '../../scripts/date_formatter.dart';
import '../data/model/expenditure.dart';
import '../data/model/income.dart';
import '../data/provider/setting.dart';
import '../data/repository/setting.dart';
import 'expenditures/expenditure_detail_page.dart';
import 'expenditures/expenditure_edit_page.dart';
import 'expenditures/expenditures_list_page.dart';
import 'incomes/income_detail_page.dart';
import 'incomes/income_edit_page.dart';

class GlobalController extends GetxController {
  final GlobalRepository repository;
  GlobalController(this.repository);

  final settingController =
      Get.put(SettingController(SettingRepository(SettingProvider())));

  RxBool loading = false.obs;
  final expenditureList = <Expenditure>[].obs;
  RxInt activeIncomeId = 0.obs;
  RxList render = [].obs;
  RxList renderExpenditure = [].obs;
  final incomeList = <Income>[].obs;
  RxList formattedIncomeList = [].obs;

  var selectedExpenditure =
      Expenditure(id: 0, motif: '', value: 0, incomeId: 0).obs;
  var selectedIncome = Income(id: 0, motif: '', value: 0).obs;

  GlobalKey<FormState> expenditureFormKey = GlobalKey<FormState>();
  TextEditingController expenditureMotifController = TextEditingController();
  TextEditingController expenditureValueController = TextEditingController();
  FocusNode expenditureMotifFocusNode = FocusNode();
  FocusNode expenditureValueFocusNode = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController motifController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  FocusNode motifFocusNode = FocusNode();
  FocusNode valueFocusNode = FocusNode();

  String expenditureTitle = '';
  String title = '';

  @override
  void onReady() async {
    super.onReady();
    getAll();
    getAllExpenditures();
  }

  formatIncomeList() {
    for (var element in incomeList) {
      String dateText =
          '${DateTime.parse(element.createdAt.toString()).isAtSameMomentAs(DateTime.parse(element.updatedAt.toString())) ? 'Created' : 'Updated'} ${dateFormatter(element.updatedAt.toString())}';
      formattedIncomeList.add([
        currencyFormatter(
            settingController.selectedCurrency.value, element.value),
        dateText
      ]);
    }
  }

  getExpenditure(id) {
    return repository.get(id);
  }

  validateValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insert a value';
    }
    return null;
  }

  renderList(income) async {
    loading(true);
    getAllExpenditures();
    income = await getIncome(income.id);
    income = income.first;
    double totalExpenditureValue = 0;
    render.value = [];
    render.add([
      'Amount',
      currencyFormatter(
          settingController.selectedCurrency.value.toString(), income.value),
      ''
    ]);
    for (var element in expenditureList) {
      totalExpenditureValue += element.value;
    }
    if (expenditureList.isNotEmpty) {
      render.add([
        'Total of expenditure${expenditureList.length > 1 ? 's' : ''}',
        currencyFormatter(settingController.selectedCurrency.value.toString(),
            totalExpenditureValue),
        ''
      ]);
      render.add([
        'Rest',
        currencyFormatter(settingController.selectedCurrency.value.toString(),
            income.value - totalExpenditureValue),
        income.value - totalExpenditureValue < income.value / 5
      ]);
    }
    if (income.createdAt != null) {
      render.add(['Added ${dateFormatter(income.createdAt)}', '', '']);
    }
    if (!DateTime.parse(income.createdAt.toString())
        .isAtSameMomentAs(DateTime.parse(income.updatedAt.toString()))) {
      render
          .add(['Updated at', dateFormatter(income.updatedAt.toString()), '']);
    }
  }

  goToDetail(Income income) {
    activeIncomeId.value = income.id!;
    selectedIncome.value = income;
    Get.to(() => IncomeDetailPage(),
        arguments: income,
        duration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft);
  }

  deleteIncome(int incomeId) async {
    loading(true);
    repository.delete(incomeId).then((data) {
      loading(false);
      refreshIncomeList();
    });
  }

  editIncome(Income income) {
    motifController.text = income.motif.toString();
    valueController.text = income.value.toString();
    title = 'Edit income';
    // refreshIncomeList();
    // renderList(income);
    Get.to(() => IncomeEditPage(),
        arguments: income.id,
        duration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft);
  }

  addIncome() {
    formKey.currentState?.reset();
    motifController.text = '';
    valueController.text = '';
    title = 'Add an income';
    Get.to(() => IncomeEditPage(),
        duration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft);
  }

  editMode() {
    motifFocusNode.unfocus();
    valueFocusNode.unfocus();
    if (formKey.currentState!.validate()) {
      loading(true);
      if (Get.arguments == null) {
        saveIncome();
      } else {
        updateIncome();
      }
    }
  }

  saveIncome() async {
    final income = Income(
      motif: motifController.text,
      value: double.parse(valueController.text),
    );
    repository.save(income).then((data) {
      loading(false);
      refreshIncomeList();
    });
  }

  refreshIncomeList() {
    getAll();
    Get.back();
    Get.back();
  }

  updateIncome() async {
    final income = Income(
      id: Get.arguments,
      motif: motifController.text,
      value: double.parse(valueController.text),
    );
    repository.update(income).then((data) {
      loading(false);
      activeIncomeId.value = income.id!;
      Get.off(() => IncomeDetailPage(),
          arguments: income,
          duration: const Duration(milliseconds: 300),
          transition: Transition.rightToLeft);
      refreshIncomeList();
      renderList(income);
    });
  }

  goToExpenditureDetail(Expenditure expenditure) {
    Get.to(() => ExpenditureDetailPage(),
        arguments: expenditure,
        duration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft);
  }

  deleteExpenditure(int expenditureId) async {
    loading(true);
    repository.deleteExpenditure(expenditureId).then((data) {
      loading(false);
      refreshExpenditureList();
    });
  }

  addExpenditure() {
    expenditureFormKey.currentState?.reset();
    expenditureMotifController.text = '';
    expenditureValueController.text = '';
    expenditureTitle = 'Add an expenditure';
    Get.to(() => ExpenditureEditPage(),
        duration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft);
  }

  editExpenditure(Expenditure expenditure) {
    expenditureMotifController.text = expenditure.motif.toString();
    expenditureValueController.text = expenditure.value.toString();
    expenditureTitle = 'Edit expenditure';
    getAll();
    renderList(expenditure);
    Get.to(() => ExpenditureEditPage(),
        arguments: expenditure.id,
        duration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft);
  }

  expenditureEditMode() {
    expenditureMotifFocusNode.unfocus();
    expenditureValueFocusNode.unfocus();
    if (expenditureFormKey.currentState!.validate()) {
      loading(true);
      if (Get.arguments == null) {
        saveExpenditure();
      } else {
        updateExpenditure();
      }
    }
  }

  saveExpenditure() {
    final expenditure = Expenditure(
        motif: expenditureMotifController.text,
        value: double.parse(expenditureValueController.text),
        incomeId: activeIncomeId.value);
    repository.saveExpenditure(expenditure).then((data) {
      loading(false);
      refreshExpenditureList();
      renderList(Income(id: activeIncomeId.value, motif: '', value: 0));
    });
  }

  updateExpenditure() {
    final expenditure = Expenditure(
        id: Get.arguments,
        motif: expenditureMotifController.text,
        value: double.parse(expenditureValueController.text),
        incomeId: activeIncomeId.value);
    repository.updateExpenditure(expenditure).then((data) {
      loading(false);
      refreshExpenditureList();
      renderList(Income(id: activeIncomeId.value, motif: '', value: 0));
    });
  }

  refreshExpenditureList() {
    getAllExpenditures();
    Get.back();
    Get.back();
  }

  buttonList() {
    List button = [
      {
        'text': 'Add an expenditure',
        'handler': () {
          activeIncomeId.value = Get.arguments.id;
          addExpenditure();
        }
      },
      {
        'text': 'Expenditures',
        'handler': () {
          Get.to(() => ExpenditureListPage(),
              duration: const Duration(milliseconds: 300),
              transition: Transition.rightToLeft);
        }
      },
    ];
    return button;
  }

  getAll() {
    loading(true);
    repository.getAll().then((data) {
      incomeList.value = data;
      loading(false);
    });
  }

  getAllExpenditures() {
    loading(true);
    repository.getAllExpenditures().then((data) {
      List<Expenditure> tmp = [];
      expenditureList.value = data;
      for (var element in expenditureList) {
        if (element.incomeId == activeIncomeId.value) {
          tmp.add(element);
        }
      }
      expenditureList.value = tmp;
      loading(false);
    });
  }

  getIncome(id) {
    return repository.get(id);
  }

  expenditureRenderList() async {
    loading(true);
    renderExpenditure.value = [];
    renderExpenditure.add([
      'Amount',
      currencyFormatter(settingController.selectedCurrency.value.toString(),
          selectedExpenditure.value.value),
    ]);
    renderExpenditure.add([
      '${((selectedExpenditure.value.value * 100) / selectedIncome.value.value).toStringAsFixed(2)}% of the income',
      ((selectedExpenditure.value.value * 100) / selectedIncome.value.value) >
          80
    ]);
    if (selectedExpenditure.value.createdAt != null) {
      renderExpenditure.add([
        'Added ${dateFormatter(selectedExpenditure.value.createdAt.toString())}',
        ''
      ]);
    }
    if (!DateTime.parse(selectedExpenditure.value.createdAt.toString())
        .isAtSameMomentAs(
            DateTime.parse(selectedExpenditure.value.updatedAt.toString()))) {
      renderExpenditure.add([
        'Updated ',
        dateFormatter(selectedExpenditure.value.updatedAt.toString())
      ]);
    }
    loading(false);
  }
}
