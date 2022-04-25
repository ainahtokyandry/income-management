import 'package:compta_2/app/db/global_service.dart';
import 'package:compta_2/app/db/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/modules/incomes/income_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => GlobalService().init());
  await Get.putAsync(() => SettingService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: IncomeListPage(),
    );
  }
}
