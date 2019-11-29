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




extern   int               eMAGIC_NUMBER = 10000;        //System ID
extern   string            eORDER_COMMENT = "";          //Order's comment
extern   ENUM_ORDER_TYPE   eSTART_ORDER_TYPE = OP_SELL;  //Start direction? - BUY/SELL
extern   bool              eREAL_ACCOUNT = false;        //Is it real trade? (ведется запись в файл)
extern   double            eSTART_OPEN_PRICE = 0.0;      //Start open price (0 - if current or no one order)

extern bool       eMM_FLUENT_DELTA = true;               //MM switcher?
extern double     eMIN_LOT = 0.1;                        //MM Minimal lot step
extern int        eMM_FLUENT_DELTA_SWITCHER = 4;         //MM Minimal lot swither
extern double     eMM_FLUENT_DELTA_DEPOSIT_START = 300;  //MM Start deposit
extern int        eMM_FLUENT_DELTA_DELTA = 60;           //MM Fluent DELTA rate
extern double     eMM_FLUENT_DELTA_RATE_DOWN = 1.0;      //MM After rate down

extern   int   eDELAY = 0;                      //Delay
extern   bool  eMASK = false;                   //Mask switcher?
extern   int   eMASK_SLIPPAGE = 100;            //Mask area 100 points => Random от -100 до 100
extern   int   eCLOSE_SLIPPAGE = 50;            //Close order slippage
extern   int   eMASK_DELTA_STOP_LOSS = 500;     //Distance from real stop loss
extern   int   eMASK_DELTA_TAKE_PROFIT = 1000;  //Distance from real take profit

extern   bool  eSYNCHRONOUS = true;          //ONLY ONE ORDER IN TRADE? (Sell or Buy)
extern   bool  eOPEN_AFTER_PROFIT = false;   //Open next after profit?
extern   int   eMAX_STOP_LOSS = 1500;        //Maximal loss distance
extern   int   eMIN_TAKE_PROFIT = 1600;      //Maximal profit distance

//**********TRAILING STOP Parabolic SAR 
extern   bool     eTLOSS_SAR              = true;     //SAR LOSS SWITHER
extern   double   eTLOSS_SAR_STEP         = 0.0006;   //SAR LOSS Step 
double            eTLOSS_SAR_MAX          = 2;        //SAR LOSS MAX
extern   int      eTLOSS_SAR_PRICE_SHIFT  = 400;      //SAR LOSS Price shift
extern   int      eTLOSS_SAR_BAR_SHIFT    = 2;        //SAR LOSS Bar shift

//**********TRAILING STOP BollingerBands 
extern   bool     eTLOSS_BB               = false;          //BB LOSS SWITHER
extern   ENUM_TIMEFRAMES eTLOSS_BB_TIMEFRAME = PERIOD_M15;  //BB LOSS Timeframe
extern   int      eTLOSS_BB_PERIOD          = 60;           //BB LOSS Period
extern   double   eTLOSS_BB_DEVIATION       = 2;            //BB LOSS Deviation
extern   int      eTLOSS_BB_PRICE_SHIFT   = 400;            //BB LOSS Price shift
extern   int      eTLOSS_BB_BAR_SHIFT     = 2;              //BB LOSS Bar shift

//**********TRAILING MovingAverage
extern   bool           eTSTOP_MA                  = false; //MA SWITHER
extern   int            eTSTOP_MA_PERIOD           = 10;    //MA Period
extern   int            eTSTOP_MA_PRICE_SHIFT      = 300;   //MA Price shift
extern   ENUM_MA_METHOD eTSTOP_MA_METHOD  = 1;              //MA Method
extern   int            eTSTOP_MA_BAR_SHIFT        = 1;     //MA Bar shift

//Парциальная торговля
extern   int   eMAX_LOSSES_COUNT = 4; //DOSE TRADE Orders count
extern   double eMAX_LOSS = 1600; //DOSE TRADE What is loss?
extern   double eWEIGHT_0 = 2; //After 1 loss order
extern   double eWEIGHT_1 = 2; //After 2 loss order
extern   double eWEIGHT_2 = 1; //After 3 loss order
extern   double eWEIGHT_3 = 3; //After 4 loss order
extern   double eWEIGHT_4 = 1; //After 5 loss order
extern   double eWEIGHT_5 = 1; //After 6 loss order
extern   double eWEIGHT_6 = 1; //After 7 loss order
extern   double eWEIGHT_7 = 1; //After 8 loss order
extern   double eWEIGHT_8 = 1; //After 9 loss order
extern   double eWEIGHT_9 = 1; //After 10 loss order 
extern   double eWEIGHT_10 = 1; //After 11 loss order
extern   double eWEIGHT_11 = 1; //After 12 loss order
extern   double eWEIGHT_12 = 1; //After 13 loss order
extern   double eWEIGHT_13 = 1; //After 14 loss order
extern   double eWEIGHT_14 = 1; //After 15 loss order

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
            "\nFREE money: " + DoubleToString(mmFluentDelta.getFreeMoney(), 1) +
            "\nSART deposit: " + DoubleToString(mmFluentDelta.getStartDepo(), 0) +
            "\n\nCurrent LOTS: " + DoubleToString(mmFluentDelta.getLotsCount(), 2) +
            "\n--------------------------------------";
            
   if(orderBuy.isOpened()){
      commentString += "\n\n\nBUY #" + IntegerToString(orderBuy.getTicket()) + ": " + orderBuy.isOpened() + 
            "\n-------------------MASK-------------------" + 
            "\nMask LOSS = " + DoubleToString(orderBuy.getStopLossMaskPrice(), 5) + 
            "\nMask PROFIT = " + DoubleToString(orderBuy.getTakeProfitMaskPrice(), 5) +
            "\n\n-------------------REAL-------------------" +
            "\n\nReal LOSS = " + DoubleToString(orderBuy.getStopLossPrice(), 5) + 
            "\nReal PROFIT = " + DoubleToString(orderBuy.getTakeProfitPrice(), 5);   
   }
   
   if(orderSell.isOpened()){
      commentString += "\n\n\nSELL #" + IntegerToString(orderSell.getTicket()) + ": " + orderSell.isOpened() + 
            "\n-------------------MASK-------------------" + 
            "\nMask LOSS = " + DoubleToString(orderSell.getStopLossMaskPrice(), 5) +
            "\nMask PROFIT = " + DoubleToString(orderSell.getTakeProfitMaskPrice(), 5) + 
            "\n\n-------------------REAL-------------------"
            "\nReal LOSS = " + DoubleToString(orderSell.getStopLossPrice(), 5) + 
            "\nReal PROFIT = " + DoubleToString(orderSell.getTakeProfitPrice(), 5);
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
