import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:usb_app/service/shared_preference_helper.dart';
import 'package:usb_app/utils/custom_text_widget.dart';
import 'package:usb_app/utils/utils.dart';

import '../controller/auth_controller.dart';
import '../controller/ornament_controller.dart';
import '../models/borrower_detail_bean.dart';
import '../models/ornament_model.dart';
import 'add_ornament_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final OrnamentController _ornamentController = Get.put(OrnamentController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jewelry App'),
        actions: [
          // Logout button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),

      // FAB for adding new ornament
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddOrnamentScreen()),
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
          // Welcome Card
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade400, Colors.amber.shade700],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Namaste, ${SharedPreferencesHelper().getString("userName")} 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Apna jewelry track karein',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Stats Cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                // Total Items
                Obx(() => Expanded(
                  child: _buildStatCard(
                    icon: Icons.diamond,
                    label: 'Total Items',
                    value: '${_ornamentController.totalItems.value}',
                    color: Colors.blue,
                  ),
                ),),
                SizedBox(width: 10),
                // Total Weight
                Obx(() => Expanded(
                  child: _buildStatCard(
                    icon: Icons.monitor_weight,
                    label: 'Weight (g)',
                    value: _ornamentController.totalWeight.value
                        .toStringAsFixed(2),
                    color: Colors.green,
                  ),
                ),),
                SizedBox(width: 10),
                // Total Price
                Obx(() => Expanded(
                  child: _buildStatCard(
                    icon: Icons.currency_rupee,
                    label: 'Total Price',
                    value:
                    '₹${_ornamentController.totalPrice.value.toStringAsFixed(0)}',
                    color: Colors.orange,
                  ),
                ),)
              ],
            ),
          ),

          SizedBox(height: 15),

          // Recent Ornaments Heading
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Ornaments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Filter option
                  },
                  child: Text('View All →'),
                ),
              ],
            ),
          ),

          SizedBox(height: 5),

          // Ornaments List
          Expanded(
            child: Obx(() {
              if (_ornamentController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (_ornamentController.borrowerDetail.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey.shade400),
                      SizedBox(height: 10),
                      Text(
                        'No Item found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Press + to add item',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: _ornamentController.borrowerDetail.length,
                itemBuilder: (context, index) {
                  var ornament = _ornamentController.borrowerDetail[index];
                  return _buildOrnamentCard(ornament, context);
                },
              );
            }),
          ),

          spaceHeight(100),
        ],
      ),
    );
  }

  // Stat Card Widget
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Ornament Card Widget
  Widget _buildOrnamentCard(
    BorrowerDetailBean? borrowerDetailBean,
    BuildContext context,
  ) {
    var borrowerInfo = borrowerDetailBean?.borrowerInfo;
    var loanDetail = borrowerDetailBean?.loanDetail;
    var mortgageBy = borrowerDetailBean?.mortgageBy;
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        // leading: CircleAvatar(
        //   backgroundColor: Colors.amber.shade100,
        //   child: Icon(
        //     _getOrnamentIcon(borrowerDetailBean?.mortgageDetail.ornamentType),
        //     color: Colors.amber.shade800,
        //   ),
        // ),
        title: Text(
          borrowerInfo?.borrowerName ?? "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // subtitle: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(ornament.ornamentType),
        //     Text(
        //       '${ornament.weight}g × ₹${ornament.rate}/g',
        //       style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        //     ),
        //   ],
        // ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${loanDetail?.loanAmount ?? ""}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat(
                'dd MMM yyyy',
              ).format(DateTime.parse(mortgageBy?.createdAt?.toString() ?? '')),
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
        // onLongPress: () => _showDeleteDialog(context, ornament),
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) =>
                  Padding(
                    padding: .all(16),
                    child: _showItemBottomSheet(borrowerDetailBean),
                  ),
            ),
            context: context,
          );
        },
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

  // Delete confirmation dialog
  void _showDeleteDialog(BuildContext context, OrnamentModel ornament) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Ornament?'),
        content: Text(
          '${ornament.personName} ka ${ornament.ornamentType} delete karna chahte ho?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _ornamentController.deleteOrnament(ornament.id!);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _showItemBottomSheet(BorrowerDetailBean? borrowerDetailBean) {

    var borrowerInfo = borrowerDetailBean?.borrowerInfo;
    var mortgageDetail = borrowerDetailBean?.mortgageDetail;
    var loanDetail = borrowerDetailBean?.loanDetail;
    var guarantorDetail = borrowerDetailBean?.guarantorDetail;
    var mortgageBy = borrowerDetailBean?.mortgageBy;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(Get.context!).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [

            CustomTextWidget(text: "Borrower Info", fontSize: 18,),

            commonRow("Name", borrowerInfo?.borrowerName),
            commonRow("Ornament Type", borrowerInfo?.borrowerAddress),
            commonRow("Date", borrowerInfo?.borrowerMobile),

            Divider(thickness: 0.5,),

            CustomTextWidget(text: "Mortgage Details", fontSize: 18,),

            ListView.builder(
              itemCount: mortgageDetail?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = mortgageDetail?[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.shade100,
                    child: Icon(
                      _getOrnamentIcon("${data?.ornamentType}"),
                      color: Colors.amber.shade800,
                    ),
                  ),
                  title: CustomTextWidget(text: "${data?.ornamentType}"),
                  subtitle: CustomTextWidget(text: "${data?.ornamentName}"),
                  trailing: CustomTextWidget(text: "Qty: ${data?.ornamentQuantity}"),
                );

              },
            ),
            Divider(thickness: 0.5,),

            CustomTextWidget(text: "Loan Details", fontSize: 18,),
            spaceHeight(10),
            commonRow("Amount", loanDetail?.loanAmount),
            spaceHeight(5),
            commonRow("Tenure/Per", "${loanDetail?.loanTenure} @ ${loanDetail?.loanInterest}%"),
            spaceHeight(5),
            commonRow("Item Weight", loanDetail?.totalItemWeight),
            spaceHeight(5),
            commonRow("Loan Note", checkString("${loanDetail?.loanNote}")),


            Divider(thickness: 0.5,),

            CustomTextWidget(text: "Guarantor Details", fontSize: 18,),
            spaceHeight(10),
            commonRow("Amount", guarantorDetail?.guarantorName),
            spaceHeight(5),
            commonRow("Mobile", guarantorDetail?.guarantorMobile),
            spaceHeight(5),
            commonRow("Address", guarantorDetail?.guarantorAddress),
            spaceHeight(5),

            Divider(thickness: 0.5,),

            CustomTextWidget(text: "Mortgage By", fontSize: 18,),
            spaceHeight(10),
            commonRow("Name", mortgageBy?.name),
            spaceHeight(5),




          ],
        ),
      ),
    );
  }
}
