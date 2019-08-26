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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Order
  {
protected:
   int               ticket;        //индивидуальный номер сделки на сервере
   int               magicNumber;   //индивидуальный номер 
   string            symbol;        // символ 
   double            lots;          // количество лотов 
   double            priceToOpen;         // цена к открытию
   int               slippage;
   datetime          timeToOpen;    // когда открыть сделку
   double            priceToClose; //Цена к закрытию
   datetime          timeToClose;   // когда закрыть сделку   int               slippage;      // проскальзывание 
   double            priceToTakeProfit;      // 
   double            takeProfitPrice; //take profit
   int               takeProfit; //take profit
   double            stopLossPrice;    // 
   int               stopLoss; //stop loss
   double            weightOrder;   // вес сделки в порции
   bool              maskOrder;     // включение маскировки сделки   
   string            comment;       // комментарий 
   color             openColor;
   color             modifyColor;
   
public:
                     Order();
                    
                     //Order(string symbol_in, int slippage_in, string comment_in, int magicNumber_in, color openColor_in, color modifyColor);
                     //Order(   string symbol_in,     double lots_in,      double price_in,     int slippage_in, 
                     //         int stopLoss_in,  int takeProfit_in,   string comment_in,   int magicNumber_in,  color openColor_in, color modifyColor);
                    ~Order(){};
   bool              equal(Order *order);
   Order             *withTicket(int ticketIn);
   Order             *withMagicNumber(int magicNumberIn) { this.magicNumber = magicNumberIn;  return GetPointer(this); }
   Order             *withSymbol(string symbolIn)        { this.symbol = symbolIn;  return GetPointer(this); }         
   Order             *withLots(double lotsIn)            { this.lots = lotsIn;  return GetPointer(this); }
   Order             *withComment(string commentIn)      { this.comment = commentIn;  return GetPointer(this); }
   Order             *withOpenColor(color colorIn)       { this.openColor = colorIn;  return GetPointer(this); }
   Order             *withModifyColor(color colorIn)     { this.modifyColor = colorIn;  return GetPointer(this); }
   Order             *withTakeProfit(int takeProfitIn){ this.takeProfit = takeProfitIn;  return GetPointer(this); }
   Order             *withStopLoss(int stopLossIn)    { this.stopLoss = stopLossIn;  return GetPointer(this); }
   int               getTicket()                      {return this.ticket;         }
   int               getMagicNumber()                 {return this.magicNumber;    }  // идентификатор 
   string            getSymbol()                      {return this.symbol;          }  // символ 
   double            getLots()                        {return this.lots;            }  // количество лотов 
   double            getPriceToOpen()                 {return this.priceToOpen;     }  // цена к открытию
   datetime          getTimeToOpen()                  {return this.timeToOpen;      }  // когда открыть сделку
   double            getPriceToClose()                {return this.priceToClose;    }  //Цена к закрытию
   datetime          getTimeToClose()                 {return this.timeToClose;     }  // когда закрыть сделку   int               slippage;      // проскальзывание 
   int               getTakeProfit()                  {return this.takeProfit;      } //take profit
   double            getOpenPrice();
   datetime          getOpenTime();
   double            getClosePrice();
   datetime          getCloseTime();
   double            getStopLoss()                    {return(stopLossPrice);       }

   double            getStopLossPrice();
   double            getTakeProfitPrice();
   bool              isOpened();
   bool              isOpenedBarsAgo(int bar); // ордер открыт больше чем bar свечей назад
   bool              isOpenedTimeAgo(int interval); // ордер открыт больше чем bar свечей назад
   bool              isClosed();
   int               open();
   int               openWithPrice(double priceToOpen);              //открыть сделку по определенной цене
   int               openAfterPriceShift(int price_shift);   //открыть сделку через определенное количество пунктов
   int               openByTime(datetime time);              //открыть сделку в определенное время
   int               openAfterTimeShift(int time_shift);     //открыть сделку в определенное время
   bool              modifyOpenPrice(double priceToOpen);               //открыть сделку через промежуток времени (в минутах)
   bool              modifyOpenPrice(int range);                  //на определенное количество пунктов
   bool              modifyStopLoss(double stopLossPrice);  
   bool              modifyTakeProfit(double priceToTakeProfit);
   string            toString();
  };
 

