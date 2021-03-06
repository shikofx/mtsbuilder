//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                              Dzmitry Parkheichuk |
//|                                                           pkt.by |
//+------------------------------------------------------------------+
#property copyright "Dzmitry Parkheichuk"
#property link      "pkt.by"
#property version   "1.00"
#property strict

#define MINIMUM_LOSS 200

#include "../lib/math.mqh"
#include "../lib/enums.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Order
  {
protected:
   bool              mask;
   int               maskSlippage; //Отклонение в пределах в пределах которого будут выбираться рандомные значения для маскировочных позиций
   int               closeSlippage;  //Отклонение в пределах которого будут выбираться рандомные значения для закрытия по TP и SL 1700 +- 50
   int               orderType;
   int               ticket;        //индивидуальный номер сделки на сервере
   int               magicNumber;   //индивидуальный номер 
   string            symbol;        // символ 
   double            lots;          // количество лотов 
   double            minLot;
   double            weight;
   double            priceToOpen;         // цена к открытию
   int               slippage;
   datetime          timeToOpen;    // когда открыть сделку
   double            priceToClose; //Цена к закрытию
   datetime          timeToClose;   // когда закрыть сделку   int               slippage;      // проскальзывание 
   datetime          expiration;
   double            takeProfitPrice; //take profit
   double            takeProfitMaskPrice; //take profit
   int               takeProfitMaskDeviation;
   double            takeProfitPriceMin;
   int               takeProfit; //take profit
   
   double            stopLossPrice;     
   double            stopLossMaskPrice;
   int               stopLossMaskDeviation;
   double            stopLossPriceMax;
   int               stopLoss; //stop loss
   
   double            weightOrder;   // вес сделки в порции
   string            comment;       // комментарий 
   color             openColor;
   color             modifyColor;
   bool              logging;
public:
                     Order();
                     Order(bool logging);
                     Order(Order& order);
                    
                    ~Order(){};
   bool              equal(Order *order);
   int               ordersCount();
   Order             *withMask(bool maskIn)                    { this.mask = maskIn;                     return GetPointer(this);   }
   Order             *withMaskSlippage(int slippageIn)         { this.maskSlippage = slippageIn;         return GetPointer(this);   }
   Order             *withCloseSlippage(int slippageIn)         { this.closeSlippage = slippageIn;         return GetPointer(this);   }
   Order             *withTicket(int ticketIn)                 { this.ticket = ticketIn;                 return GetPointer(this);   }
   Order             *withOrderType(int orederTipeIn)          { this.orderType = orederTipeIn;          return GetPointer(this);   }
   Order             *withMagicNumber(int magicNumberIn)       { this.magicNumber = magicNumberIn;       return GetPointer(this);   }
   Order             *withSymbol(string symbolIn)              { this.symbol = symbolIn;                 return GetPointer(this);   }         
   Order             *withLots(double lotsIn)                  { this.lots = lotsIn;                     return GetPointer(this);   }
   Order             *withMinLot()                             { this.minLot = this.minLot = MarketInfo(Symbol(), MODE_MINLOT);                     
                                                                                                         return GetPointer(this);   }
   Order             *withWeight(double weightIn)              { this.weight = weightIn;                 return GetPointer(this);   }
   Order             *withComment(string commentIn)            { this.comment = commentIn;               return GetPointer(this);   }
   Order             *withOpenColor(color colorIn)             { this.openColor = colorIn;               return GetPointer(this);   }
   Order             *withModifyColor(color colorIn)           { this.modifyColor = colorIn;             return GetPointer(this);   }
   Order             *withTakeProfit(int takeProfitIn)         { this.takeProfit = takeProfitIn;         return GetPointer(this);   }
   Order             *withStopLoss(int stopLossIn)             { this.stopLoss = stopLossIn;             return GetPointer(this);   }
   Order             *withTakeProfitMaskDeviation(int deviation)   { this.takeProfitMaskDeviation = deviation;   return GetPointer(this);   }
   Order             *withStopLossMaskDeviation(int deviation)     { this.stopLossMaskDeviation = deviation;     return GetPointer(this);   }
   Order             *withTakeProfitPrice(double price)        { this.takeProfitPrice = price;           return GetPointer(this);   }
   Order             *withStopLossPrice(double price)          { this.stopLossPrice = price;             return GetPointer(this);   }
   
   double            getResult(); //Прибыль или убыток в пунктах
   int               getTicket()                      {return this.ticket;         }
   int               getMagicNumber()                 {return this.magicNumber;    }  // идентификатор 
   string            getSymbol()                      {return this.symbol;          }  // символ 
   double            getLots()                        {return this.lots;            }  // количество лотов 
   double            getPriceToOpen()                 {return this.priceToOpen;     }  // цена к открытию
   datetime          getTimeToOpen()                  {return this.timeToOpen;      }  // когда открыть сделку
   double            getPriceToClose()                {return this.priceToClose;    }  //Цена к закрытию
   datetime          getTimeToClose()                 {return this.timeToClose;     }  // когда закрыть сделку   int               slippage;      // проскальзывание 
   int               getTakeProfit()                  {return this.takeProfit;      } //take profit
   double            getTakeProfitPriceMin()          {return this.takeProfitPriceMin;}
   double            getStopLossPriceMax()            {return this.stopLossPriceMax;}
   
   double            getOpenPrice();
   datetime          getOpenTime();
   double            getClosePrice();
   datetime          getCloseTime();
   double            getStopLoss()                    {return(stopLossPrice);       }
   double            getStopLossPrice();
   double            getTakeProfitPrice();
   double            getStopLossMaskPrice();
   double            getTakeProfitMaskPrice();
   int               getType();
   double            getNativeTakeProfitPrice();
   double            getNativeStopLossPrice();
   bool              isClosed();
   bool              isOpened();
   bool              isOpenedBarsAgo(int bar); // ордер открыт больше чем bar свечей назад
   bool              isLoss(double minimalProfit);    //в пунктах
   bool              isProfit(double minimalProfit); //в пунктах
   
   Order             *openBy(double basePrice);
   bool              close(double priceIn, color clrIn);
   Order             *openWithPrice(double priceToOpen);              //открыть сделку по определенной цене
   Order             *openAfterPriceShift(int price_shift);   //открыть сделку через определенное количество пунктов
   Order             *openByTime(datetime time);              //открыть сделку в определенное время
   Order             *openAfterTimeShift(int time_shift);     //открыть сделку в определенное время
   
   Order             *setLots();
   Order             *modifyOpenPrice(double priceToOpen);               //открыть сделку через промежуток времени (в минутах)
   Order             *modifyOpenPrice(int range);                  //на определенное количество пунктов
   Order             *modifyStopLoss(double stopLossPrice);  
   Order             *withStopLossMaskPrice(double price);
   Order             *modifyTakeProfit(double priceToTakeProfit);
   Order             *withTakeProfitMaskPrice(double price);  
   string            typeToString();
   bool              isFirstStart(Order& lastFromHistory);
   int               addFirstAsOpened();
   string            toString();
  };
 

