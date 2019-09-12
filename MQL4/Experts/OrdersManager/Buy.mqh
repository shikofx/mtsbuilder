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
                     Buy(Buy *buy);
                    ~Buy();
   Buy               *open();
   Buy               *setStopLossPrice(double newStopLoss);
   Buy               *setTakeProfitPrice(double newTakeProfit);
   bool              isSyncWith(Order& lastFromHistory);
   bool              isAsyncWith(Order& lastFromHistory);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Buy::Buy(){
   this.orderType = OP_BUY;
   }
   
Buy::Buy(Buy *buy){
   this = buy;
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
   ticket = OrderSend(symbol, orderType, weight * lots, Ask, slippage, stopLossPrice, takeProfitPrice, comment, magicNumber, expiration, openColor);
   return GetPointer(this);
   }
   
Buy *Buy::setStopLossPrice(double newStopLossPrice){
   if(newStopLossPrice > this.stopLossPrice && newStopLossPrice < (Bid-MINIMUM_LOSS*Point)){
      this.modifyStopLoss(newStopLossPrice);
   }
   return GetPointer(this);
}

Buy *Buy::setTakeProfitPrice(double newTakeProfitPrice){
   if(newTakeProfitPrice > this.getOpenPrice()){
      this.modifyTakeProfit(newTakeProfitPrice);
   }
   return GetPointer(this);
}

bool Buy::isSyncWith(Order& lastFromHistory){
   return (OrdersHistoryTotal() == 0 && !this.isOpened())|| 
      (OrdersTotal() == 0 &&
           ((lastFromHistory.getType()==OP_BUY && lastFromHistory.isProfit(0)) ||
            (lastFromHistory.getType()==OP_SELL && lastFromHistory.isLoss(0))));
}

bool Buy::isAsyncWith(Order& lastFromHistory){
   return (OrdersHistoryTotal() == 0 && !this.isOpened())|| 
      (OrdersTotal() == 0 &&
           ((lastFromHistory.getType()==OP_BUY && lastFromHistory.isLoss(0)) ||
            (lastFromHistory.getType()==OP_SELL && lastFromHistory.isProfit(0))));
}