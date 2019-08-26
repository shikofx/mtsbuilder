//+------------------------------------------------------------------+
//|                                            Верх-Низ повтор.mq4 |
//|                                                       Кацко М.В. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Кацко М.В."
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
extern bool Buy = true;
extern bool Sell = true;
extern int StopLoss = 0;
extern int TakeProfit = 0;
extern int РазмерТелаСвечи = 0;

double ТелоСвечи;
double РазмерСвечи;
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(TimeCurrent()==Time[0])
      {
      ТелоСвечи = Open[1]-Close[1];
      РазмерСвечи = MathAbs(ТелоСвечи)/Point;
      if(ТелоСвечи>0 && РазмерСвечи>РазмерТелаСвечи)
         int ticketeSell=OrderSend(Symbol(),OP_SELL,0.01,Ask,30,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Продано",100,0,clrRed);
      if(ТелоСвечи<0 && РазмерСвечи>РазмерТелаСвечи)
         int ticketeBuy=OrderSend(Symbol(),OP_BUY,0.01,Bid,30,Bid-StopLoss*Point,Bid+TakeProfit*Point,"Куплено",100,0,clrDarkBlue);
      }
  Comment(РазмерСвечи);
  } 

