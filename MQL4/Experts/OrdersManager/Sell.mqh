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
   bool              checkMask();
   Sell              *closeByStopLoss();
   Sell              *setStopLossPrice(double newStopLossPrice);
   Sell              *setTakeProfitPrice(double newTakeProfitPrice); 
   bool              isSyncWith(Order& lastFromHistory);
   bool              isAsyncWith(Order& lastFromHistory);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Sell::Sell(){
   this.Order();
   this.orderType = OP_SELL;
   }

Sell::Sell(Sell *sell){
   this = sell;
}

Sell::~Sell(){
   }
//+------------------------------------------------------------------+
Sell *Sell::open(){
   this.ticket = 0;
      
   this.takeProfitPrice = Bid - takeProfit*Point;
   this.stopLossPrice = Ask + stopLoss*Point;
   this.takePrifitPriceMin = takeProfitPrice;
   this.stopLossPriceMax = stopLossPrice;
   this.lots = round((this.weight * this.lots)/this.minLot) * this.minLot;
   if(lots == 0)
      lots = minLot;
   this.ticket = OrderSend(symbol, orderType, lots, Bid, slippage, stopLossPrice, takeProfitPrice, comment, magicNumber, expiration, openColor);
   
   return GetPointer(this);
}

Sell *Sell::setStopLossPrice(double newStopLossPrice){
   if(newStopLossPrice < this.stopLossPrice && newStopLossPrice > (Ask+MINIMUM_LOSS*Point)){
      this.withStopLossPrice(newStopLossPrice);
      if(!this.mask)
         this.modifyStopLoss(newStopLossPrice);
      else {
         this.withMaskDeltaStopLoss((int) randomNumberAroundZero(this.maskDeltaStopLoss));
         this.modifyStopLoss(newStopLossPrice + this.maskDeltaStopLoss * Point);
      }
   }
   return GetPointer(this);
}

Sell *Sell::setTakeProfitPrice(double newTakeProfitPrice){
   if(newTakeProfitPrice < this.takeProfitPrice && newTakeProfitPrice < this.takePrifitPriceMin){
      this.withTakeProfitPrice(newTakeProfitPrice);
      if(!this.mask)
         this.modifyTakeProfit(newTakeProfitPrice);
      else {
         this.withMaskDeltaTakeProfit((int) randomNumberAroundZero(this.maskDeltaTakeProfit));
         this.modifyTakeProfit(newTakeProfitPrice - this.maskDeltaTakeProfit * Point);
         
         
      }
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

bool  Sell::checkMask(void){
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES) && Bid <= this.takeProfitPrice)
      return close(Bid, clrGreenYellow);
   else if(Bid >= this.stopLossPrice)
      return close(Bid, clrRed);
   return false;   
}
