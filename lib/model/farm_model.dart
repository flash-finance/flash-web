
class FarmRows {
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
  String apy;
  String balanceAmount;
  String depositedAmount;
  String harvestedAmount;

  double depositTotalSupply;
  double produceAmount;
  double depositTokenPrice;
  double mineTokenPrice;

  String depositLpToken;
  String mineLpToken;

  FarmRows({
    this.id,
    this.poolType,
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
    this.poolAddress,
    this.apy,
    this.balanceAmount,
    this.depositedAmount,
    this.harvestedAmount,
    this.depositTotalSupply,
    this.produceAmount,
    this.depositTokenPrice,
    this.mineTokenPrice,
    this.depositLpToken,
    this.mineLpToken
  });
}
