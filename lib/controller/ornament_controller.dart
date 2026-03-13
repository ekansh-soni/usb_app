import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:usb_app/service/toast_service.dart';
import '../models/mortgage_item_model.dart';
import '../models/ornament_model.dart';
import '../service/database_helper.dart';
import 'auth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrnamentController extends GetxController {
  var ornaments = <OrnamentModel>[].obs;
  var isLoading = false.obs;
  var totalWeight = 0.0.obs;
  var totalPrice = 0.0.obs;
  var totalItems = 0.obs;

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthController _authController = Get.find<AuthController>();

  RxList<MortgageItemModel> mortgageItems = <MortgageItemModel>[].obs;



  // Saare ornaments load karo
  Future<void> loadOrnaments() async {
    try {
      isLoading.value = true;

      int userId = _authController.currentUser.value?.id ?? 0;

      if (userId > 0) {
        var loadedOrnaments = await _dbHelper.getUserOrnaments(userId);
        ornaments.value = loadedOrnaments;
        await loadStats();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading ornaments: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Stats load karo (total weight, price, items)
  Future<void> loadStats() async {
    int userId = _authController.currentUser.value?.id ?? 0;

    if (userId > 0) {
      var stats = await _dbHelper.getTotalStats(userId);
      totalWeight.value = stats['totalWeight'] ?? 0;
      totalPrice.value = stats['totalPrice'] ?? 0;
      totalItems.value = stats['totalItems']?.toInt() ?? 0;
    }
  }

  // Naya ornament add karo
  Future<void> addOrnament({
    required String personName,
    required String ornamentType,
    required double weight,
    required double rate,
    required double interest,
    String? notes,
  }) async {
    try {
      isLoading.value = true;

      int userId = _authController.currentUser.value?.id ?? 0;

      if (userId == 0) {
        Fluttertoast.showToast(msg: "User not found!");
        return;
      }

      double totalPrice = weight * rate;

      OrnamentModel newOrnament = OrnamentModel(
        userId: userId,
        personName: personName,
        ornamentType: ornamentType,
        weight: weight,
        rate: rate,
        totalPrice: totalPrice,
        date: DateTime.now().toIso8601String(),
        interest: interest,
        notes: notes,
      );

      int id = await _dbHelper.addOrnament(newOrnament);

      if (id != -1) {
        newOrnament.id = id;
        ornaments.add(newOrnament);
        await loadStats();

        ToastService.showSuccess("Ornament added successfully! ✨");
        Get.back();
      }
    } catch (e) {
      ToastService.showError( "Error adding ornament: $e");
      print( "Error adding ornament: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Ornament delete karo
  Future<void> deleteOrnament(int id) async {
    try {
      int result = await _dbHelper.deleteOrnament(id);

      if (result > 0) {
        ornaments.removeWhere((item) => item.id == id);
        await loadStats();
        Fluttertoast.showToast(msg: "Ornament deleted!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error deleting: $e");
    }
  }

  // Person ke hisaab se ornaments filter karo
  List<OrnamentModel> getOrnamentsByPerson(String personName) {
    return ornaments.where((item) =>
        item.personName.toLowerCase().contains(personName.toLowerCase())
    ).toList();
  }

  // Total price for a specific person
  double getPersonTotal(String personName) {
    double total = 0;
    for (var item in ornaments) {
      if (item.personName == personName) {
        total += item.totalPrice;
      }
    }
    return total;
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
  TextEditingController mortgageItemTotalWeight = TextEditingController();
  TextEditingController mortgageItemImage = TextEditingController();

  //  guarantor details


  TextEditingController guarantorName = TextEditingController();
  TextEditingController guarantorAddress = TextEditingController();
  TextEditingController guarantorMobile = TextEditingController();



  @override
  void onInit() {
    super.onInit();
    mortgageItems.add(MortgageItemModel());
    loadOrnaments();
  }

  void addMortgageItem() {
    mortgageItems.add(MortgageItemModel());
  }

  void removeMortgageItem(int index) {
    mortgageItems.removeAt(index);
  }

}