import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:usb_app/models/borrower_detail_bean.dart';
import 'package:usb_app/service/toast_service.dart';
import '../models/mortgage_item_model.dart';
import '../models/ornament_model.dart';
import '../service/database_helper.dart';
import '../utils/data_records.dart';
import 'auth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrnamentController extends GetxController {
  var ornaments = <OrnamentModel>[].obs;
  var isLoading = false.obs;
  var totalWeight = 0.0.obs;
  var totalPrice = 0.0.obs;
  var totalItems = 0.obs;

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthController authController = Get.find<AuthController>();

  RxList<MortgageItemModel> mortgageItems = <MortgageItemModel>[].obs;

  File borrowerDetailFile = File(DataRecords.borrowerDetail);
  BorrowerDetailBean? borrowerDetailBean;

  List<BorrowerDetailBean> borrowerDetail = [];

  Future<List<BorrowerDetailBean>> getBorrowerDetail() async {
    isLoading(true);
    if (!await borrowerDetailFile.exists()) {
      return [];
    }

    String content = await borrowerDetailFile.readAsString();

    if (content.isEmpty) {
      isLoading(false);
      return [];
    }

    final decoded = jsonDecode(content);

    borrowerDetail = (decoded as List).map((e) {
      isLoading(false);
      return BorrowerDetailBean.fromJson(e);
    }).toList();

    double priceSum = 0.0;
    double weightSum = 0.0;
    int itemSum = 0;

    for (var i in borrowerDetail) {
      priceSum += double.tryParse(i.loanDetail?.loanAmount ?? "0") ?? 0;
      weightSum += double.tryParse(i.loanDetail?.totalItemWeight ?? "0") ?? 0;
      itemSum += i.mortgageDetail?.length ?? 0;
    }

    totalPrice.value = priceSum;
    totalWeight.value = weightSum;
    totalItems.value = itemSum;

    return borrowerDetail;
  }





  // Ornament delete karo
  Future<void> deleteOrnament(int id) async {
    try {
      int result = await _dbHelper.deleteOrnament(id);

      if (result > 0) {
        ornaments.removeWhere((item) => item.id == id);
        // await loadStats();
        Fluttertoast.showToast(msg: "Ornament deleted!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error deleting: $e");
    }
  }

  // Person ke hisaab se ornaments filter karo
  List<OrnamentModel> getOrnamentsByPerson(String personName) {
    return ornaments
        .where(
          (item) =>
              item.personName.toLowerCase().contains(personName.toLowerCase()),
        )
        .toList();
  }


  RxInt activeStep = 0.obs;

  void nextStep() {
    if (activeStep.value < 3) {
      activeStep.value++;
    }
  }

  void previousStep() {
    if (activeStep.value > 0) {
      activeStep.value--;
    }
  }

  void goToStep(int step) {
    activeStep.value = step;
  }

  // User personal info

  TextEditingController borrowerName = TextEditingController();
  TextEditingController borrowerAddress = TextEditingController();
  TextEditingController borrowerMobile = TextEditingController();

  // mortgage information

  TextEditingController mortgageItem = TextEditingController();
  TextEditingController mortgageItemWeight = TextEditingController();
  TextEditingController mortgageItemQty = TextEditingController();

  // loan details

  TextEditingController loanTenure = TextEditingController();
  TextEditingController loanAmount = TextEditingController();
  TextEditingController loanInterest = TextEditingController();
  TextEditingController loanNote = TextEditingController();
  TextEditingController mortgageItemTotalWeight = TextEditingController();
  TextEditingController mortgageItemImage = TextEditingController();

  //  guarantor details

  TextEditingController guarantorName = TextEditingController();
  TextEditingController guarantorAddress = TextEditingController();
  TextEditingController guarantorMobile = TextEditingController();

  Future<int> saveBorrowerDetail(Map<String, dynamic> mortgageData) async {
    List borrowerDetail = [];

    if (await borrowerDetailFile.exists()) {
      String content = await borrowerDetailFile.readAsString();

      if (content.isNotEmpty) {
        borrowerDetail = jsonDecode(content);
      }
    }

    int newId = borrowerDetail.isEmpty
        ? 1
        : borrowerDetail.last["borrower_id"] + 1;

    mortgageData["borrower_id"] = newId;

    borrowerDetail.add(mortgageData);

    await borrowerDetailFile.writeAsString(jsonEncode(borrowerDetail));

    ToastService.showSuccess("Record Save successfully");

    return newId;
  }

  @override
  void onInit() {
    super.onInit();
    mortgageItems.add(MortgageItemModel());

    getBorrowerDetail();
  }

  void addMortgageItem() {
    mortgageItems.add(MortgageItemModel());
  }

  void removeMortgageItem(int index) {
    mortgageItems.removeAt(index);
  }
}
