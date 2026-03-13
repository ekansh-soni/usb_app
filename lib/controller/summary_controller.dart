import 'package:get/get.dart';

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:usb_app/utils/data_records.dart';

import '../models/borrower_detail_bean.dart';

class SummaryController extends GetxController {

  var arguments = Get.arguments;
  var isLoading = false.obs;


  File borrowerDetailFile = File(DataRecords.borrowerDetail);
  BorrowerDetailBean? borrowerDetailBean;

  Future<void> getSummary(int id) async {
    isLoading(true);
    if (!await borrowerDetailFile.exists()) return;

    String content = await borrowerDetailFile.readAsString();

    if (content.isEmpty) return;

    List borrowerList = jsonDecode(content);

    var borrower = borrowerList.firstWhere(
          (e) => e["borrower_id"] == id,
      orElse: () {
            isLoading(false);
        return null;
      },
    );

    if (borrower != null) {
      isLoading(false);
      borrowerDetailBean = BorrowerDetailBean.fromJson(borrower);
    }
  }

  @override
  void onInit() {
    super.onInit();

    if (arguments != null) {
      getSummary(arguments["borrower_id"]);
    }
  }
}