Order::Order(){
   weightOrder=1;
   lots= MarketInfo(Symbol(),MODE_MINLOT);
   ticket = 0;
   timeToOpen = 0;
   priceToTakeProfit = 0;
   stopLossPrice = 0;
   timeToOpen =0;
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
  
double Order::getOpenPrice(void){
   double priceOfOpen = 0;
   if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)){
      priceOfOpen = OrderOpenPrice();
   } else
      return(-1);
   return(priceOfOpen);
}

double Order::getClosePrice(void){
   double priceOfClose = 0;
   if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)&&OrderCloseTime()>0){
      priceOfClose = OrderClosePrice();
   } else
      return(-1);
   return(priceOfClose);
}

datetime Order::getOpenTime(void){
   datetime timeOfOpen = 0;
   if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)){
      timeOfOpen = OrderOpenTime();
   } else
      return(-1);
   return(timeOfOpen);
}

datetime Order::getCloseTime(void){
   datetime timeOfClose = 0;
   if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)){
      timeOfClose = OrderCloseTime();
   } else
      return(-1);
   return(timeOfClose);
}


bool Order::isOpened(void){
   if(this.getCloseTime()==0)
      return true;
   else 
      return false;
}

bool Order::isOpenedBarsAgo(int bar){ // ПРЕДЫДУЩИЙ ордер открыт больше чем bar свечей назад
   if(this.getCloseTime()==0&&this.getOpenTime()<(TimeCurrent()-bar*PeriodSeconds()))
      return true;
   else 
      return false;
}

bool Order::modifyStopLoss(double stopLossPrice_in){
   bool modified = false;
   if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)){
      stopLossPrice = stopLossPrice_in;
      modified = OrderModify(ticket, OrderOpenPrice(), stopLossPrice, OrderTakeProfit(), OrderExpiration(), modifyColor);
   }
   return modified;
}  

bool Order::modifyTakeProfit(double takeProfitPrice_in){
   bool modified = false;
   if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)){
      modified = OrderModify(ticket, OrderOpenPrice(), OrderStopLoss(), takeProfitPrice_in, OrderExpiration(), modifyColor);
   }
    return modified;
}  

string Order::toString(void){
   string strTmp = "";
   strTmp += "ticket = "            +  IntegerToString(ticket)                         + "; ";    
   strTmp += "symbol = "            +  symbol                                          + "; "; 
   strTmp += "lots = "              +  DoubleToString(lots)                            + "; ";    
   strTmp += "priceToOpen = "       +  DoubleToString(priceToOpen)                     + "; ";    
   strTmp += "openPrice = "         +  DoubleToString(this.getOpenPrice())             + "; ";
   strTmp += "timeToOpen = "        +  TimeToString(timeToOpen, TIME_SECONDS)          + "; ";    
   strTmp += "openTime = "          +  TimeToString(this.getOpenTime(), TIME_SECONDS)  + "; ";
   strTmp += "slippage = "          +  IntegerToString(slippage)                       + "; ";   
   strTmp += "closePrice = "        +  DoubleToString(this.getClosePrice())            + "; ";
   strTmp += "closeTime = "         +  TimeToString(this.getCloseTime(), TIME_SECONDS) + "; "; 
   strTmp += "takeProfitPrice = "   +  DoubleToString(takeProfitPrice)                 + "; ";    
   strTmp += "stopLossPrice = "     +  DoubleToString(stopLossPrice)                   + "; ";    
   strTmp += "takeProfit = "        +  IntegerToString(takeProfit)                     + "; ";    
   strTmp += "stopLoss = "          +  IntegerToString(stopLoss)                       + "; ";    
   strTmp += "magicNumber = "       +  IntegerToString(magicNumber)                    + "; ";    
   strTmp += "openColor = "        +  IntegerToString(openColor)                     + "; ";    
   strTmp += "modifyColor = "      +  IntegerToString(modifyColor)                   + "; ";    
   strTmp += "timeToClose = "       +  TimeToString(timeToClose, TIME_SECONDS)         + "; ";    
   strTmp += "weightOrder = "       +  DoubleToString(weightOrder)                     + "; ";    
   strTmp += "maskOrder = "         +  IntegerToString(maskOrder)                      + "; ";
   strTmp += "comment = "           +  comment                                         + "; ";   
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