Order::Order(){
   this.symbol = Symbol();
   lots = MarketInfo(Symbol(),MODE_MINLOT);
   minLot = MarketInfo(Symbol(),MODE_MINLOT);
   ticket = -1;
   weight = 1;   mask = false;
  }

Order::Order(bool logg){
   this.symbol = Symbol();
   lots = MarketInfo(Symbol(),MODE_MINLOT);
   minLot = MarketInfo(Symbol(),MODE_MINLOT);
   ticket = -1;
   weight = 1;   mask = false;
   this.logging = logg;
}
Order::Order(Order& order){
   this = order;
}

int Order::ordersCount(void){
   int count = 0;
   if(OrdersTotal() > 0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         int tic = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         if(OrderMagicNumber() == this.magicNumber && OrderSymbol() == Symbol() && OrderType() == orderType) {
            count++;
         }
      }
   }
   return count;
}


bool Order::equal(Order *order_in){
   if(this.ticket>0 && this.ticket == order_in.getTicket())
      return true;
   else 
      return false;   
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Order::close(double price, color col){
   bool isClose = OrderClose(this.ticket, OrderLots(), price, this.closeSlippage, col);
   if(isClose){
      if(this.logging)
         Print(Symbol() + " N" + IntegerToString(this.magicNumber) + ": @Order " + this.typeToString() + "-> #" + IntegerToString(this.ticket) + " is closed");
      this.ticket = -1;
      this.stopLossPrice = 0;
      this.takeProfitPrice = 0;
      this.stopLossMaskPrice = 0;
      this.takeProfitMaskPrice = 0;
   } else {
      if(this.logging)
         Print(Symbol() + " N" + IntegerToString(this.magicNumber) + ": @Order " + this.typeToString() + " -> #" + IntegerToString(this.magicNumber) + " unclosed. Close ERROR = " + IntegerToString(GetLastError()));
   }
   return isClose;
}

int Order::addFirstAsOpened(){
   if(this.logging)
      Print(Symbol() + " N" + IntegerToString(this.magicNumber) + ": @Order " + this.typeToString() + " -> Trying to connect to current orders");
   if(OrdersTotal() > 0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         int tic = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         if(OrderType() == this.orderType && OrderSymbol()==Symbol() && OrderMagicNumber() == this.magicNumber) {
            if(this.logging)
               Print(Symbol() + " N" + IntegerToString(this.magicNumber) + ": @Order " + this.typeToString() + " -> Connected to #" + IntegerToString(OrderTicket()));
            return this.ticket = OrderTicket();
         }
      }
   }
   Print(Symbol() + " N" + IntegerToString(this.magicNumber) + ": @Order " + this.typeToString() + " -> NO CONNETIONS");
   return -1; 
}

