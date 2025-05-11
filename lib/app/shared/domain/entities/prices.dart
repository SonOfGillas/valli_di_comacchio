class Prices {
  Prices({
    required this.buingStartingPrice,
    required this.buingPriceMin,
    required this.sellingPriceMax,
    required this.sellingStartingPrice,
  });

  final int buingPriceMax = double.maxFinite.toInt();
  /*
  * the price to buy the NPC resources at
  * the beginning of the trading process
  */
  final int buingStartingPrice;
  /*
  * the minimum price that the NPC is willing to accept 
  * for the resource that the user wants to buy
  */
  final int buingPriceMin;

  /*
  * the maximum price of the resource that the NPC is willing to pay 
  * for the resource that the user is selling
  */
  final int sellingPriceMax;
  /*
  * the price that the NPC offer for buing the resource 
  * at the beginning of the trading process
  */
  final int sellingStartingPrice;
  final int sellingPriceMin = 0;
}
