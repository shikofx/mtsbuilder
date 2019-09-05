//+------------------------------------------------------------------+
//|                                                         Sell.mqh |
//|                                              Dzmitry Parkheichuk |
//|                                                           pkt.by |
//+------------------------------------------------------------------+
#property copyright "Dzmitry Parkheichuk"
#property link      "pkt.by"
#property version   "1.00"

#include "Order.mqh"   

#define sellType OP_SELL
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Sell : public Order
  {
private:
   datetime expiration;

public:
                     Sell();
                     
                    ~Sell();
   Sell              *open();
   Sell              *setStopPrice(double newStopLossPrice);
   Sell              *setTakePrice(double newTakeProfitPrice); 
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Sell::Sell(){
   }

Sell::~Sell(){
   }
//+------------------------------------------------------------------+
Sell *Sell::open(){
   this.takeProfitPrice = Bid - takeProfit*Point;
   this.stopLossPrice = Ask + stopLoss*Point;
   ticket = OrderSend(symbol, sellType, lots, Bid, slippage, stopLossPrice, takeProfitPrice, comment, magicNumber, expiration, openColor);
   return GetPointer(this);
   }

Sell *Sell::setStopPrice(double newStopLossPrice){
   if(newStopLossPrice < this.stopLossPrice && newStopLossPrice > (Ask+MINIMUM_LOSS*Point)){
      this.modifyStopLoss(newStopLossPrice);
   }
   return GetPointer(this);
}

Sell *Sell::setTakePrice(double newTakeProfitPrice){
   if(newTakeProfitPrice > this.takeProfitPrice){
      this.modifyTakeProfit(newTakeProfitPrice);
   }
   return GetPointer(this);
}

