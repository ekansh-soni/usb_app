import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MortgageItemModel {
  RxString selectedType = "".obs;

  TextEditingController itemController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
}