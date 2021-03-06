//+------------------------------------------------------------------+
//|                                                    OrdersBox.mqh |
//|                                  Пархейчук Дмитрий Александрович |
//|                                                           pkt.by |
//+------------------------------------------------------------------+
#property copyright "Пархейчук Дмитрий Александрович"
#property link      "pkt.by"
#property version   "1.00"
#property strict

#include "Order.mqh"
#include "Buy.mqh"
#include "Sell.mqh"
#include "History.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class OrdersBox
  {
private:
   int   magicNumber;
   Order ordersBox[];
   Order historyBox[];
   Order actualBox[];
   History history;
public:
                     OrdersBox(int magicNumberIn);
   //template <typename T>
   OrdersBox         *addNew(Order *order);//Добавить элемент
   OrdersBox         *clear();
   OrdersBox         deleteWithTicket(int _ticket);//Удалить элемент
   int               size();
   Order             findByObject(Order *_order);
   double             getWeight(double lossesCountMax, double minProfitIn, double& allWeights[15]);
   Order             getLast(); //Вернуть последний элемент
   Order             getFirst();//Вернуть первый элемент
   Order             getByNumber(int number);//Вернуть элемент с номером
   Order             getByTicket(int ticket);//Найти элемент с тикетом
   //Order[]           GetByMagicNumber(int magic_number); //Найти все ордера с магическим номером                   
   bool              closeFirst();
   bool              closeLast();
   bool              closeByNumber(int number);
   bool              modifyFirst();
   bool              modifyLast();
   bool              modifyByNumber(int number);
   string            toString();
                    ~OrdersBox();
  };
//+------------------------------------------------------------------+
//|Add element to order box                                          |
//+------------------------------------------------------------------+
OrdersBox::OrdersBox(int magicNumberIn){
   this.magicNumber = magicNumberIn;
   this.history = new History(magicNumberIn);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrdersBox::~OrdersBox()
  {
  }
//+------------------------------------------------------------------+
//template <typename T>
OrdersBox *OrdersBox::addNew(Order *order){
   ArrayResize(ordersBox, ArraySize(ordersBox)+1);
   ordersBox[ArraySize(ordersBox)-1] = Order(order);
   return GetPointer(this);
}

OrdersBox *OrdersBox::clear(){
   ArrayFree(ordersBox);
   //ArrayResize(ordersBox, 0);
   return GetPointer(this);
}

int OrdersBox::size(){
   return ArraySize(ordersBox);
}

string OrdersBox::toString(){
   string orders;
   for(int i = 0; i < ArraySize(ordersBox); i++){
      orders += ordersBox[i].toString()+ IntegerToString(i + 1) + "\n";
   }
   
   return orders;
}

double OrdersBox::getWeight(double lossesCountMax, double minProfitIn, double& allWeights[15]){
      Order lastFromHistory = history.last();
      double currentWeight = 1;
      if(lastFromHistory.isLoss(minProfitIn)){
         currentWeight = 1;
      
         this.addNew(&lastFromHistory);
         for(int i = 0; i < this.size(); i++){
            currentWeight = currentWeight * allWeights[i];
         }
      }
      if(lastFromHistory.isProfit(minProfitIn) || this.size() > lossesCountMax){
         this.clear();
         currentWeight = 1;
      }
      return currentWeight;
}