import 'dart:async';

import 'package:compta_2/app/data/provider/setting.dart';
import 'package:compta_2/app/data/repository/setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../app/modules/settings/setting_controller.dart';
import '../scripts/currency_formatter.dart';
import '../scripts/date_formatter.dart';

class RefreshableListTile extends StatefulWidget {
  RefreshableListTile(
      {Key? key,
      required this.title,
      required this.createdAt,
      required this.updatedAt})
      : super(key: key);
  final settingController =
      Get.put(SettingController(SettingRepository(SettingProvider())));
  final double title;
  final String createdAt;
  final String updatedAt;

  @override
  State<StatefulWidget> createState() {
    return _RefreshableListTile();
  }
}

class _RefreshableListTile extends State<RefreshableListTile> {
  String rTitle = '';
  String rSubtitle = '';

  @override
  initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      rTitle = currencyFormatter(
          widget.settingController.selectedCurrency.value, widget.title);
      rSubtitle =
          '${DateTime.parse(widget.createdAt).isAtSameMomentAs(DateTime.parse(widget.updatedAt.toString())) ? 'Created' : 'Updated'} ${dateFormatter(widget.updatedAt.toString())}';
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(rTitle),
      subtitle: Text(
        rSubtitle,
      ),
    );
  }
}
