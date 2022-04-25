import 'package:compta_2/app/data/repository/setting.dart';
import 'package:get/get.dart';

import '../../data/model/setting.dart';

class SettingController extends GetxController {
  final SettingRepository repository;
  SettingController(this.repository);

  RxBool loading = false.obs;

  final settingList = <Setting>[].obs;
  Setting setting = Setting(name: '', value: '');
  List<String> list = ["USD", 'EUR', 'MGA'];
  final selectedCurrency = 'MGA'.obs;

  setCurrentCurrency() {
    selectedCurrency.value = settingList.first.value;
  }

  setCurrency(String value) {
    selectedCurrency.value = value;
    setting = Setting(name: 'currency', value: value.toString());
    saveSetting(setting);
  }

  @override
  void onReady() async {
    super.onReady();
    getAll();
  }

  getAll() {
    loading(true);
    repository.getAll().then((data) {
      settingList.value = data;
      setCurrentCurrency();
      loading(false);
    });
  }

  editMode() {
    loading(true);
    if (Get.arguments == null) {
      saveSetting(setting);
    } else {
      updateSetting(Get.arguments);
    }
  }

  saveSetting(Setting setting) async {
    repository.save(setting).then((data) {
      loading(false);
      refreshSettingList();
    });
  }

  updateSetting(Setting setting) async {
    repository.update(setting).then((data) {
      loading(false);
      refreshSettingList();
    });
  }

  deleteSetting(int settingId) async {
    loading(true);
    repository.delete(settingId).then((data) {
      loading(false);
      refreshSettingList();
    });
  }

  refreshSettingList() {
    getAll();
  }
}