double Order::getNativeTakeProfitPrice(void){
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES) || 
      OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_HISTORY)){
      return OrderTakeProfit();
   } else
      return(-1);
}

double Order::getNativeStopLossPrice(void){
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES) || 
      OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_HISTORY)){
      return OrderStopLoss();
   } else
      return(-1);
}

double Order::getOpenPrice(){
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES) || 
      OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_HISTORY)){
      return OrderOpenPrice();
   } else
      return(-1);
}

double Order::getClosePrice(){
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_HISTORY)){
      return OrderClosePrice();
   } else
      return(-1);
}

datetime Order::getOpenTime(){
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES) ||
      OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_HISTORY)){
      return OrderOpenTime();
   } else
      return(-1);
}

int Order::getType(){
   if((OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES) ||
      OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_HISTORY)) && 
      OrderSymbol() == Symbol()){
         return OrderType();
      
   } else
      return(-1);
}

datetime Order::getCloseTime(){
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_HISTORY)||
      OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES)){
      return OrderCloseTime();
   } else
      return(-1);
}

double Order::getResult(){
   if((OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES) || 
      OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_HISTORY)) && OrderSymbol() == Symbol()){
      return OrderProfit()/OrderLots();
   } 
   
   return(0);
}


bool Order::isOpened(){
   if(this.getCloseTime() == 0){
      return true;
   }
   
   return false;
}

bool Order::isClosed(){
   if(this.getCloseTime() > 0)
      return true;
   
   return false;
}

bool Order::isLoss(double minimalProfit){
   if(this.getResult() < minimalProfit)
      return true;
   
   return false;
}


bool Order::isProfit(double minimalProfit){
   if(this.getResult() >= minimalProfit)
      return true;
   
   return false;
}


