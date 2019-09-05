//+------------------------------------------------------------------+
//|                                                          Buy.mqh |
//|                                              Dzmitry Parkheichuk |
//|                                                           pkt.by |
//+------------------------------------------------------------------+
#property copyright "Dzmitry Parkheichuk"
#property link      "pkt.by"
#property version   "1.00"


#include "Order.mqh"

#define buyType OP_BUY

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Buy : public Order
  {
private:
   datetime expiration;
public:
                     Buy();
                    ~Buy();
   Buy               *open();
   Buy               *setStopPrice(double newStopLoss);
   Buy               *setTakePrice(double newTakeProfit);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Buy::Buy(){
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Buy::~Buy(){
  
  }
//+------------------------------------------------------------------+
  
Buy *Buy::open(){
   this.takeProfitPrice = Ask + takeProfit*Point;
   this.stopLossPrice = Bid - stopLoss*Point;
   ticket = OrderSend(symbol, buyType, lots, Ask, slippage, stopLossPrice, takeProfitPrice, comment, magicNumber, expiration, openColor);
   return GetPointer(this);
   }
   
Buy *Buy::setStopPrice(double newStopLossPrice){
   if(newStopLossPrice > this.stopLossPrice && newStopLossPrice < (Bid-MINIMUM_LOSS*Point)){
      this.modifyStopLoss(newStopLossPrice);
   }
   return GetPointer(this);
}

Buy *Buy::setTakePrice(double newTakeProfitPrice){
   if(newTakeProfitPrice > this.getOpenPrice()){
      this.modifyTakeProfit(newTakeProfitPrice);
   }
   return GetPointer(this);
}