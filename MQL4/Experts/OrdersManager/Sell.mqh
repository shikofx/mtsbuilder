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
   

public:
                     Sell();
                     Sell(bool logg);
                     Sell(Sell *sell);
                    ~Sell();
   Sell              *open(double basePrice);
   bool              checkMask();
   Sell              *setBasicPricesBy(double openPrice);
   Sell              *setBasicPricesByCurrent();
   Sell              *closeByStopLoss();
   Sell              *setStopLossPrice(double newStopLossPrice);
   Sell              *setTakeProfitPrice(double newTakeProfitPrice); 
   Sell              *setTakeProfitPriceMin(double openPrice);
   Sell              *setStopLossPriceMax(double openPrice);
   Sell              *setMaskPricesByBasics();
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

Sell::Sell(bool logg){
   this.Order();
   this.orderType = OP_SELL;
   
   this.logging = logg;
   
}

Sell::Sell(Sell *sell){
   this = sell;
}

Sell::~Sell(){
   }
//+------------------------------------------------------------------+
Sell *Sell::open(double basePrice){
   this.setBasicPricesBy(basePrice);
   
   this.setLots();
   
   this.openBy(Bid);
  
   return GetPointer(this);
}

Sell *Sell::setBasicPricesBy(double openPrice){
   if(openPrice <=0){
      this.takeProfitPrice = Bid - takeProfit*Point;
      this.stopLossPrice = Ask + stopLoss*Point;
   } else {
      this.takeProfitPrice = openPrice - takeProfit * Point;
      this.stopLossPrice = openPrice + MarketInfo(Symbol(), MODE_SPREAD)*Point + this.stopLoss*Point;
   }
   if(this.mask){
      this.setMaskPricesByBasics();
   }
   return GetPointer(this);
}

Sell *Sell::setBasicPricesByCurrent(){
   if(this.mask){
      this.takeProfitMaskPrice = this.getNativeTakeProfitPrice();
      this.stopLossMaskPrice = this.getNativeStopLossPrice();
      this.takeProfitPrice = this.getOpenPrice() - takeProfit * Point;
      this.stopLossPrice = this.getOpenPrice() + MarketInfo(Symbol(), MODE_SPREAD)*Point + stopLoss*Point;   
   } else {
      this.takeProfitPrice = this.getNativeTakeProfitPrice();
      this.stopLossPrice = this.getNativeStopLossPrice();   
   }
   return GetPointer(this);   
}

Sell *Sell::setMaskPricesByBasics(){
   this.withTakeProfitMaskPrice(this.takeProfitPrice);
   this.withStopLossMaskPrice(this.stopLossPrice);
   return GetPointer(this);
}

Sell *Sell::setStopLossPrice(double newStopLossPrice){
   if(newStopLossPrice > (Ask+MINIMUM_LOSS*Point)){
      if(this.mask && newStopLossPrice < this.stopLossMaskPrice){
         this.withStopLossMaskPrice(newStopLossPrice);
         
      } 
      
      if(newStopLossPrice < this.stopLossPrice){
         this.modifyStopLoss(newStopLossPrice);
      }
      
   }
   return GetPointer(this);
}

Sell *Sell::setTakeProfitPrice(double newTakeProfitPrice){
   if(newTakeProfitPrice < this.takeProfitPriceMin){
      if(this.mask && newTakeProfitPrice < this.takeProfitMaskPrice){
         this.withTakeProfitMaskPrice(newTakeProfitPrice);
      }
      
      if(newTakeProfitPrice < this.takeProfitPrice){
         this.modifyTakeProfit(newTakeProfitPrice);
      }
   
   }
   return GetPointer(this);
}

bool Sell::isSyncWith(Order& lastFromHistory){
   if(lastFromHistory.getType()==OP_SELL && lastFromHistory.isProfit(0))
      return true;
   if(lastFromHistory.getType()==OP_BUY && lastFromHistory.isLoss(0))
      return true;
   return false;
}  

bool Sell::isAsyncWith(Order& lastFromHistory){
   if(lastFromHistory.getType()==OP_SELL && lastFromHistory.isLoss(0)) 
      return true;
   if(lastFromHistory.getType()==OP_BUY && lastFromHistory.isProfit(0))
      return true;
   return false;
}

bool  Sell::checkMask(void){
   if(this.mask && this.ticket > 0 && OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES)) {
      if(Ask <= this.takeProfitPrice){
         return close(Bid, clrGreenYellow);
      } else if(Ask >= this.stopLossPrice){
         return close(Bid, clrRed);
      }
   }
   
   return false;   
}

Sell   *Sell::withStopLossMaskPrice(double newStopLossPrice){
   double deviation = (this.stopLossMaskDeviation + randInt(this.maskSlippage)) * Point;
   double newStopLossMaskPrice = newStopLossPrice + deviation;
   if(this.stopLossMaskPrice == 0 || (newStopLossMaskPrice > 0 && this.stopLossMaskPrice > newStopLossMaskPrice)){
      this.stopLossMaskPrice = NormalizeDouble(newStopLossMaskPrice, Digits);      
   }
   return GetPointer(this);
}

Sell   *Sell::withTakeProfitMaskPrice(double newTakeProfitPrice){  
   double deviation = (this.takeProfitMaskDeviation + randInt(this.maskSlippage)) * Point;
   double newTakeProfitMaskPrice = newTakeProfitPrice - deviation;
   if(this.takeProfitMaskPrice == 0 || (newTakeProfitPrice > 0 && this.takeProfitMaskPrice > newTakeProfitMaskPrice)){
      this.takeProfitMaskPrice = newTakeProfitMaskPrice;
   }
   return GetPointer(this);      
}
 
 
Sell *Sell::setTakeProfitPriceMin(double openPrice){
   this.takeProfitPrice = openPrice - this.takeProfit*Point;
   this.takeProfitPriceMin = this.takeProfitPrice;
   this.modifyTakeProfit(this.takeProfitPrice);    
   return GetPointer(this);
}

Sell *Sell::setStopLossPriceMax(double openPrice){
   this.stopLossPrice = openPrice + MarketInfo(Symbol(), MODE_SPREAD)*Point + this.stopLoss*Point;
   this.stopLossPriceMax = this.stopLossPrice;
   this.modifyStopLoss(this.stopLossPrice);    
   return GetPointer(this);
}
