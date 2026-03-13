import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MortgageItemModel {
  RxString selectedType = "".obs;

  TextEditingController itemController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  Map<String, dynamic> toMap() {
    return {
      "ornament_type": selectedType.value,
      "ornament_name": itemController.text,
      "ornament_quantity": qtyController.text,
    };
  }
}