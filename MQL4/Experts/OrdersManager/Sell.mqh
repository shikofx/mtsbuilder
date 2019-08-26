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
   bool              setStopPrice(double newStopLossPrice);
   bool              setTakePrice(double newTakeProfitPrice);

   
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

bool Sell::setStopPrice(double newStopLossPrice){
   bool modified = false;
   if(newStopLossPrice < stopLossPrice && 
      newStopLossPrice > (Ask+MINIMUM_LOSS*Point)){
      this.modifyStopLoss(newStopLossPrice);
   }
   return(modified);
}

bool Sell::setTakePrice(double newTakeProfitPrice){
   bool modified = false;
   //if(newTakeProfit > takeProfitPrice){
      //this.ModifyTakeProfit(newTakeProfit);
   //}
   return(modified);
}

