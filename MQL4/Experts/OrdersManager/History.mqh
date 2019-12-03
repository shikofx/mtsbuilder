//+------------------------------------------------------------------+
//|                                                      History.mqh |
//|                                                        PKT Group |
//|                                               https://www.pkt.by |
//+------------------------------------------------------------------+
#property copyright "PKT Group"
#property link      "https://www.pkt.by"
#property version   "1.00"
#property strict

#include "Order.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class History
  {
private:
   int magicNumber;
   int size;
public:
                     History();
                     History(int magicNumberIn);
                    ~History();
  Order              last();
  bool               isChanged();
  bool               isEmpty();
  int                countWithMagicNumber();
  int                count();
  int                getSize();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
History::History(){
   this.size = OrdersHistoryTotal();
   }
   
History::History(int magicNumberIn){
   this.magicNumber = magicNumberIn;
   this.size = this.count();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
History::~History(){
  }
//+------------------------------------------------------------------+

Order History::last(){
    Order order = Order();
    if(OrdersHistoryTotal() > 0){
      for(int i = OrdersHistoryTotal()-1; i>=0; i--){
         if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderMagicNumber() == magicNumber) {
            order
               .withTicket(OrderTicket())
               .withOrderType(OrderType());
            return GetPointer(order);
         }
      }
   }
   return GetPointer(order);
}

bool History::isChanged(){
   if(this.count() > this.size) {
      this.size = this.count();
      return true;
   }   
   return false;
}

bool History::isEmpty(){
   if(this.getSize() == 0)
      return true;
   return false;
}

int History::getSize(void){
   return this.size = this.count();
}

int History::count(){
   int counter = 0;
   if(OrdersHistoryTotal() > 0){
      for(int i = OrdersHistoryTotal()-1; i>=0; i--){
         if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
            counter++;         
      }
   }
   return counter;
}

int History::countWithMagicNumber(){
   int counter = 0;
   if(OrdersHistoryTotal() > 0){
      for(int i = OrdersHistoryTotal()-1; i>=0; i--){
         if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderMagicNumber() == magicNumber)
            counter++;         
      }
   }
   return counter;
}



   
