import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usb_app/utils/utils.dart';
import '../controller/auth_controller.dart';
import '../controller/ornament_controller.dart';
import '../models/ornament_model.dart';
import 'package:intl/intl.dart';

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
                  'Namaste, ${_authController.currentUser.value?.name ?? ''} 👋',
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
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.diamond,
                    label: 'Total Items',
                    value: '${_ornamentController.totalItems.value}',
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 10),
                // Total Weight
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.monitor_weight,
                    label: 'Weight (g)',
                    value: _ornamentController.totalWeight.value
                        .toStringAsFixed(2),
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 10),
                // Total Price
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.currency_rupee,
                    label: 'Total Price',
                    value:
                        '₹${_ornamentController.totalPrice.value.toStringAsFixed(0)}',
                    color: Colors.orange,
                  ),
                ),
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

              if (_ornamentController.ornaments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey.shade400),
                      SizedBox(height: 10),
                      Text(
                        'Koi ornament nahi hai',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Add karne ke liye + button dabao',
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
                itemCount: _ornamentController.ornaments.length,
                itemBuilder: (context, index) {
                  OrnamentModel ornament = _ornamentController.ornaments[index];
                  return _buildOrnamentCard(ornament, context);
                },
              );
            }),
          ),
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
  Widget _buildOrnamentCard(OrnamentModel ornament, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade100,
          child: Icon(
            _getOrnamentIcon(ornament.ornamentType),
            color: Colors.amber.shade800,
          ),
        ),
        title: Text(
          ornament.personName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ornament.ornamentType),
            Text(
              '${ornament.weight}g × ₹${ornament.rate}/g',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${ornament.totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('dd MMM yyyy').format(DateTime.parse(ornament.date)),
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
        onLongPress: () => _showDeleteDialog(context, ornament),
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) => _showItemBottomSheet(ornament),
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

  Widget _showItemBottomSheet(OrnamentModel ornament) {
    return SingleChildScrollView(
      padding: .all(16),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(children: [
          commonRow("Name", ornament.personName),
          commonRow("Ornament Type", ornament.ornamentType),
          commonRow("Date", ornament.date),
          commonRow("Interest", "${ornament.interest}"),
          commonRow("Total Price", "${ornament.totalPrice}"),
          ]),
      ),
    );
  }
}
