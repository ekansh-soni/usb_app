import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usb_app/models/borrower_detail_bean.dart' as borrower_detail_bean;
import 'package:usb_app/routes/app_routes.dart';
import 'package:usb_app/utils/custom_text_widget.dart';
import 'package:usb_app/utils/utils.dart';
import 'package:usb_app/widgets/custom_card_container.dart';

import '../controller/summary_controller.dart';

class SummaryScreen extends StatelessWidget {
  final controller = Get.put(SummaryController());

  SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextWidget(
          text: "Summary",
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: false,
        actions: [
          TextButton(onPressed: (){
            Get.offAndToNamed(AppRoutes.home);
          }, child: CustomTextWidget(text: "Done", color:  Colors.white, fontWeight: .bold,))
        ],
      ),

      body:  Obx(() {
        if(controller.isLoading.value){
          return Center(child: CircularProgressIndicator(),);
        }
        return SingleChildScrollView(
          padding: .all(24),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomCardContainer(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          CustomTextWidget(text: "Borrower Info", fontSize: 16),
                          spaceHeight(10),
                          commonRow(
                            "Name:",
                            controller
                                .borrowerDetailBean
                                ?.borrowerInfo
                                ?.borrowerName,
                          ),
                          commonRow(
                            "Mobile:",
                            controller
                                .borrowerDetailBean
                                ?.borrowerInfo
                                ?.borrowerMobile,
                          ),
                          commonRow(
                            "Address:",
                            controller
                                .borrowerDetailBean
                                ?.borrowerInfo
                                ?.borrowerAddress,
                          ),
                        ],
                      ),
                    ),
                  ),
                  spaceWeight(20),
                  Expanded(
                    child: CustomCardContainer(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          CustomTextWidget(text: "Guarantor Detail", fontSize: 16),
                          spaceHeight(10),
                          commonRow(
                            "Name:",
                            controller
                                .borrowerDetailBean
                                ?.guarantorDetail
                                ?.guarantorName,
                          ),
                          commonRow(
                            "Mobile:",
                            controller
                                .borrowerDetailBean
                                ?.guarantorDetail
                                ?.guarantorMobile,
                          ),
                          commonRow(
                            "Address:",
                            controller
                                .borrowerDetailBean
                                ?.guarantorDetail
                                ?.guarantorAddress,
                          ),
                        ],
                      ),
                    ),
                  ),
                  spaceWeight(20),
                  Expanded(
                    child: CustomCardContainer(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          CustomTextWidget(text: "Mortgage By", fontSize: 16),
                          spaceHeight(10),
                          commonRow(
                            "Name:",
                            controller
                                .borrowerDetailBean
                                ?.mortgageBy
                                ?.name,
                          ),
                          commonRow(
                              "Date:",

                              getDate(controller.borrowerDetailBean?.mortgageBy!.createdAt ?? "",)

                          ),
                          commonRow(
                              "Time:",
                              getTime(controller.borrowerDetailBean?.mortgageBy!.createdAt ?? "",)
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              spaceHeight(10),

              CustomCardContainer(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    CustomTextWidget(text: "Loan Details", fontSize: 16),
                    spaceHeight(10),
                    commonRow(
                      "Loan Amount:",
                      controller
                          .borrowerDetailBean
                          ?.loanDetail
                          ?.loanAmount,
                    ),
                    commonRow(
                      "Loan Interest:",
                      controller
                          .borrowerDetailBean
                          ?.loanDetail
                          ?.loanInterest,
                    ),
                    commonRow(
                      "Tenure:",
                      controller
                          .borrowerDetailBean
                          ?.loanDetail
                          ?.loanTenure,
                    ),

                    commonRow(
                        "Item Weight:",
                        controller
                            .borrowerDetailBean
                            ?.loanDetail
                            ?.totalItemWeight
                    ),


                    commonRow(
                      "Note:",
                      controller
                          .borrowerDetailBean
                          ?.loanDetail
                          ?.loanNote ?? "N/A",
                    ),


                  ],
                ),
              ),


              CustomTextWidget(text: "Mortgage Items",fontSize: 20,),
              spaceHeight(20),

              ListView.builder(
                shrinkWrap: true,
                itemCount: controller.borrowerDetailBean?.mortgageDetail?.length,
                itemBuilder: (context, index) {
                  var item = controller.borrowerDetailBean?.mortgageDetail?[index];
                  return _buildOrnamentCard(item, context);
                },
              )
            ],
          ),
        );
      },),
    );
  }

  Widget _buildOrnamentCard(borrower_detail_bean.MortgageDetail? ornament, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade100,
          child: Icon(
            _getOrnamentIcon(ornament?.ornamentType ?? ""),
            color: Colors.amber.shade800,
          ),
        ),
        title: Text(
          "${ornament?.ornamentType}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(ornament?.ornamentName??""),

        trailing: CustomTextWidget(text: "Qty ${ornament?.ornamentQuantity}"),
      ),
    );
  }

  // Ornament type ke hisaab se icon
  IconData _getOrnamentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'chain':
        return Icons.link;
      case 'ring':
        return Icons.circle;
      case 'earring':
        return Icons.earbuds;
      case 'necklace':
        return Icons.favorite;
      default:
        return Icons.diamond;
    }
  }
}
