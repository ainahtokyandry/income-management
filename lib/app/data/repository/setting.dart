import '../model/setting.dart';
import '../provider/setting.dart';

class SettingRepository {
  final SettingProvider api;
  SettingRepository(this.api);

  getAll() {
    return api.getAll();
  }

  save(Setting setting) {
    return api.save(setting);
  }

  update(Setting setting) {
    return api.update(setting);
  }

  delete(int id) {
    return api.delete(id);
  }
}
