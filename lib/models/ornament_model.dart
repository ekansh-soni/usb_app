class OrnamentModel {
  int? id;
  int userId;
  String personName;
  String ornamentType; // Chain, Ring, Earring, etc.
  double weight; // in grams
  double rate; // per gram rate
  double totalPrice;
  String date;
  double interest;
  String? notes;

  OrnamentModel({
    this.id,
    required this.userId,
    required this.personName,
    required this.ornamentType,
    required this.weight,
    required this.rate,
    required this.totalPrice,
    required this.date,
    required this.interest,
    this.notes,
  });

  // Calculate total price
  double calculateTotal() {
    return weight * rate;
  }

  // JSON to Object
  factory OrnamentModel.fromMap(Map<String, dynamic> map) {
    return OrnamentModel(
      id: map['id'],
      userId: map['user_id'],
      personName: map['person_name'],
      ornamentType: map['ornament_type'],
      weight: map['weight'],
      rate: map['rate'],
      totalPrice: map['total_price'],
      date: map['date'],
      notes: map['notes'],
      interest: map['interest']
    );
  }

  // Object to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'person_name': personName,
      'ornament_type': ornamentType,
      'weight': weight,
      'rate': rate,
      'total_price': totalPrice,
      'date': date,
      'notes': notes,
      'interest': interest,
    };
  }
}