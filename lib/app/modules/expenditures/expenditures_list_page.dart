import 'package:compta_2/app/modules/global_controller.dart';
import 'package:compta_2/app/modules/incomes/income_list_page.dart';
import 'package:compta_2/app/modules/settings/setting_list_page.dart';
import 'package:compta_2/scripts/currency_formatter.dart';
import 'package:compta_2/scripts/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/provider/global.dart';
import '../../data/repository/global.dart';

class ExpenditureListPage extends GetView<GlobalController> {
  @override
  final controller =
      Get.put(GlobalController(GlobalRepository(GlobalProvider())));

  ExpenditureListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of all expenditures'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Get.offAll(() => IncomeListPage(),
                    duration: const Duration(milliseconds: 300),
                    transition: Transition.rightToLeft);
              },
              icon: const Icon(Icons.list)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Get.to(() => SettingListPage(),
                  duration: const Duration(milliseconds: 300),
                  transition: Transition.rightToLeft);
            },
          )
        ],
      ),
      body: Obx(() {
        if (controller.loading.value == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: controller.expenditureList.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            child: Dismissible(
              key: UniqueKey(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd ||
                    direction == DismissDirection.endToStart) {
                  Get.defaultDialog(
                    middleText:
                        'Are you sure you want to delete this expenditure?',
                    textCancel: 'Cancel',
                    onConfirm: () {
                      controller.deleteExpenditure(
                          controller.expenditureList[index].id!);
                      if (controller.loading.value == true) {
                        Get.dialog(
                          const Center(child: CircularProgressIndicator()),
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${currencyFormatter(controller.settingController.selectedCurrency.value.toString(), controller.expenditureList[index].value)} deleted successfully'),
                        ),
                      );
                    },
                  );
                  return false;
                }
                return true;
              },
              child: ListTile(
                title: Text(currencyFormatter(
                    controller.settingController.selectedCurrency.value,
                    controller.expenditureList[index].value)),
                subtitle: Text(
                    '${DateTime.parse(controller.expenditureList[index].createdAt.toString()).isAtSameMomentAs(DateTime.parse(controller.expenditureList[index].updatedAt.toString())) ? 'Created' : 'Updated'} ${dateFormatter(controller.expenditureList[index].updatedAt.toString())}'),
              ),
            ),
            onTap: () {
              controller.selectedExpenditure.value =
                  controller.expenditureList[index];
              controller.expenditureRenderList();
              controller
                  .goToExpenditureDetail(controller.expenditureList[index]);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          controller.addExpenditure();
        },
      ),
    );
  }
}
