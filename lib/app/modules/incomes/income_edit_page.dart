import 'package:compta_2/app/modules/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/provider/global.dart';
import '../../data/repository/global.dart';

class IncomeEditPage extends GetView<GlobalController> {
  @override
  final controller =
      Get.put(GlobalController(GlobalRepository(GlobalProvider())));

  IncomeEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.title)),
      body: Form(
        key: controller.formKey,
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
                controller: controller.motifController,
                focusNode: controller.motifFocusNode,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return controller.validateValue(value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your income value',
                ),
                controller: controller.valueController,
                focusNode: controller.valueFocusNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (String value) {
                  controller.editMode();
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
                      controller.editMode();
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
