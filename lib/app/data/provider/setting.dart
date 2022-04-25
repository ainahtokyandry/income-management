import 'package:compta_2/app/data/model/setting.dart';
import 'package:compta_2/app/db/setting_service.dart';
import 'package:get/get.dart';

class SettingProvider {
  final settingService = Get.find<SettingService>();

  Future<List<Setting>> getAll() async {
    return await settingService.getAll();
  }

  Future<Setting> save(Setting setting) async {
    return await settingService.save(setting);
  }

  Future<Setting> update(Setting setting) async {
    return await settingService.update(setting);
  }

  Future<int> delete(int settingId) async {
    return await settingService.delete(settingId);
  }
}