bool Order::isOpenedBarsAgo(int bar){ // ПРЕДЫДУЩИЙ ордер открыт больше чем bar свечей назад
   if(this.getCloseTime()==0 && this.getOpenTime()<(TimeCurrent()-bar*PeriodSeconds()))
      return true;
   
   return false;
}

Order *Order::modifyStopLoss(double newStopLossPrice){
   this.withStopLossPrice(newStopLossPrice);
   double _stopLossPrice = this.stopLossPrice;
   if(this.mask){
      _stopLossPrice = this.stopLossMaskPrice;
   }
   
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES)){   
      bool modified = OrderModify(this.ticket, OrderOpenPrice(), _stopLossPrice, OrderTakeProfit(), OrderExpiration(), modifyColor);
   }
   return GetPointer(this);
}  

Order *Order::modifyTakeProfit(double newTakeProfitPrice){
   this.withTakeProfitPrice(NormalizeDouble(newTakeProfitPrice, 6));
   double _takeProfitPrice = this.takeProfitPrice;
   
   if(this.mask){
      _takeProfitPrice = this.takeProfitMaskPrice;
   }
   
   
   if(OrderSelect(this.ticket, SELECT_BY_TICKET, MODE_TRADES)){
      bool modified = OrderModify(this.ticket, OrderOpenPrice(), OrderStopLoss(), _takeProfitPrice, OrderExpiration(), modifyColor);
   }
   return GetPointer(this);
}  

double Order::getStopLossPrice(void){
   return this.stopLossPrice;
}

double Order::getTakeProfitPrice(void){
   return this.takeProfitPrice;
}


double Order::getStopLossMaskPrice(void){
   return this.stopLossMaskPrice;
}

double Order::getTakeProfitMaskPrice(void){
   return this.takeProfitMaskPrice;
}

bool  Order::isFirstStart(Order& lastFromHistory){
   if(OrdersHistoryTotal() == 1 && lastFromHistory.getType() != OP_BUY && lastFromHistory.getType() != OP_SELL) 
      return true; 
   if(OrdersHistoryTotal() == 0 && !this.isOpened())
      return true;
   return false;
}

Order *Order::setLots(){
   this.lots = round((this.weight * this.lots)/this.minLot) * this.minLot;
   if(this.lots == 0)
      this.lots = this.minLot;
   return GetPointer(this);
}

string Order::typeToString(){
   switch(this.orderType){
      case 0:
         return "OP_BUY";
         break;
      case 1: 
         return "OP_SELL";
   }
   return "";
}
Order  *Order::openBy(double basePrice){
   if(this.logging)
      Print(Symbol() + " N" + IntegerToString(this.magicNumber) + ": @Order " + this.typeToString() + " -> Trying to open");
   if(!this.mask)
      this.ticket = OrderSend(this.symbol, orderType, lots, basePrice, slippage, stopLossPrice, takeProfitPrice, comment, magicNumber, expiration, openColor);
   else
      this.ticket = OrderSend(this.symbol, orderType, lots, basePrice, slippage, stopLossMaskPrice, takeProfitMaskPrice, comment, magicNumber, expiration, openColor);
   if(this.logging)
      if(this.ticket > 0) 
         Print(Symbol() + " N" + IntegerToString(this.magicNumber) + ": @Order " + this.typeToString() + " -> Opened " + " by " + DoubleToString(basePrice, 5)); 
      else
         Print(Symbol() + " N" + IntegerToString(this.magicNumber) + ": @Order " + this.typeToString() + " -> ERROR TO OPEN " + " by " + DoubleToString(basePrice, 5)); 
   return GetPointer(this);
}

