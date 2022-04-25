import 'package:compta_2/app/modules/global_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/list_tile.dart';
import '../../../scripts/currency_formatter.dart';
import '../../../widget/app_sbar_sliver_rider.dart';
import '../../data/provider/global.dart';
import '../../data/repository/global.dart';

class IncomeListPage extends GetView<GlobalController> {
  @override
  final controller =
      Get.put(GlobalController(GlobalRepository(GlobalProvider())));

  IncomeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: true,
            expandedHeight: 100,
            shadowColor: const Color.fromRGBO(0, 0, 0, 0),
            backgroundColor: Colors.white,
            flexibleSpace: SpaceBar(
              builder: (context, scrollingRate) {
                return Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3, left: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'List of incomes',
                            style: TextStyle(
                                fontSize: 30 - 7 * scrollingRate,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Obx(() {
                if (controller.loading.value == true) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd ||
                        direction == DismissDirection.endToStart) {
                      Get.defaultDialog(
                        middleText:
                            'Are you sure you want to delete this income?',
                        textCancel: 'Cancel',
                        onConfirm: () {
                          controller
                              .deleteIncome(controller.incomeList[index].id!);
                          if (controller.loading.value == true) {
                            Get.dialog(
                              const Center(child: CircularProgressIndicator()),
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${currencyFormatter(controller.settingController.selectedCurrency.value.toString(), controller.incomeList[index].value)} deleted successfully'),
                            ),
                          );
                        },
                      );
                      return false;
                    }
                    return true;
                  },
                  child: RefreshableListTile(
                    title: controller.incomeList[index].value,
                    createdAt:
                        controller.incomeList[index].createdAt.toString(),
                    updatedAt:
                        controller.incomeList[index].updatedAt.toString(),
                  ),
                );
              });
            }, childCount: controller.incomeList.length),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          controller.addIncome();
        },
      ),
    );
  }
}
