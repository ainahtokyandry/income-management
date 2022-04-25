import 'package:compta_2/app/modules/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../scripts/currency_formatter.dart';
import '../../data/provider/global.dart';
import '../../data/repository/global.dart';

class ExpenditureDetailPage extends GetView<GlobalController> {
  ExpenditureDetailPage({Key? key}) : super(key: key);

  @override
  final controller =
      Get.put(GlobalController(GlobalRepository(GlobalProvider())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenditure detail'),
        actions: [
          IconButton(
            onPressed: () {
              controller.editExpenditure(Get.arguments);
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              controller.selectedExpenditure.value = Get.arguments;
              Get.defaultDialog(
                middleText: 'Are you sure you want to delete this expenditure?',
                textCancel: 'Cancel',
                onConfirm: () {
                  controller.deleteExpenditure(
                      controller.selectedExpenditure.value.id!);
                  if (controller.loading.value == true) {
                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${currencyFormatter(controller.settingController.selectedCurrency.value.toString(), controller.selectedExpenditure.value.value)} deleted successfully'),
                      duration: const Duration(milliseconds: 900),
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
                  for (var data in controller.renderExpenditure)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data[0],
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          data[1] == true || data[1] == false ? '' : data[1],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                data[1] == true ? FontWeight.bold : null,
                            color: data[1] == true ? Colors.redAccent : null,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              padding: const EdgeInsets.all(12),
            ),
          ],
        );
      }),
    );
  }
}
