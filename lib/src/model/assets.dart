class Assets {
  String code;
  String name;
  String address;
  String symbol;
  double blance;
  double freezingBlance;
  double cnyPrice;
  double usdPrice;
  Assets(
      {this.code,
      this.name,
      this.address,
      this.symbol,
      this.blance,
      this.freezingBlance,
      this.cnyPrice,
      this.usdPrice});
}

List<Assets> getAssets() {
  List<Assets> assets = new List();
  assets.add(Assets(
      code: "MedicalHealthCoin",
      name: "健康医疗币",
      symbol: "MHC",
      address: "0x9d6d492bD500DA5B33cf95A5d610a73360FcaAa0",
      blance: 20000,
      freezingBlance: 200,
      cnyPrice: 6.85));
  assets.add(Assets(
      code: "USTD",
      name: "泰达币",
      symbol: "USDT",
      blance: 20000,
      address: "0x9d6d492bD500DA5B33cf95A5d610a73360FcaAa0",
      freezingBlance: 0,
      cnyPrice: 6.85));
  // assets.add(Assets(
  //     code: "Ethereum",
  //     name: "以太坊",
  //     symbol: "ETH",
  //     blance: 20000,
  //     freezingBlance: 0,
  //     cnyPrice: 6.85));
  return assets;
}

Future<List<Assets>> getExchange(String mainSymbol, exchangeSymbol) async {
  List<Assets> assets = new List();

  await Future.delayed(Duration(seconds: 3));
  assets.add(Assets(
      code: "MedicalHealthCoin",
      name: "健康医疗币",
      symbol: "HMC",
      address: "0x9d6d492bD500DA5B33cf95A5d610a73360FcaAa0",
      blance: 20000,
      freezingBlance: 200,
      cnyPrice: 1.0));
  assets.add(Assets(
      code: "USTD",
      name: "泰达币",
      symbol: "USDT",
      blance: 20000,
      address: "0x9d6d492bD500DA5B33cf95A5d610a73360FcaAa0",
      freezingBlance: 0,
      cnyPrice: 6.85));

  return assets;
}
