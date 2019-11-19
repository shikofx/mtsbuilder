//+------------------------------------------------------------------+
//|                                                  MTS_Builder.mq4 |
//|                                  Пархейчук Дмитрий Александрович |
//|                                                           pkt.by |
//+------------------------------------------------------------------+
#property copyright "Dzmitry Parkheichuk"
#property link      "pkt.by"
#property version   "1.00"
#property strict

#include "OrdersManager/OrdersBox.mqh"
#include "OrdersManager/Buy.mqh"
#include "OrdersManager/Sell.mqh"
#include "Analitics/MovingAverage/MovingAverage.mqh"
#include "Analitics/Sara/Sara.mqh"
#include "Analitics/BollingerBands/BollingerBands.mqh"
#include "OrdersManager/History.mqh"
#include "OrdersManager/Market.mqh"
#include "MoneyManagement/FluentDelta.mqh"
#include "Testing/TestParameter.mqh"
#include "lib/enums.mqh"




extern   int               eMAGIC_NUMBER = 55555;        
extern   string            eORDER_COMMENT = "";          
extern   ENUM_ORDER_TYPE   eSTART_ORDER_TYPE = OP_SELL;  
extern   bool              eREAL_ACCOUNT = false;        
extern   double            eSTART_OPEN_PRICE = 0.0;      

extern   int   eDELAY = 0;                      
extern   bool  eMASK = false;                   
extern   int   eMASK_SLIPPAGE = 100;            
extern   int   eCLOSE_SLIPPAGE = 50;            
extern   int   eMASK_DELTA_STOP_LOSS = 500;     
extern   int   eMASK_DELTA_TAKE_PROFIT = 1000;  

extern   bool  eSYNCHRONOUS = true;          
extern   bool  eOPEN_AFTER_PROFIT = false;   
extern   int   eMAX_STOP_LOSS = 1500;        
extern   int   eMIN_TAKE_PROFIT = 1600;      

//**********TRAILING STOP Parabolic SAR 
extern   bool     eTLOSS_SAR              = true;
extern   double   eTLOSS_SAR_STEP         = 0.0006; 
double            eTLOSS_SAR_MAX          = 2;  
extern   int      eTLOSS_SAR_PRICE_SHIFT  = 400; 
extern   int      eTLOSS_SAR_BAR_SHIFT    = 2; 

//**********TRAILING STOP BollingerBands 
extern   bool     eTLOSS_BB               = false;
extern   ENUM_TIMEFRAMES eTLOSS_BB_TIMEFRAME = PERIOD_M15;
extern   int      eTLOSS_BB_PERIOD          = 60; 
extern   double   eTLOSS_BB_DEVIATION       = 2;  
extern   int      eTLOSS_BB_PRICE_SHIFT   = 400; 
extern   int      eTLOSS_BB_BAR_SHIFT     = 2; 

//**********TRAILING MovingAverage
extern   bool           eTSTOP_MA                  = false;
extern   int            eTSTOP_MA_PERIOD           = 10; 
extern   int            eTSTOP_MA_PRICE_SHIFT      = 300;
extern   ENUM_MA_METHOD eTSTOP_MA_METHOD  = 1;
extern   int            eTSTOP_MA_BAR_SHIFT        = 1; 

extern bool       eMM_FLUENT_DELTA = true;               
extern double     eMIN_LOT = 0.1;                        
extern int        eMM_FLUENT_DELTA_SWITCHER = 4;         
extern double     eMM_FLUENT_DELTA_DEPOSIT_START = 300;  
extern int        eMM_FLUENT_DELTA_DELTA = 60;           
extern double     eMM_FLUENT_DELTA_RATE_DOWN = 1.0;      

//Парциальная торговля
extern   int   eMAX_LOSSES_COUNT = 4; 
extern   double eMAX_LOSS = 1600; 
extern   double eWEIGHT_0 = 2; 
extern   double eWEIGHT_1 = 2; 
extern   double eWEIGHT_2 = 1; 
extern   double eWEIGHT_3 = 3; 
extern   double eWEIGHT_4 = 1; 
extern   double eWEIGHT_5 = 1; 
extern   double eWEIGHT_6 = 1; 
extern   double eWEIGHT_7 = 1; 
extern   double eWEIGHT_8 = 1; 
extern   double eWEIGHT_9 = 1;   
extern   double eWEIGHT_10 = 1; 
extern   double eWEIGHT_11 = 1; 
extern   double eWEIGHT_12 = 1; 
extern   double eWEIGHT_13 = 1; 
extern   double eWEIGHT_14 = 1; 

