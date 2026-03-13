
class BorrowerDetailBean {
  BorrowerInfo? borrowerInfo;
  List<MortgageDetail>? mortgageDetail;
  LoanDetail? loanDetail;
  GuarantorDetail? guarantorDetail;
  MortgageBy? mortgageBy;
  int? borrowerId;

  BorrowerDetailBean({this.borrowerInfo, this.mortgageDetail, this.loanDetail, this.guarantorDetail, this.mortgageBy, this.borrowerId});

  BorrowerDetailBean.fromJson(Map<String, dynamic> json) {
    borrowerInfo = json["borrower_info"] == null ? null : BorrowerInfo.fromJson(json["borrower_info"]);
    mortgageDetail = json["mortgage_detail"] == null ? null : (json["mortgage_detail"] as List).map((e) => MortgageDetail.fromJson(e)).toList();
    loanDetail = json["loan_detail"] == null ? null : LoanDetail.fromJson(json["loan_detail"]);
    guarantorDetail = json["guarantor_detail"] == null ? null : GuarantorDetail.fromJson(json["guarantor_detail"]);
    mortgageBy = json["mortgage_by"] == null ? null : MortgageBy.fromJson(json["mortgage_by"]);
    borrowerId = json["borrower_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(borrowerInfo != null) {
      _data["borrower_info"] = borrowerInfo?.toJson();
    }
    if(mortgageDetail != null) {
      _data["mortgage_detail"] = mortgageDetail?.map((e) => e.toJson()).toList();
    }
    if(loanDetail != null) {
      _data["loan_detail"] = loanDetail?.toJson();
    }
    if(guarantorDetail != null) {
      _data["guarantor_detail"] = guarantorDetail?.toJson();
    }
    if(mortgageBy != null) {
      _data["mortgage_by"] = mortgageBy?.toJson();
    }
    _data["borrower_id"] = borrowerId;
    return _data;
  }
}

class MortgageBy {
  String? name;
  int? id;
  String? createdAt;

  MortgageBy({this.name, this.id, this.createdAt});

  MortgageBy.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["id"] = id;
    _data["created_at"] = createdAt;
    return _data;
  }
}

class GuarantorDetail {
  String? guarantorName;
  String? guarantorAddress;
  String? guarantorMobile;

  GuarantorDetail({this.guarantorName, this.guarantorAddress, this.guarantorMobile});

  GuarantorDetail.fromJson(Map<String, dynamic> json) {
    guarantorName = json["guarantor_name"];
    guarantorAddress = json["guarantor_address"];
    guarantorMobile = json["guarantor_mobile"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["guarantor_name"] = guarantorName;
    _data["guarantor_address"] = guarantorAddress;
    _data["guarantor_mobile"] = guarantorMobile;
    return _data;
  }
}

class LoanDetail {
  String? totalItemWeight;
  String? loanAmount;
  String? loanInterest;
  String? loanTenure;
  String? loanNote;

  LoanDetail({this.totalItemWeight, this.loanAmount, this.loanInterest, this.loanTenure, this.loanNote});

  LoanDetail.fromJson(Map<String, dynamic> json) {
    totalItemWeight = json["total_item_weight"];
    loanAmount = json["loan_amount"];
    loanInterest = json["loan_interest"];
    loanTenure = json["loan_tenure"];
    loanNote = json["loan_note"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["total_item_weight"] = totalItemWeight;
    _data["loan_amount"] = loanAmount;
    _data["loan_interest"] = loanInterest;
    _data["loan_tenure"] = loanTenure;
    _data["loan_note"] = loanNote;
    return _data;
  }
}

class MortgageDetail {
  String? ornamentType;
  String? ornamentName;
  String? ornamentQuantity;

  MortgageDetail({this.ornamentType, this.ornamentName, this.ornamentQuantity});

  MortgageDetail.fromJson(Map<String, dynamic> json) {
    ornamentType = json["ornament_type"];
    ornamentName = json["ornament_name"];
    ornamentQuantity = json["ornament_quantity"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["ornament_type"] = ornamentType;
    _data["ornament_name"] = ornamentName;
    _data["ornament_quantity"] = ornamentQuantity;
    return _data;
  }
}

class BorrowerInfo {
  String? borrowerName;
  String? borrowerAddress;
  String? borrowerMobile;

  BorrowerInfo({this.borrowerName, this.borrowerAddress, this.borrowerMobile});

  BorrowerInfo.fromJson(Map<String, dynamic> json) {
    borrowerName = json["borrower_name"];
    borrowerAddress = json["borrower_address"];
    borrowerMobile = json["borrower_mobile"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["borrower_name"] = borrowerName;
    _data["borrower_address"] = borrowerAddress;
    _data["borrower_mobile"] = borrowerMobile;
    return _data;
  }
}