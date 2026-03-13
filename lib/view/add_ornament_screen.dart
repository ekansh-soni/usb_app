import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usb_app/utils/utils.dart';
import '../controller/ornament_controller.dart';

class AddOrnamentScreen extends StatelessWidget {
  final OrnamentController controller = Get.find<OrnamentController>();

  final TextEditingController _personController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

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
      appBar: AppBar(
        title: Text('Add Mortgage Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Icon
              Center(
                child: Icon(
                  Icons.add_circle,
                  size: 80,
                  color: Colors.amber,
                ),
              ),

              SizedBox(height: 20),

              Text("Borrower Details", style: TextStyle(fontSize: 24, fontWeight: .bold),),
              spaceHeight(15),
              // Person Name
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter mobile';
                  }
                  return null;
                },
              ),

              spaceHeight(15),

              Divider(),

              spaceHeight(15),

              Text("Mortgage Details", style: TextStyle(fontSize: 24, fontWeight: .bold),),

              spaceHeight(15),

              // Ornament Type Dropdown

              Obx(() => DropdownButtonFormField<String>(
                value: selectedType.value,
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
                  selectedType.value = value!;
                },
              )),


              Obx(() {
                if(selectedType.value == "Other"){
                  return Column(
                    children: [
                      spaceHeight(15),
                      TextFormField(
                        controller: controller.mortgageItem,
                        decoration: InputDecoration(
                          labelText: 'Enter Item',
                          prefixIcon: Icon(Icons.satellite_alt_sharp),
                          hintText: 'Enter Item',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter item';
                          }
                          return null;
                        },
                      ),
                      spaceHeight(15),
                    ],
                  );
                }
                return spaceHeight(10);
              },),
              // spaceHeight(15),



              // Weight
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (in gm)',
                  prefixIcon: Icon(Icons.monitor_weight),
                  hintText: '10.5',
                ),
                onChanged: (value) {
                  // ✅ Jab value change ho to observable update karo
                  weight.value = double.tryParse(value) ?? 0;
                },
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
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Rate (per gram)',
                  prefixIcon: Icon(Icons.currency_rupee),
                  hintText: '6500',
                ),
                onChanged: (value) {
                  // ✅ Jab value change ho to observable update karo
                  rate.value = double.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter rate';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid rate';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),


              // Interest
              TextFormField(
                controller: _interestController,
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

              // Notes (optional)
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.note),
                  hintText: 'Made with gold',
                ),
              ),

              SizedBox(height: 15),

              // ✅ Total Preview - Ab sahi kaam karega
              Obx(() {
                double total = weight.value * rate.value;

                return Card(
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹ ${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: 20),

              // Save Button
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.addOrnament(
                      personName: _personController.text.trim(),
                      ornamentType: selectedType.value,
                      weight: double.parse(_weightController.text),
                      rate: double.parse(_rateController.text),
                      notes: _notesController.text.isEmpty
                          ? null
                          : _notesController.text.trim(),
                      interest: double.parse(_interestController.text)
                    );
                  }
                },
                child: Text(
                  'Save Ornament',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}