string Order::toString(void){
   string strTmp = "";
   strTmp += "ticket = "            +  IntegerToString(this.ticket)                         + "; ";    
   strTmp += "type = "              +  IntegerToString(orderType)                         + "; ";    
   strTmp += "result = "              +  DoubleToString(this.getResult())                         + "; ";    
   
   //strTmp += "symbol = "            +  symbol                                          + "; "; 
   //strTmp += "lots = "              +  DoubleToString(lots)                            + "; ";    
   //strTmp += "priceToOpen = "       +  DoubleToString(priceToOpen)                     + "; ";    
   //strTmp += "openPrice = "         +  DoubleToString(this.getOpenPrice())             + "; ";
   //strTmp += "timeToOpen = "        +  TimeToString(timeToOpen, TIME_SECONDS)          + "; ";    
   //strTmp += "openTime = "          +  TimeToString(this.getOpenTime(), TIME_SECONDS)  + "; ";
   //strTmp += "slippage = "          +  IntegerToString(slippage)                       + "; ";   
   //strTmp += "closePrice = "        +  DoubleToString(this.getClosePrice())            + "; ";
   //strTmp += "closeTime = "         +  TimeToString(this.getCloseTime(), TIME_SECONDS) + "; "; 
   //strTmp += "takeProfitPrice = "   +  DoubleToString(takeProfitPrice)                 + "; ";    
   //strTmp += "stopLossPrice = "     +  DoubleToString(stopLossPrice)                   + "; ";    
   //strTmp += "takeProfit = "        +  IntegerToString(takeProfit)                     + "; ";    
   //strTmp += "stopLoss = "          +  IntegerToString(stopLoss)                       + "; ";    
   //strTmp += "magicNumber = "       +  IntegerToString(magicNumber)                    + "; ";    
   //strTmp += "openColor = "        +  IntegerToString(openColor)                     + "; ";    
   //strTmp += "modifyColor = "      +  IntegerToString(modifyColor)                   + "; ";    
   //strTmp += "timeToClose = "       +  TimeToString(timeToClose, TIME_SECONDS)         + "; ";    
   //strTmp += "weightOrder = "       +  DoubleToString(weightOrder)                     + "; ";    
   //strTmp += "maskOrder = "         +  IntegerToString(maskOrder)                      + "; ";
   //strTmp += "comment = "           +  comment                                         + "; ";   
   return(strTmp);     
}

//+------------------------------------------------------------------+
/*Для увеличения скорости поиска сделки в библиотеке в истории и в торговле
создается свое хранилище сделок. При обращении в это хранилище сделка
будет находиться однозначно по различным параметрам и с различными вариантами 
сортировки*/
/*Цена открытия - цена на которой открывается сделка. Актуальна для 
отложенных ордеров*/

/*Уровень убытка - это цена на которой сделка будет закрыта сделка, 
если маскировка включена, или цена на которую устанавливается StopLoss,
если маскировка выключена. При включенной мескировке можно реализовать
многоступенчатый уровень убытка. Это значит, что у сделки будет несколько
уровней убытка, которые будут срабатывать в определенных условиях.*/

/*Уровень прибыли - это цена на которой сделка будет закрыта сделка, 
если маскировка включена, или цена на которую устанавливается TakeProfit,
если маскировка выключена. При включенной мескировке можно реализовать
многоступенчатый уровень прибыли. Это значит, что у сделки будет несколько
уровней прибыли, которые будут срабатывать в определенных условиях.*/

/*Время жизни - количество минут, которое живет сделка. По истечении 
этого времени сделка принудительно закрывается.*/

/*Время закрытия - момент времени, в который закроется сделка. Т.е. 
при достижении времени 8.00 15.04.2015 сделка будет закрыта принудительно*/

