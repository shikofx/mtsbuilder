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
   bool              checkMask(void);
   Buy               *setStopLossPrice(double newStopLoss);
   Buy               *setTakeProfitPrice(double newTakeProfit);
   bool              isSyncWith(Order& lastFromHistory);
   bool              isAsyncWith(Order& lastFromHistory);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Buy::Buy(){
   this.Order();
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
   this.takeProfitPrice = Ask + this.takeProfit*Point;
   this.stopLossPrice = Bid - this.stopLoss*Point;
   this.takePrifitPriceMin = this.takeProfitPrice;
   this.stopLossPriceMax = this.stopLossPrice;
   this.lots = round((this.weight * this.lots)/this.minLot) * this.minLot;
   if(this.lots == 0)
      this.lots = this.minLot;
   this.ticket = OrderSend(symbol, orderType, lots, Ask, slippage, stopLossPrice, takeProfitPrice, comment, magicNumber, expiration, openColor);
   return GetPointer(this);
   }
   
Buy *Buy::setStopLossPrice(double newStopLossPrice){
   if(newStopLossPrice > this.stopLossPrice && newStopLossPrice < (Bid-MINIMUM_LOSS*Point)){
      this.withStopLossPrice(newStopLossPrice);
      if(!this.mask)
         this.modifyStopLoss(newStopLossPrice);
      else {
         this.withMaskDeltaStopLoss((int) randomNumberAroundZero(this.maskDeltaStopLoss));
         this.modifyStopLoss(newStopLossPrice - this.maskDeltaStopLoss * Point);
      }
   }
   return GetPointer(this);
}

Buy *Buy::setTakeProfitPrice(double newTakeProfitPrice){
   if(newTakeProfitPrice > this.getOpenPrice() && newTakeProfitPrice > this.takePrifitPriceMin){
      this.withTakeProfitPrice(newTakeProfitPrice);
      if(!this.mask)
         this.modifyTakeProfit(newTakeProfitPrice);
      else {
         this.withMaskDeltaTakeProfit((int) randomNumberAroundZero(this.maskDeltaTakeProfit));
         this.modifyTakeProfit(newTakeProfitPrice + this.maskDeltaTakeProfit * Point);
      }
   } 
   return GetPointer(this);
}

//--- checkOrder - закрытие позиций на действующих стопах или профитах
//--- частичное закрытие и открытие позиций при попутном движении

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

bool  Buy::checkMask(void){
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES) && Ask >= this.takeProfitPrice)
      return this.close(Ask, clrGreenYellow);
   else if(Ask <= this.stopLossPrice)
      return this.close(Ask, clrRed);
   return false;   
}