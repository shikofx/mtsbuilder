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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//template <template T>

class OrdersBox
  {
private:
   Order ordersBox[];
public:
                     OrdersBox();
   
   void              Add(Order *order);//Добавить элемент
   void              Delete(int number);//Удалить элемент
   int               Find(Order *order_in);
   Order             GetLast(); //Вернуть последний элемент
   Order             GetFirst();//Вернуть первый элемент
   Order             GetByNumber(int number);//Вернуть элемент с номером
   Order             GetByTicket(int ticket);//Найти элемент с тикетом
   //Order[]           GetByMagicNumber(int magic_number); //Найти все ордера с магическим номером                   
   bool              CloseFirst();
   bool              CloseLast();
   bool              CloseByNumber(int number);
   bool              ModifyFirst();
   bool              ModifyLast();
   bool              ModifyByNumber(int number);
   
                    ~OrdersBox();
  };
//+------------------------------------------------------------------+
//|Add element to order box                                          |
//+------------------------------------------------------------------+
OrdersBox::OrdersBox()
  {
   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrdersBox::~OrdersBox()
  {
  }
//+------------------------------------------------------------------+
int OrdersBox::Find(Order *order_in){
   for(int i=0; i<ArraySize(ordersBox); i++){
      if(ordersBox[i].Equal(order_in))
         return i;
   }
   return -1;      
}

void OrdersBox::Add(Order *order){
   if(ArraySize(ordersBox)>0)
   if(Find(order)<0){
      ArrayResize(ordersBox, ArraySize(ordersBox)+1);
      ordersBox[ArraySize(ordersBox)-1] = order;
   }
}

void OrdersBox::Delete(int number){
}
/*Order OrdersBox::GetLast(){
   }
Order OrdersBox::GetFirst(){
   }
Order OrdersBox::GetByNumber(int number){
   }             
Order OrdersBox::GetByTicket(int ticket){
   }             
      
bool OrdersBox::CloseFirst(){
   }
bool OrdersBox::CloseLast(){
   }
bool OrdersBox::CloseByNumber(int number){
   }
bool OrdersBox::ModifyFirst(){
   }
bool OrdersBox::ModifyLast(){
   }
bool OrdersBox::ModifyByNumber(int number){
   }*/