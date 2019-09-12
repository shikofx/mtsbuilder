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
   int count;
public:
                     History();
                    ~History();
  Order              last();
  bool               isChanged();
  bool               isEmpty();
  int                size();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
History::History(){
  count = OrdersHistoryTotal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
History::~History(){
  }
//+------------------------------------------------------------------+

Order History::last(){
    Order order = Order();
    if(OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS, MODE_HISTORY)){
         order
            .withTicket(OrderTicket())
            .withOrderType(OrderType());
    }
    return GetPointer(order);
}

bool History::isChanged(){
   if(OrdersHistoryTotal() > count) {
      count = OrdersHistoryTotal();
      return true;
   }   
   return false;
}

bool History::isEmpty(){
   if(OrdersHistoryTotal() > 0)
      return true;
   return false;
}

int History::size(){
   count = OrdersHistoryTotal();
   return count;
}