extern   TEST_PARAMETER  eTEST_PARAMETER = 1;

double lot = 0;
string   mmFileName;
int MM_file_handle=0;


Buy *orderBuy;
Sell *orderSell;
OrdersBox *lossesBox;
Order ordersArray[];
History history;
Market  market;
MovingAverage *stopBuyLineMA;
MovingAverage *stopSellLineMA;
double weight;
double weights[15];

Sara *buyStopLossSAR;
Sara *sellStopLossSAR;

BollingerBands *buyStopLossBB;
BollingerBands *sellStopLossBB;

FluentDelta mmFluentDelta;

Order lastOrder; 

double OnTester() {
   TestParameter testParameter = new TestParameter();
   switch(eTEST_PARAMETER){
      case 0:
         return testParameter.losses();        
      case 1: 
         return testParameter.power();
   }
   return testParameter.power();
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   
   orderBuy.checkMask();
   orderSell.checkMask();
   
   
   if(eSYNCHRONOUS && history.isChanged()){
      lastOrder = history.last();
      weight = lossesBox.getWeight(eMAX_LOSSES_COUNT, eMAX_LOSS, weights);
      orderBuy.withWeight(weight);
      orderSell.withWeight(weight);
   }
   
   if(!orderSell.isOpened())
      if(!eSYNCHRONOUS ||   
         (eSYNCHRONOUS && market.isEmpty() && history.isEmpty() && eSTART_ORDER_TYPE == OP_SELL) ||
         (eSYNCHRONOUS && market.isEmpty() && !eOPEN_AFTER_PROFIT && orderSell.isAsyncWith(lastOrder)) ||
         (eSYNCHRONOUS && market.isEmpty() && eOPEN_AFTER_PROFIT && orderSell.isSyncWith(lastOrder))){
      orderSell.open(eSTART_OPEN_PRICE);
   }
   
   if(!orderBuy.isOpened())
      if(!eSYNCHRONOUS ||
         (eSYNCHRONOUS && market.isEmpty() && history.isEmpty() && eSTART_ORDER_TYPE == OP_BUY) ||
         (eSYNCHRONOUS && market.isEmpty() && !eOPEN_AFTER_PROFIT && orderBuy.isAsyncWith(lastOrder)) ||
         (eSYNCHRONOUS && market.isEmpty() && eOPEN_AFTER_PROFIT && orderBuy.isSyncWith(lastOrder))){
      orderBuy.open(eSTART_OPEN_PRICE);
   }
      
   if(orderSell.isOpened()){
      if(eTSTOP_MA && stopSellLineMA.directionForCandles(1,2)==-1)
         orderSell.setStopLossPrice(NormalizeDouble(stopSellLineMA.price(eTSTOP_MA_BAR_SHIFT), Digits));
      if(eTLOSS_SAR && sellStopLossSAR.directionForCandles(1,2)==-1)
         orderSell.setStopLossPrice(NormalizeDouble(sellStopLossSAR.price(eTLOSS_SAR_BAR_SHIFT), Digits));
      if(eTLOSS_BB && sellStopLossBB.directionForCandles(1,2)==1)
         orderSell.setStopLossPrice(NormalizeDouble(sellStopLossBB.price(eTLOSS_SAR_BAR_SHIFT), Digits));
      
   }

   if(orderBuy.isOpened()){
      if(eTSTOP_MA && stopBuyLineMA.directionForCandles(1,2)==1)
         orderBuy.setStopLossPrice(NormalizeDouble(stopBuyLineMA.price(eTSTOP_MA_BAR_SHIFT), Digits));
      if(eTLOSS_SAR && buyStopLossSAR.directionForCandles(1,2)==1)
         orderBuy.setStopLossPrice(NormalizeDouble(buyStopLossSAR.price(eTLOSS_SAR_BAR_SHIFT), Digits));
      if(eTLOSS_BB && buyStopLossBB.directionForCandles(1,2)==-1)
         orderBuy.setStopLossPrice(NormalizeDouble(buyStopLossBB.price(eTLOSS_SAR_BAR_SHIFT), Digits));
   }
   
   if(eMM_FLUENT_DELTA)
      lot = mmFluentDelta.getLotsCount();
   else 
      lot = mmFluentDelta.getMinLot();
   
   orderBuy
      .withLots(lot);
      
   orderSell
      .withLots(lot);
   
   string commentString = "\n\n\n\nТекущее время: " + TimeToString(TimeCurrent()) +
            "\n\n\n-------------------MONEY-------------------" +
            "\nFree money: " + DoubleToString(mmFluentDelta.getFreeMoney(), 1) +
            "\n\nCurrent lots: " + DoubleToString(mmFluentDelta.getLotsCount(), 2) +
            "\n--------------------------------------";
            
   if(orderBuy.isOpened()){
      commentString += "\n\n\nBUY #" + IntegerToString(orderBuy.getTicket()) + ": " + orderBuy.isOpened() + 
            "\n-------------------MASK-------------------" + 
            "\nMask Loss = " + DoubleToString(orderBuy.getStopLossMaskPrice(), 5) + 
            "\nMask Profit = " + DoubleToString(orderBuy.getTakeProfitMaskPrice(), 5) +
            "\n\n-------------------REAL-------------------" +
            "\n\nReal Loss = " + DoubleToString(orderBuy.getStopLossPrice(), 5) + 
            "\nReal Profit = " + DoubleToString(orderBuy.getTakeProfitPrice(), 5);   
   }
   
   if(orderSell.isOpened()){
      commentString += "\n\n\nSELL #" + IntegerToString(orderSell.getTicket()) + ": " + orderSell.isOpened() + 
            "\n-------------------MASK-------------------" + 
            "\nMask Loss = " + DoubleToString(orderSell.getStopLossMaskPrice(), 5) +
            "\nMask Profit = " + DoubleToString(orderSell.getTakeProfitMaskPrice(), 5) + 
            "\n\n-------------------REAL-------------------"
            "\nReal Loss = " + DoubleToString(orderSell.getStopLossPrice(), 5) + 
            "\nReal Profit = " + DoubleToString(orderSell.getTakeProfitPrice(), 5);
   }
   
   Comment(commentString);           
            
}


