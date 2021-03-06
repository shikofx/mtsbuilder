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
   this.takeProfitPriceMin = this.takeProfitPrice;
   this.stopLossPriceMax = this.stopLossPrice;
   
   if(this.mask){
      this.withTakeProfitMaskPrice(this.takeProfitPrice);
      this.withStopLossMaskPrice(this.stopLossPrice);
   }
   
   this.lots = round((this.weight * this.lots)/this.minLot) * this.minLot;
   if(this.lots == 0)
      this.lots = this.minLot;
   
   
   if(!this.mask)
      this.ticket = OrderSend(this.symbol, orderType, lots, Ask, slippage, stopLossPrice, takeProfitPrice, comment, magicNumber, expiration, openColor);
   else
      this.ticket = OrderSend(this.symbol, orderType, lots, Ask, slippage, stopLossMaskPrice, takeProfitMaskPrice, comment, magicNumber, expiration, openColor);
      
   return GetPointer(this);
   }
   
Buy *Buy::setStopLossPrice(double newStopLossPrice){
   if(newStopLossPrice < (Bid-MINIMUM_LOSS*Point)){
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
   if(this.stopLossMaskPrice == 0 || (newStopLossMaskPrice > 0 && this.stopLossMaskPrice < newStopLossMaskPrice))   
      this.stopLossMaskPrice = newStopLossMaskPrice;   
   return GetPointer(this);
}

Buy   *Buy::withTakeProfitMaskPrice(double newTakeProfitPrice){   
   double deviation = (this.takeProfitMaskDeviation + randInt(this.maskSlippage)) * Point;
   double newTakeProfitMaskPrice = newTakeProfitPrice + deviation;
   if(this.takeProfitMaskPrice == 0 || (newTakeProfitPrice > 0 && this.takeProfitMaskPrice < newTakeProfitMaskPrice))
      this.takeProfitMaskPrice = newTakeProfitMaskPrice;
   
   return GetPointer(this);      
}