/*
symbol      [in]  Наименование финансового инструмента, с которым проводится торговая операция.
orderType   [in]  Торговая операция. Может быть любым из значений торговых операций.
                  0 - OP_BUY       = Покупка 
                  1 - OP_SELL      = Продажа
                  2 - OP_BUYLIMIT  = Отложенный ордер BUY LIMIT
                  3 - OP_SELLLIMIT = Отложенный ордер SELL LIMIT
                  4 - OP_BUYSTOP   = Отложенный ордер BUY STOP
                  5 - OP_SELLSTOP  = Отложенный ордер SELL STOP
lots        [in]  Количество лотов.
priceToOpen       [in]  Цена открытия.
slippage    [in]  Максимально допустимое отклонение цены для рыночных ордеров (ордеров на покупку или продажу).
stopLoss    [in]  Цена закрытия ордера при достижении уровня убыточности (0 в случае отсутствия уровня убыточности).
takeProfit  [in]  Цена закрытия ордера при достижении уровня прибыльности (0 в случае отсутствия уровня прибыльности).
comment=NULL[in]  Текст комментария ордера. Последняя часть комментария может быть изменена торговым сервером.
magic=0     [in]  Магическое число ордера. Может использоваться как определяемый пользователем идентификатор.
expiration=0[in]  Срок истечения отложенного ордера.
arrow_color=clrNONE[in]  Цвет открывающей стрелки на графике. Если параметр отсутствует или его значение равно CLR_NONE, то открывающая стрелка не отображается на графике.

Возвращаемое значение
Возвращает номер тикета (билета), который назначен ордеру торговым сервером или -1 в случае неудачи. 
Чтобы получить информацию об ошибке, необходимо вызвать функцию getLastError().

Примечание
При открытии рыночного ордера (OP_SELL или OP_BUY) в качестве цены открытия могут использоваться только самые 
последние цены Bid (для продажи) или Ask (для покупки). 
Если операция проводится по финансовому инструменту, отличному от текущего, то для получения последних котировок 
по этому инструменту необходимо воспользоваться функцией MarketInfo() с параметром MODE_BID или MODE_ASK. 
Нельзя использовать расчетную либо ненормализованную цену. Если запрашиваемой цены открытия не было в ценовом потоке, 
либо запрашиваемая цена не нормализована в соответствии с количеством знаков после десятичной точки, 
то будет сгенерирована ошибка 129 (ERR_INVALID_PRICE). Если запрашиваемая цена открытия сильно устарела, 
то независимо от значения параметра slippage будет сгенерирована ошибка 138 (ERR_REQUOTE). 
Если же запрашиваемая цена устарела, но еще присутствует в ценовом потоке, то ордер открывается по текущей цене и 
только в том случае, если текущая цена попадает в диапазон price+-slippage.

Цены StopLoss и TakeProfit не могут располагаться слишком близко к рынку. Минимальное расстояние стопов в пунктах 
можно получить, используя функцию MarketInfo() с параметром MODE_STOPLEVEL. В случае ошибочных, а также 
ненормализованных стопов генерируется ошибка 130 (ERR_INVALID_STOPS). Нулевое значение MODE_STOPLEVEL означает 
либо отсутствие  ограничения на минимальную дистанцию для стоп-лосса/тейк-профита, 
либо факт использования торговым сервером внешних механизмов динамического контроля уровней, 
которые не могут быть транслированы в терминал. 
Во втором случае getLastError() может возвращать ошибку 130, так как уровень MODE_STOPLEVEL фактически является "плавающим".
При установке отложенного ордера цена открытия не может быть слишком близкой к рынку. 
Минимальное расстояние отложенной цены от текущей рыночной цены в пунктах также можно получить, 
используя функцию MarketInfo() с параметром MODE_STOPLEVEL. 
В случае неправильной цены открытия отложенного ордера будет сгенерирована ошибка 130 (ERR_INVALID_STOPS).
На некоторых торговых серверах может быть установлен запрет на применение срока истечения отложенных ордеров. 
В этом случае при попытке задать ненулевое значение в параметре expiration будет сгенерирована ошибка 147 (ERR_TRADE_EXPIRATION_DENIED).
На некоторых торговых серверах может быть установлен лимит на общее количество открытых и отложенных ордеров. 
При превышении этого лимита новый ордер открыт не будет (отложенный ордер не будет установлен), 
и торговый сервер вернет ошибку 148 (ERR_TRADE_TOO_MANY_ORDERS).
ы*/
//+------------------------------------------------------------------+