//+---------------------   ---------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   //--------------------------ПАРЦИАЛЬНАЯ ТОРГОВЛЯ----------------------
   weight = 1;
   
   weights[0] =   eWEIGHT_0;   weights[1] =   eWEIGHT_1;   weights[2] =   eWEIGHT_2;   
   weights[3] =   eWEIGHT_3;   weights[4] =   eWEIGHT_4;   weights[5] =   eWEIGHT_5;   
   weights[6] =   eWEIGHT_6;   weights[7] =   eWEIGHT_7;   weights[8] =   eWEIGHT_8;   
   weights[9] =   eWEIGHT_9;   weights[10] =  eWEIGHT_10;  weights[11] =  eWEIGHT_11;  
   weights[12] =  eWEIGHT_12;  weights[13] =  eWEIGHT_13;  weights[14] =  eWEIGHT_14;
   
   lossesBox = new OrdersBox(eMAGIC_NUMBER);
   
   history = new History(eMAGIC_NUMBER);
   market = new Market(eMAGIC_NUMBER);
   //--------------------------УПРАВЛЕНИЕ СДЕЛКАМИ-----------------------
   orderBuy=new Buy();
   orderBuy
      .withSymbol(Symbol())
      .withMask(eMASK)
      .withStopLoss(eMAX_STOP_LOSS)
      .withStopLossMaskDeviation(eMASK_DELTA_STOP_LOSS)
      .withTakeProfit(eMIN_TAKE_PROFIT)
      .withTakeProfitMaskDeviation(eMASK_DELTA_TAKE_PROFIT)
      .withMaskSlippage(eMASK_SLIPPAGE)
      .withCloseSlippage(eCLOSE_SLIPPAGE)
      .withMagicNumber(eMAGIC_NUMBER)
      .withComment(eORDER_COMMENT)
      .withOpenColor(clrBlue)
      .withModifyColor(clrAliceBlue);
      
      
   orderSell=new Sell();
   orderSell
      .withSymbol(Symbol())
      .withMask(eMASK)
      .withStopLoss(eMAX_STOP_LOSS)
      .withStopLossMaskDeviation(eMASK_DELTA_STOP_LOSS)
      .withTakeProfit(eMIN_TAKE_PROFIT)
      .withTakeProfitMaskDeviation(eMASK_DELTA_TAKE_PROFIT)
      .withMaskSlippage(eMASK_SLIPPAGE)
      .withCloseSlippage(eCLOSE_SLIPPAGE)
      .withMagicNumber(eMAGIC_NUMBER)
      .withComment(eORDER_COMMENT)
      .withOpenColor(clrRed)
      .withModifyColor(clrRosyBrown);
   
   
   if(orderBuy.addFirstAsOpened() > 0)
      if(eSTART_OPEN_PRICE > 0)
         orderBuy.setBasicPricesBy(eSTART_OPEN_PRICE);
      else 
         orderBuy.setBasicPricesByCurrent();
   
   if(orderSell.addFirstAsOpened() > 0)
      if(eSTART_OPEN_PRICE > 0) 
         orderSell.setBasicPricesBy(eSTART_OPEN_PRICE);
      else
         orderSell.setBasicPricesByCurrent();
   
   if(market.isEmpty() && eSTART_ORDER_TYPE == OP_SELL)
      orderSell.open(eSTART_OPEN_PRICE);
   
   if(market.isEmpty() && eSTART_ORDER_TYPE == OP_BUY) 
      orderBuy.open(eSTART_OPEN_PRICE);
   
