//+------------------------------------------------------------------+
//|                                                  MTS_Builder.mq4 |
//|                                  Пархейчук Дмитрий Александрович |
//|                                                           pkt.by |
//+------------------------------------------------------------------+
#property copyright "Dzmitry Parkheichuk"
#property link      "pkt.by"
#property version   "1.00"
#property strict
#include "OrdersManager/Buy.mqh"
#include "OrdersManager/Sell.mqh"
#include "Analitics/MovingAverage/MovingAverage.mqh"
#include "Analitics/Sara/Sara.mqh"

extern   int   stopLoss=500;
extern   int   takeProfit=1220;
//**********TRAILING MovingAverage
extern   bool  TRAILING_STOP_MA=false;
extern   int   TMA_period=10; //Moving Average petiod
extern   int   TMA_priceshift=300; //Сдвиг по вертикали
extern   ENUM_MA_METHOD TMA_method=1; //Метод скользящей средней
extern   int   TMA_candle_shift=1; //Значение для свечи №

                                   //**********TRAILING Parabolic SAR 
extern   bool     TRAILING_STOP_SARA=false;
extern   double   TSAR_step=0.02; //шаг
extern   double   TSAR_maximum=2;  //максимум
extern   int   TSAR_timeshift=0; //Сдвиг по горизонтали
extern   int   TSAR_priceshift = 300; //Сдвиг по вертикали
extern   int   TSAR_candle_shift = 1; //Значение для свечи №

Buy *orderBuy;
Sell *orderSell;
MovingAverage *stopBuyLineMA;
MovingAverage *stopSellLineMA;
Sara *stopBuylLineSAR;
Sara *stopSelllLineSAR;
//OrderBox *orderBox_B;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   orderBuy=new Buy();
   orderBuy
      .withMagicNumber(5)
      .withSymbol(Symbol())
      .withComment("Buy for new system")
      .withOpenColor(clrBlue)
      .withModifyColor(clrAliceBlue)
      .withStopLoss(stopLoss)
      .withTakeProfit(takeProfit);
   
   orderSell=new Sell();
   orderSell
      .withMagicNumber(5)
      .withSymbol(Symbol())
      .withComment("Sell for new system")
      .withOpenColor(clrRed)
      .withModifyColor(clrRosyBrown)
      .withStopLoss(stopLoss)
      .withTakeProfit(takeProfit);
      

//stopBuyLineMA = new MovingAverage(Symbol(), ChartPeriod(0), TMA_period, -TMA_priceshift, TMA_method, PRICE_LOW, clrGreen);
//stopSellLineMA = new MovingAverage(Symbol(), ChartPeriod(0), TMA_period, TMA_priceshift, TMA_method, PRICE_HIGH, clrWhite);
//stopBuylLineSAR = new Sara(Symbol(), ChartPeriod(0), TSAR_step, TSAR_maximum, -TSAR_priceshift);
//stopSelllLineSAR = new Sara(Symbol(), ChartPeriod(0), TSAR_step, TSAR_maximum, TSAR_priceshift);
//--- create timer
   EventSetTimer(60);
   return(INIT_SUCCEEDED);
   }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//--- destroy timer
//EventKillTimer();

   }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!orderSell.isOpened()/*||orderSell.isOpenedBarsAgo(1))&&stopSelllLineSAR.Direction(1,2)==-1*/){
         orderSell.open();
      }

   if(!orderBuy.isOpened()/*||orderSell.isOpenedBarsAgo(1)) &&stopBuylLineSAR.Direction(1,2)==1*/){
      orderBuy.open(); 
   }

   if(orderSell.isOpened()){
      if(TRAILING_STOP_MA && stopSellLineMA.Direction(1,2)==-1)
         orderSell.TrailingStop(stopSellLineMA.GetPrice(TMA_candle_shift));
      if(TRAILING_STOP_SARA && stopSelllLineSAR.Direction(1,2)==-1)
         orderSell.TrailingStop(stopSelllLineSAR.GetPrice(TSAR_candle_shift));
   }
  
   if(orderBuy.isOpened()){
   if(TRAILING_STOP_MA && stopSellLineMA.Direction(1,2)==1)
      orderBuy.TrailingStop(stopBuyLineMA.GetPrice(TMA_candle_shift));
   if(TRAILING_STOP_SARA && stopSelllLineSAR.Direction(1,2)==1)
      orderBuy.TrailingStop(stopBuylLineSAR.GetPrice(TSAR_candle_shift));
   }
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
/*double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }*/
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
/*void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
*/
//+------------------------------------------------------------------+
