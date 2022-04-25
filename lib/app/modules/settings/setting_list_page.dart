import 'package:compta_2/app/data/provider/global.dart';
import 'package:compta_2/app/data/repository/global.dart';
import 'package:compta_2/app/modules/settings/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_controller.dart';

class SettingListPage extends GetView<SettingController> {
  SettingListPage({Key? key}) : super(key: key);
  @override
  final controller = Get.find<SettingController>();
  final globalController =
      Get.put(GlobalController(GlobalRepository(GlobalProvider())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Currency'),
                  Obx(() => DropdownButton(
                          onChanged: (newValue) {
                            controller.setCurrency(newValue.toString());
                            globalController.getAll();
                          },
                          value: controller.selectedCurrency.value,
                          items: [
                            for (var data in controller.list)
                              DropdownMenuItem(
                                child: Text(
                                  data,
                                ),
                                value: data,
                              )
                          ]))
                ],
              )
            ],
          ),
        ));
  }
}
