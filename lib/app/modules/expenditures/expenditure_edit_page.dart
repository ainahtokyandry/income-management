import 'package:compta_2/app/data/provider/global.dart';
import 'package:compta_2/app/data/repository/global.dart';
import 'package:compta_2/app/modules/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ExpenditureEditPage extends GetView<GlobalController> {
  ExpenditureEditPage({Key? key}) : super(key: key);
  @override
  final controller =
      Get.put(GlobalController(GlobalRepository(GlobalProvider())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.expenditureTitle)),
      body: Form(
        key: controller.expenditureFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Motif',
                ),
                controller: controller.expenditureMotifController,
                focusNode: controller.expenditureMotifFocusNode,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return controller.validateValue(value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your income value',
                ),
                textCapitalization: TextCapitalization.sentences,
                controller: controller.expenditureValueController,
                focusNode: controller.expenditureValueFocusNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (String value) {
                  controller.expenditureEditMode();
                  if (controller.loading.value == true) {
                    Get.dialog(
                        const Center(child: CircularProgressIndicator()));
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*")),
                  FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  return controller.validateValue(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.expenditureEditMode();
                      if (controller.loading.value == true) {
                        Get.dialog(
                            const Center(child: CircularProgressIndicator()));
                      }
                    },
                    child: const Text('ADD'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
