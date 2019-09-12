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
                     Sell(Sell *sell);
                    ~Sell();
   Sell              *open();
   Sell              *setStopLossPrice(double newStopLossPrice);
   Sell              *setTakeProfitPrice(double newTakeProfitPrice); 
   bool              isSyncWith(Order& lastFromHistory);
   bool              isAsyncWith(Order& lastFromHistory);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Sell::Sell(){
   this.orderType = OP_SELL;
   }

Sell::Sell(Sell *sell){
   this = sell;
}

Sell::~Sell(){
   }
//+------------------------------------------------------------------+
Sell *Sell::open(){
   this.takeProfitPrice = Bid - takeProfit*Point;
   this.stopLossPrice = Ask + stopLoss*Point;
   ticket = OrderSend(symbol, orderType, weight * lots, Bid, slippage, stopLossPrice, takeProfitPrice, comment, magicNumber, expiration, openColor);
   return GetPointer(this);
   }

Sell *Sell::setStopLossPrice(double newStopLossPrice){
   if(newStopLossPrice < this.stopLossPrice && newStopLossPrice > (Ask+MINIMUM_LOSS*Point)){
      this.modifyStopLoss(newStopLossPrice);
   }
   return GetPointer(this);
}

Sell *Sell::setTakeProfitPrice(double newTakeProfitPrice){
   if(newTakeProfitPrice < this.takeProfitPrice){
      this.modifyTakeProfit(newTakeProfitPrice);
   }
   return GetPointer(this);
}

bool Sell::isSyncWith(Order& lastFromHistory){
   return (OrdersHistoryTotal() == 0 && !this.isOpened())|| 
      (OrdersTotal() == 0 &&
           ((lastFromHistory.getType()==OP_SELL && lastFromHistory.isProfit(0)) ||
            (lastFromHistory.getType()==OP_BUY && lastFromHistory.isLoss(0))));
}

bool Sell::isAsyncWith(Order& lastFromHistory){
   return (OrdersHistoryTotal() == 0 && !this.isOpened())|| 
      (OrdersTotal() == 0 &&
           ((lastFromHistory.getType()==OP_SELL && lastFromHistory.isLoss(0)) ||
            (lastFromHistory.getType()==OP_BUY && lastFromHistory.isProfit(0))));
}