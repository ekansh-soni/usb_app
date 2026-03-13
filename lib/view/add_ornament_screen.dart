import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usb_app/routes/app_routes.dart';
import 'package:usb_app/theme/app_colors.dart';
import 'package:usb_app/utils/custom_text_widget.dart';
import 'package:usb_app/utils/utils.dart';
import 'package:usb_app/widgets/custom_card_container.dart';
import '../controller/ornament_controller.dart';

class AddOrnamentScreen extends StatelessWidget {
  final OrnamentController controller = Get.find<OrnamentController>();
  final _formKey = GlobalKey<FormState>();

  // Ornament types
  final List<String> ornamentTypes = [
    'Chain',
    'Ring',
    'Earring',
    'Necklace',
    'Bracelet',
    'Nath',
    'Payal',
    'Other',
  ];

  // ✅ Observable variables banao
  final selectedType = 'Chain'.obs;
  final weight = 0.0.obs;
  final rate = 0.0.obs;
  final interest = 0.0.obs;

  AddOrnamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Mortgage Details')),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              EasyStepper(
                activeStep: controller.activeStep.value,
                activeStepBackgroundColor: Colors.white,
                finishedStepBackgroundColor: AppColors.disableColor ,
                activeStepIconColor: AppColors.primaryColor,
                borderThickness: 4,
                activeStepBorderColor: AppColors.textFieldColor,
                finishedStepBorderColor: AppColors.borderColor,
                showLoadingAnimation: false,
                defaultStepBorderType: .normal,
                enableStepTapping: false,
                onStepReached: (index) {
                  controller.goToStep(index);
                },
                steps: [
                  EasyStep(icon: Icon(Icons.person), title: 'Personal', customTitle: CustomTextWidget(text: "Personal")),
                  EasyStep(icon: Icon(Icons.home), title: 'Mortgage'),
                  EasyStep(icon: Icon(Icons.account_balance), title: 'Loan'),
                  EasyStep(icon: Icon(Icons.people), title: 'Guarantor'),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(

                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildStepContent(controller.activeStep.value),
                        spaceHeight(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (controller.activeStep.value > 0)
                              IntrinsicWidth(
                                child: ElevatedButton(
                                  onPressed: controller.previousStep,
                                  child: Text("Back"),
                                ),
                              ),
                  
                            IntrinsicWidth(
                              child: ElevatedButton(
                                onPressed: ()async {

                                  if (!_formKey.currentState!.validate()) return;

                                  /// FINAL STEP → SAVE DATA
                                  if (controller.activeStep.value == 3) {

                                    List<Map<String, dynamic>> mortgageList =
                                    controller.mortgageItems.map((item) => item.toMap()).toList();

                                    var map = {
                                      "borrower_info": {
                                        "borrower_name": controller.borrowerName.text,
                                        "borrower_address": controller.borrowerAddress.text,
                                        "borrower_mobile": controller.borrowerMobile.text,
                                      },

                                      "mortgage_detail": mortgageList,

                                      "loan_detail": {
                                        "total_item_weight": controller.mortgageItemTotalWeight.text,
                                        "loan_amount": controller.loanAmount.text,
                                        "loan_interest": controller.loanInterest.text,
                                        "loan_tenure": controller.loanTenure.text,
                                        "loan_note": controller.loanNote.text
                                      },

                                      "guarantor_detail": {
                                        "guarantor_name": controller.guarantorName.text,
                                        "guarantor_address": controller.guarantorAddress.text,
                                        "guarantor_mobile": controller.guarantorMobile.text
                                      },

                                      "mortgage_by": {
                                        "name": controller.authController.user?.name,
                                        "id": controller.authController.user?.id,
                                        "created_at": DateTime.now().toString()
                                      }
                                    };

                                    int id = await controller.saveBorrowerDetail(map);

                                    Get.delete<OrnamentController>();
                                    Get.offAndToNamed(
                                      AppRoutes.summary,
                                      arguments: {
                                        "borrower_id": id
                                      },
                                    );


                                  } else {

                                    /// NEXT STEP
                                    controller.nextStep();

                                  }

                                },
                                child: Text(
                                  controller.activeStep.value == 3
                                      ? "Submit"
                                      : "Next",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// STEP CONTENT SWITCH
  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _personalInfoTab();

      case 1:
        return _mortgageDetailTab();

      case 2:
        return _loanDetailTab();

      case 3:
        return _addGuarantorTab();

      default:
        return SizedBox();
    }
  }

  Widget _personalInfoTab() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Borrower Details",
          style: TextStyle(fontSize: 24, fontWeight: .bold),
        ),
        spaceHeight(15),
        // Person Name
        CustomCardContainer(
          child: Column(
            children: [
              TextFormField(
                controller: controller.borrowerName,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Borrower',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter borrower name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: controller.borrowerAddress,
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.home),
                  hintText: 'Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter address';
                  }
                  return null;
                },
              ),

              spaceHeight(15),

              TextFormField(
                controller: controller.borrowerMobile,
                decoration: InputDecoration(
                  labelText: 'Mobile',
                  prefixIcon: Icon(Icons.phone_android),
                  hintText: 'Mobile',
                ),
                keyboardType: .number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter mobile';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mortgageDetailTab() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Mortgage Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 15),

        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.mortgageItems.length,
          itemBuilder: (context, index) {

            final item = controller.mortgageItems[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomCardContainer(
                child: Column(
                  children: [

                    /// Ornament Dropdown
                    Obx(() => DropdownButtonFormField<String>(
                      initialValue: item.selectedType.value.isEmpty
                          ? null
                          : item.selectedType.value,
                      decoration: InputDecoration(
                        labelText: 'Ornament type',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: ornamentTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        item.selectedType.value = value!;
                      },
                    )),

                    /// OTHER FIELD
                    Obx(() {
                      if (item.selectedType.value == "Other") {
                        return Column(
                          children: [
                            SizedBox(height: 15),

                            TextFormField(
                              controller: item.itemController,
                              decoration: InputDecoration(
                                labelText: 'Enter Item',
                                prefixIcon: Icon(Icons.edit),
                              ),
                            ),
                          ],
                        );
                      }
                      return SizedBox();
                    }),

                    SizedBox(height: 15),

                    /// QTY
                    TextFormField(
                      controller: item.qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: Icon(Icons.line_weight),
                      ),
                    ),

                    /// REMOVE BUTTON
                    if (controller.mortgageItems.length > 1)
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.removeMortgageItem(index);
                          },
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        )),

        /// ADD MORE BUTTON
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: controller.addMortgageItem,
            child: Text(
              "Add More",
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        )
      ],
    );
  }

  Widget _loanDetailTab() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text("Loan Details", style: TextStyle(fontSize: 24, fontWeight: .bold)),

        spaceHeight(20),

        CustomCardContainer(
          child: Column(
            children: [
              // Weight
              TextFormField(
                controller: controller.mortgageItemTotalWeight,
                decoration: InputDecoration(
                  labelText: 'Total item weight',
                  prefixIcon: Icon(Icons.monitor_weight),
                  hintText: '10.5g',
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter correct weight';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // Rate
              TextFormField(
                controller: controller.loanAmount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Loan Amount',
                  prefixIcon: Icon(Icons.currency_rupee),
                  hintText: '00',
                ),
                onChanged: (value) {
                  // ✅ Jab value change ho to observable update karo
                  rate.value = double.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // Interest
              TextFormField(
                controller: controller.loanInterest,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Interest',
                  prefixIcon: Icon(Icons.percent_outlined),
                  hintText: '8.5%',
                ),
                onChanged: (value) {
                  // ✅ Jab value change ho to observable update karo
                  interest.value = double.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter interest';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid ROI';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: controller.loanTenure,
                decoration: InputDecoration(
                  labelText: 'Tenure',
                  prefixIcon: Icon(Icons.watch_later_outlined),
                  hintText: '3 M/Y',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter tenure';
                  }
                  return null;
                },
              ),

              spaceHeight(15),

              // Notes (optional)
              TextFormField(
                controller: controller.loanNote,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.note),
                  hintText: 'Made with gold',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _addGuarantorTab() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Add Guarantor",
          style: TextStyle(fontSize: 24, fontWeight: .bold),
        ),
        spaceHeight(15),
        CustomCardContainer(
          child: Column(
            children: [
              // Person Name
              TextFormField(
                controller: controller.guarantorName,
                decoration: InputDecoration(
                  labelText: 'Guarantor Name',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Guarantor',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Guarantor name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: controller.guarantorAddress,
                decoration: InputDecoration(
                  labelText: 'Guarantor Address',
                  prefixIcon: Icon(Icons.home),
                  hintText: 'Guarantor Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter guarantor address';
                  }
                  return null;
                },
              ),

              spaceHeight(15),

              TextFormField(
                controller: controller.guarantorMobile,
                decoration: InputDecoration(
                  labelText: 'Mobile',
                  prefixIcon: Icon(Icons.phone_android),
                  hintText: 'Mobile',
                ),
                keyboardType: .number,
                maxLength: 10,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter mobile';
                  }
                  return null;
                },
              ),

              spaceHeight(15),
            ],
          ),
        ),
      ],
    );
  }
}