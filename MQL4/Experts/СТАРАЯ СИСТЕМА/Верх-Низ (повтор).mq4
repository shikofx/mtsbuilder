//+------------------------------------------------------------------+
//|                                            ����-��� ������.mq4 |
//|                                                       ����� �.�. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "����� �.�."
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
extern bool Buy = true;
extern bool Sell = true;
extern int StopLoss = 0;
extern int TakeProfit = 0;
extern int ��������������� = 0;

double ���������;
double �����������;
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
      ��������� = Open[1]-Close[1];
      ����������� = MathAbs(���������)/Point;
      if(���������>0 && �����������>���������������)
         int ticketeSell=OrderSend(Symbol(),OP_SELL,0.01,Ask,30,Bid+StopLoss*Point,Bid-TakeProfit*Point,"�������",100,0,clrRed);
      if(���������<0 && �����������>���������������)
         int ticketeBuy=OrderSend(Symbol(),OP_BUY,0.01,Bid,30,Bid-StopLoss*Point,Bid+TakeProfit*Point,"�������",100,0,clrDarkBlue);
      }
  Comment(�����������);
  } 

