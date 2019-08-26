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
   bool              setStopPrice(double newStopLoss);
   bool              setTakePrice(double newTakeProfit);
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
   
bool Buy::setStopPrice(double newStopLossPrice){
   if(newStopLossPrice > stopLossPrice && newStopLossPrice < (Bid-MINIMUM_LOSS*Point)){
      return this.modifyStopLoss(newStopLossPrice);
   }
   return false;
}

bool Buy::setTakePrice(double newTakeProfitPrice){
   if(newTakeProfitPrice < takeProfitPrice){
      return this.modifyTakeProfit(newTakeProfitPrice);
   }
   return false;
}