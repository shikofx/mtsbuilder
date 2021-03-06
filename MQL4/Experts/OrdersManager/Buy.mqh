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
   
public:
                     Buy();
                     Buy(bool logg);
                     Buy(Buy *buy);
                    ~Buy();
   Buy               *open(double openPrice);
   bool              checkMask(void);
   Buy               *setBasicPricesBy(double openPrice);
   Buy               *setBasicPricesByCurrent();
   Buy               *setStopLossPrice(double newStopLoss);
   Buy               *setTakeProfitPrice(double newTakeProfit);
   Buy               *setTakeProfitPriceMin(double openPrice);
   Buy               *setStopLossPriceMax(double openPrice);
   Buy               *setMaskPricesByBasics();
   Buy               *withTakeProfitMaskPrice(double newTakeProfitPrice);
   Buy               *withStopLossMaskPrice(double newStopLossPrice);
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
   
Buy::Buy(bool logg){
   this.Order();
   this.orderType = OP_BUY;
   this.logging = logg;
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
  
Buy *Buy::open(double basePrice){
   this.setBasicPricesBy(basePrice);
   
   this.setLots();
   
   this.openBy(Ask);
      
   return GetPointer(this);
}

Buy *Buy::setBasicPricesBy(double openPrice){
   if(openPrice <= 0){
      this.takeProfitPrice = Ask + this.takeProfit*Point;
      this.stopLossPrice = Bid - this.stopLoss*Point;
   } else {
      this.takeProfitPrice = openPrice + this.takeProfit*Point;
      this.stopLossPrice = openPrice - MarketInfo(Symbol(), MODE_SPREAD)*Point - this.stopLoss*Point;
   }
   if(this.mask){
      this.setMaskPricesByBasics();
   }
   return GetPointer(this);
}


Buy *Buy::setBasicPricesByCurrent(){
   if(this.mask){
      this.takeProfitMaskPrice = this.getNativeTakeProfitPrice();
      this.stopLossMaskPrice = this.getNativeStopLossPrice();
      this.takeProfitPrice = this.getOpenPrice() + this.takeProfit*Point;
      this.stopLossPrice = this.getOpenPrice() - MarketInfo(Symbol(), MODE_SPREAD)*Point - this.stopLoss*Point;   
   } else {
      this.takeProfitPrice = this.getNativeTakeProfitPrice();
      this.stopLossPrice = this.getNativeStopLossPrice();   
   }   
   return GetPointer(this);   
}

Buy *Buy::setMaskPricesByBasics(){
   this.withTakeProfitMaskPrice(this.takeProfitPrice);
   this.withStopLossMaskPrice(this.stopLossPrice);
   return GetPointer(this);
}

Buy *Buy::setStopLossPrice(double newStopLossPrice){
   if(newStopLossPrice < (Bid-MINIMUM_LOSS*Point) ){
      if(this.mask && newStopLossPrice > this.stopLossMaskPrice){
         this.withStopLossMaskPrice(newStopLossPrice);
      }
      if(newStopLossPrice > this.stopLossPrice){
         this.modifyStopLoss(newStopLossPrice);
      }
   }
   return GetPointer(this);
}

Buy *Buy::setTakeProfitPrice(double newTakeProfitPrice){
   if(newTakeProfitPrice > this.takeProfitPriceMin){
      if(this.mask && newTakeProfitPrice > this.takeProfitMaskPrice){
         this.withTakeProfitMaskPrice(newTakeProfitPrice);
      }
      
      if(newTakeProfitPrice > this.getOpenPrice() && newTakeProfitPrice > this.takeProfitPriceMin){
         this.modifyTakeProfit(newTakeProfitPrice);
      }
   
   }
    
   return GetPointer(this);
}

//--- checkOrder - закрытие позиций на действующих стопах или профитах
//--- частичное закрытие и открытие позиций при попутном движении

bool Buy::isSyncWith(Order& lastFromHistory){
   if(lastFromHistory.getType()==OP_BUY && lastFromHistory.isProfit(0))
      return true;
   if(lastFromHistory.getType()==OP_SELL && lastFromHistory.isLoss(0))
      return true;
   return false;
}

bool Buy::isAsyncWith(Order& lastFromHistory){
   if(lastFromHistory.getType()==OP_BUY && lastFromHistory.isLoss(0)) 
      return true;
   if(lastFromHistory.getType()==OP_SELL && lastFromHistory.isProfit(0))
      return true;
   return false;
}

bool  Buy::checkMask(void){
   if(this.mask && this.ticket > 0 && OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES)){
      if(Bid >= this.takeProfitPrice){
         return this.close(Ask, clrGreenYellow);
      } else if(Bid <= this.stopLossPrice) {
         return this.close(Ask, clrRed);
      }
   }
   return false;   
}

Buy   *Buy::withStopLossMaskPrice(double newStopLossPrice){
   double deviation = (this.stopLossMaskDeviation + randInt(this.maskSlippage)) * Point;
   double newStopLossMaskPrice = newStopLossPrice - deviation;   
   if(this.stopLossMaskPrice == 0 || (newStopLossMaskPrice > 0 && this.stopLossMaskPrice < newStopLossMaskPrice)) {
      this.stopLossMaskPrice = newStopLossMaskPrice;   
   }
   return GetPointer(this);
}

Buy   *Buy::withTakeProfitMaskPrice(double newTakeProfitPrice){   
   double deviation = (this.takeProfitMaskDeviation + randInt(this.maskSlippage)) * Point;
   double newTakeProfitMaskPrice = newTakeProfitPrice + deviation;
   if(this.takeProfitMaskPrice == 0 || (newTakeProfitPrice > 0 && this.takeProfitMaskPrice < newTakeProfitMaskPrice)){
      this.takeProfitMaskPrice = newTakeProfitMaskPrice;
   }
   
   return GetPointer(this);      
}

Buy *Buy::setTakeProfitPriceMin(double openPrice){
   this.takeProfitPrice = openPrice + this.takeProfit*Point;
   this.takeProfitPriceMin = this.takeProfitPrice;
   this.modifyTakeProfit(this.takeProfitPrice);    
   return GetPointer(this);
}

Buy *Buy::setStopLossPriceMax(double openPrice){
   this.stopLossPrice = openPrice - MarketInfo(Symbol(), MODE_SPREAD)*Point - this.stopLoss*Point;
   this.stopLossPriceMax = this.stopLossPrice;
   this.modifyStopLoss(this.stopLossPrice);    
   return GetPointer(this);
}
