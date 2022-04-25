import 'package:compta_2/scripts/currency_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/provider/global.dart';
import '../../data/repository/global.dart';
import '../global_controller.dart';

class IncomeDetailPage extends GetView<GlobalController> {
  @override
  final controller =
      Get.put(GlobalController(GlobalRepository(GlobalProvider())));

  IncomeDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Get.arguments.motif),
          actions: [
            IconButton(
              onPressed: () {
                controller.editIncome(Get.arguments);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                controller.selectedIncome.value = Get.arguments;
                Get.defaultDialog(
                  middleText:
                      'Are you sure you want to delete this income? All information related with will also be deleted.',
                  textCancel: 'Cancel',
                  onConfirm: () {
                    controller
                        .deleteIncome(controller.selectedIncome.value.id!);
                    if (controller.loading.value == true) {
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${currencyFormatter(controller.settingController.selectedCurrency.value.toString(), controller.selectedIncome.value.value)} deleted successfully'),
                      ),
                    );
                    Get.back();
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.loading.value == true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Padding(
                child: Column(
                  children: [
                    for (var data in controller.render)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data[0],
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            data[1],
                            style: TextStyle(
                              fontSize: 14,
                              color: data[2] == true ? Colors.redAccent : null,
                              fontWeight:
                                  data[2] == true ? FontWeight.bold : null,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
              ),
              SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      for (var button in controller.buttonList())
                        TextButton(
                            onPressed: button['handler'],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  button['text'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            )),
                    ],
                  ))
            ],
          );
        }));
  }
}
