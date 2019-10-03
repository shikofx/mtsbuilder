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
   Sell              *withTakeProfitMaskPrice(double newTakeProfitPrice);
   Sell              *withStopLossMaskPrice(double newStopLossPrice);

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
   
   
   if(this.mask){
      this.takeProfitPrice = Bid - takeProfit*Point + randInt(this.closeSlippage) * Point;
      this.stopLossPrice = Ask + stopLoss*Point + randInt(this.closeSlippage) * Point;
   } else {
      this.takeProfitPrice = Bid - takeProfit*Point;
      this.stopLossPrice = Ask + stopLoss*Point;
   }
   this.takeProfitPriceMin = takeProfitPrice;
   this.stopLossPriceMax = stopLossPrice;
   
   if(this.mask){
      this.withTakeProfitMaskPrice(this.takeProfitPrice);
      this.withStopLossMaskPrice(this.stopLossPrice);
   }
   
   this.lots = round((this.weight * this.lots)/this.minLot) * this.minLot;
   if(lots == 0)
      lots = minLot;
  
   if(!this.mask)
      this.ticket = OrderSend(symbol, orderType, lots, Bid, slippage, stopLossPrice, takeProfitPrice, comment, magicNumber, expiration, openColor);
   else
      this.ticket = OrderSend(symbol, orderType, lots, Bid, slippage, stopLossMaskPrice, takeProfitMaskPrice, comment, magicNumber, expiration, openColor);
   
   return GetPointer(this);
}

Sell *Sell::setStopLossPrice(double newStopLossPrice){
   if(newStopLossPrice < this.stopLossPrice && newStopLossPrice > (Ask+MINIMUM_LOSS*Point)){
      this.modifyStopLoss(newStopLossPrice);
   }
   return GetPointer(this);
}

Sell *Sell::setTakeProfitPrice(double newTakeProfitPrice){
   if(newTakeProfitPrice < this.takeProfitPrice && newTakeProfitPrice < this.takeProfitPriceMin){
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

bool  Sell::checkMask(void){
   if(this.ticket > 0 && OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES)) {
      if(Ask <= this.takeProfitPrice)
         return close(Ask, clrGreenYellow);
      else if(Ask >= this.stopLossPrice)
         return close(Ask, clrRed);
   }
   return false;   
}

Sell   *Sell::withStopLossMaskPrice(double newStopLossPrice){
   double deviation = (this.stopLossMaskDeviation + randInt(this.maskSlippage)) * Point;
   double newStopLossMaskPrice = newStopLossPrice + deviation;
   if(this.stopLossMaskPrice == 0 || (newStopLossMaskPrice > 0 && this.stopLossMaskPrice > newStopLossMaskPrice))
      this.stopLossMaskPrice = newStopLossMaskPrice;      
   return GetPointer(this);
}

Sell   *Sell::withTakeProfitMaskPrice(double newTakeProfitPrice){  
   double deviation = (this.takeProfitMaskDeviation + randInt(this.maskSlippage)) * Point;
   double newTakeProfitMaskPrice = newTakeProfitPrice - deviation;
   if(this.takeProfitMaskPrice == 0 || (newTakeProfitPrice > 0 && this.takeProfitMaskPrice > newTakeProfitMaskPrice))
      this.takeProfitMaskPrice = newTakeProfitMaskPrice;
   return GetPointer(this);      
}
 