//   
//--------------------------MONEY MANAGEMENT-----------------------------
   mmFluentDelta = FluentDelta();
   
   mmFluentDelta
      .withRealAccount(eREAL_ACCOUNT)
      .withDelta(eMM_FLUENT_DELTA_DELTA)
      .withLotsCountMin(eMIN_LOT)
      .withDepositStart(eMM_FLUENT_DELTA_DEPOSIT_START)
      .withSwitcher(eMM_FLUENT_DELTA_SWITCHER)
      .withDownRate(eMM_FLUENT_DELTA_RATE_DOWN)
      .withFile(StringConcatenate("MM_FluentDelta",AccountNumber(), Symbol(), Period(),".csv"));
      
   
   
   eMIN_LOT = mmFluentDelta.initLotsCountMin(eMIN_LOT);
   
   if(eMM_FLUENT_DELTA)
      mmFluentDelta.initFromFile();
  
   
   orderBuy
      .withLots(eMIN_LOT);
      
   orderSell
      .withLots(eMIN_LOT);
      
   //--------------------------TRAILING STOP WITH MOVING AVERAGE------------
   stopBuyLineMA = new MovingAverage();
   stopBuyLineMA
      .withSymbol(Symbol())
      .withTimeframe(ChartPeriod(0))
      .withPeriod(eTSTOP_MA_PERIOD)
      .withPriceShift(-eTSTOP_MA_PRICE_SHIFT)
      .withMethod(eTSTOP_MA_METHOD)
      .withPrice(PRICE_LOW)
      .withColor(clrGreen);
      
   stopSellLineMA = new MovingAverage();
   stopSellLineMA
      .withSymbol(Symbol())
      .withTimeframe(ChartPeriod(0))
      .withPeriod(eTSTOP_MA_PERIOD)
      .withPriceShift(eTSTOP_MA_PRICE_SHIFT)
      .withMethod(eTSTOP_MA_METHOD)
      .withPrice(PRICE_HIGH)
      .withColor(clrWhite);
   
   //--------------------------TRAILING STOP WITH SAR-----------------------
   buyStopLossSAR = new Sara();
   buyStopLossSAR
      .withSymbol(Symbol())
      .withTimeframe(ChartPeriod(0))
      .withStep(eTLOSS_SAR_STEP)
      .withMax(eTLOSS_SAR_MAX)
      .withPriceShift(-eTLOSS_SAR_PRICE_SHIFT);
     
   sellStopLossSAR = new Sara();
   sellStopLossSAR
      .withSymbol(Symbol())
      .withTimeframe(ChartPeriod(0))
      .withStep(eTLOSS_SAR_STEP)
      .withMax(eTLOSS_SAR_MAX)
      .withPriceShift(eTLOSS_SAR_PRICE_SHIFT);
   
   //--------------------------TRAILING PROFIT WITH SAR-----------------------
   buyStopLossBB = new BollingerBands();
   buyStopLossBB
      .withSymbol(Symbol())
      .withTimeframe(ChartPeriod(0))
      .withPeriod(eTLOSS_BB_PERIOD)
      .withDeviation(eTLOSS_BB_DEVIATION)
      .withPriceShift(eTLOSS_BB_PRICE_SHIFT)
      .withLineNumber(MODE_LOWER);
      
   sellStopLossBB = new BollingerBands();
   sellStopLossBB
      .withSymbol(Symbol())
      .withTimeframe(ChartPeriod(0))
      .withPeriod(eTLOSS_BB_PERIOD)
      .withDeviation(eTLOSS_BB_DEVIATION)
      .withPriceShift(-eTLOSS_BB_PRICE_SHIFT)
      .withLineNumber(MODE_UPPER);
   
   EventSetTimer(60);
   
   return(INIT_SUCCEEDED);
   }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   Print("SELL: ", orderSell.getOpenPrice());
   Print("BUY: ", orderBuy.getOpenPrice());
//--- destroy timer
//EventKillTimer();

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
