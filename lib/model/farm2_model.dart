
class FarmRespModel {
  int code;
  String msg;
  Farm2Data data;

  FarmRespModel({this.code, this.msg, this.data});

  FarmRespModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Farm2Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Farm2Data {
  int total;
  List<FarmRow> rows;

  Farm2Data({this.total, this.rows});

  Farm2Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = new List<FarmRow>();
      json['rows'].forEach((v) {
        rows.add(new FarmRow.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FarmRow {
  int id;
  int poolType;
  String poolAddress;
  String depositTokenName;
  int depositTokenType;
  String depositTokenAddress;
  int depositTokenDecimal;
  String mineTokenName;
  int mineTokenType;
  String mineTokenAddress;
  int mineTokenDecimal;
  String pic1;
  String pic2;
  double depositTotalSupply;
  double mineProduceAmount;
  double depositTokenPrice;
  double mineTokenPrice;
  double apy;
  String depositLpToken;
  String mineLpToken;
  double depositTokenValue;
  int endTime;
  int status;


  String balanceAmount;
  String depositedAmount;
  String harvestedAmount;

  FarmRow(
      {this.id,
        this.poolType,
        this.poolAddress,
        this.depositTokenName,
        this.depositTokenType,
        this.depositTokenAddress,
        this.depositTokenDecimal,
        this.mineTokenName,
        this.mineTokenType,
        this.mineTokenAddress,
        this.mineTokenDecimal,
        this.pic1,
        this.pic2,
        this.depositTotalSupply,
        this.mineProduceAmount,
        this.depositTokenPrice,
        this.mineTokenPrice,
        this.apy,
        this.depositLpToken,
        this.mineLpToken,
        this.depositTokenValue,
        this.endTime,
        this.status});

  FarmRow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    poolType = json['poolType'];
    poolAddress = json['poolAddress'];
    depositTokenName = json['depositTokenName'];
    depositTokenType = json['depositTokenType'];
    depositTokenAddress = json['depositTokenAddress'];
    depositTokenDecimal = json['depositTokenDecimal'];
    mineTokenName = json['mineTokenName'];
    mineTokenType = json['mineTokenType'];
    mineTokenAddress = json['mineTokenAddress'];
    mineTokenDecimal = json['mineTokenDecimal'];
    pic1 = json['pic1'];
    pic2 = json['pic2'];
    depositTotalSupply = (json['depositTotalSupply'] as num)?.toDouble();
    mineProduceAmount = (json['mineProduceAmount'] as num)?.toDouble();
    depositTokenPrice = (json['depositTokenPrice'] as num)?.toDouble();
    mineTokenPrice = (json['mineTokenPrice'] as num)?.toDouble();
    apy = (json['apy'] as num)?.toDouble();
    depositLpToken = json['depositLpToken'];
    mineLpToken = json['mineLpToken'];
    depositTokenValue = (json['depositTokenValue'] as num)?.toDouble();
    endTime = json['endTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['poolType'] = this.poolType;
    data['poolAddress'] = this.poolAddress;
    data['depositTokenName'] = this.depositTokenName;
    data['depositTokenType'] = this.depositTokenType;
    data['depositTokenAddress'] = this.depositTokenAddress;
    data['depositTokenDecimal'] = this.depositTokenDecimal;
    data['mineTokenName'] = this.mineTokenName;
    data['mineTokenType'] = this.mineTokenType;
    data['mineTokenAddress'] = this.mineTokenAddress;
    data['mineTokenDecimal'] = this.mineTokenDecimal;
    data['pic1'] = this.pic1;
    data['pic2'] = this.pic2;
    data['depositTotalSupply'] = this.depositTotalSupply;
    data['mineProduceAmount'] = this.mineProduceAmount;
    data['depositTokenPrice'] = this.depositTokenPrice;
    data['mineTokenPrice'] = this.mineTokenPrice;
    data['apy'] = this.apy;
    data['depositLpToken'] = this.depositLpToken;
    data['mineLpToken'] = this.mineLpToken;
    data['depositTokenValue'] = this.depositTokenValue;
    data['endTime'] = this.endTime;
    data['status'] = this.status;
    return data;
  }
}


class FarmTokenAmount {
  String balanceAmount;
  String depositedAmount;
  String harvestedAmount;

  FarmTokenAmount({
    this.balanceAmount,
    this.depositedAmount,
    this.harvestedAmount,
  });
}

