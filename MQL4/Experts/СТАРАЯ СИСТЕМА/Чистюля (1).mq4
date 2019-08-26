//+------------------------------------------------------------------+
//|                                                      �������.mq4 |
//|                                                   ��������� �.�. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "��������� �.�."
#property link      ""
#property version   "1.00"
#property strict

#include "�����������.mqh"

extern int �������= 10000;
extern int ������ = 10000;

extern string ���_���="����";
extern int ���_�����_����� = 5;
extern int ���_�����_������ = 1;

extern ENUM_TIMEFRAMES ���_���������=0;
extern int ���_������=0;
extern double ���_����������=0;
extern int ���_���������=0;
extern int ���_�����=0;
extern int ���_�����_�����=0;

extern ENUM_��������_�������� ��������_��������=����_�����_�������;
STRUCT_������_������ porcy;
��� *pik_down, *pik_up;
������������� *buyRoom,*sellRoom;
������ *buy,*sell;
���������������� *bollinger_line_up,*bollinger_line_down;
����� *candle;
ENUM_������� symbol=GBPUSD;
double TESTER_��������;

double ����_�����;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
   double ������_�������=TesterStatistics(STAT_PROFIT);
   double ������������_��������=TesterStatistics(STAT_EQUITY_DD);
   double �����_�������=TesterStatistics(STAT_GROSS_PROFIT);
/*if(������_�������<=0)
      return 0;
   if(������������_��������!=0)
      TESTER_��������=������_�������/������������_��������;

   TESTER_��������=MathRound(TESTER_��������*100)/100;**/

   return �����_�������;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   bollinger_line_up=new ����������������(������_�����,���_���������,���_������,���_����������,���_�����,���_���������,���_�����_�����);
   bollinger_line_down=new ����������������(������_����,���_���������,���_������,���_����������,���_�����,���_���������,���_�����_�����);
   buy=new ������(OP_BUY,symbol,false,0.01,�������,������,0,00000,clrDarkSlateGray,0,0);
   sell=new ������(OP_SELL,symbol,false,0.01,�������,������,0,11111,clrFireBrick,0,0);
   pik_up = new ���(���_�����_������, ���_�����_�����, 0, true, clrFireBrick, 3);
   pik_down = new ���(���_�����_������, ���_�����_�����, 0, false, clrAqua, 3);
   candle=new �����(symbol,1,Period());

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
   if(buy.����������������()==0)
      buyRoom=new �������������();
   else 
      buyRoom.������������������(bollinger_line_up.���������������());

   if(sell.����������������()==0)
      sellRoom=new �������������();
   else
      sellRoom.������������������(bollinger_line_down.���������������());

   if(TimeCurrent()==Time[0])
     {
      if(pik_down.�������������(���_���)/*&&buy.����������������()==0*/)
        {
         pik_down.����������������();
         buy.�������������(0);
         buyRoom.��������������(buy);
        }

      if(pik_up.�������������(���_���)/*&&sell.����������������()==0*/)
        {
         pik_up.����������������();
         sell.�������������(0);
         sellRoom.��������������(sell);
        }

     }

  }
//+------------------------------------------------------------------+
