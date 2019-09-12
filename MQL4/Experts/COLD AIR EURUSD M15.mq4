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
#include "OrdersManager/History.mqh"
#include "MoneyManagement/FluentDelta.mqh"

extern   bool  eTEST_LOSSES = false;
extern   bool  eTEST_POWER = true;
extern   bool  eSYNCHRONOUS = true;
extern   bool  eOPEN_AFTER_PROFIT = false;
extern   int   eMAX_STOP_LOSS = 1500;
extern   int   eMIN_TAKE_PROFIT = 1600;

//---

//**********TRAILING STOP Parabolic SAR 
extern   bool     eTLOSS_SAR              = true;
extern   double   eTLOSS_SAR_STEP         = 0.0006; 
double            eTLOSS_SAR_MAX          = 2;  
extern   int      eTLOSS_SAR_TIME_SHIFT   = 0; 
extern   int      eTLOSS_SAR_PRICE_SHIFT  = 400; 
extern   int      eTLOSS_SAR_BAR_SHIFT    = 2; 

//**********TRAILING PROFIT Parabolic SAR 
extern   bool     eTPROFIT_SAR              = true;
extern   double   eTPROFIT_SAR_STEP         = 0.0006; 
double            eTPROFIT_SAR_MAX          = 2;  
extern   int      eTPROFIT_SAR_TIME_SHIFT   = 0; 
extern   int      eTPROFIT_SAR_PRICE_SHIFT  = 400; 
extern   int      eTPROFIT_SAR_BAR_SHIFT    = 2; 

//**********TRAILING MovingAverage
extern   bool           eTSTOP_MA                  = false;
extern   int            eTSTOP_MA_PERIOD           = 10; 
extern   int            eTSTOP_MA_PRICE_SHIFT      = 300;
extern   ENUM_MA_METHOD eTSTOP_MA_METHOD  = 1;
extern   int            eTSTOP_MA_BAR_SHIFT        = 1; 

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

extern bool       eMM_FLUENT_DELTA = true;
extern int        eMM_FLUENT_DELTA_SWITCHER = 4;

extern double     eMM_FLUENT_DELTA_DEPOSIT_START = 3500; 
extern int        eMM_FLUENT_DELTA_DELTA = 700;
extern double     eMM_FLUENT_DELTA_LOT_MIN = 0.1; 
extern double     eMM_FLUENT_DELTA_RATE_DOWN = 0.2; 

double   CurrentDepo=0, //хранит значение текущего депозита
         minLot=0,      //хранит значение минимального объема для инструмента
         StartDepo=0, rStartDepo=0, FreeDepo=0, delta=0, Lot=0, tempLot=0, tLot=0, tDepo=0;
int Experts=0, ticket=0, kLevel=0;//, distance=0, day=0, day1=0, i, j, k, n, fwrite=0;
string   mmFileName;
int MM_file_handle=0;


Buy *orderBuy;
Sell *orderSell;
OrdersBox *lossesBox;
Order ordersArray[];
History history;
MovingAverage *stopBuyLineMA;
MovingAverage *stopSellLineMA;
double weight;
double weights[15];

Sara *buyStopLossSAR;
Sara *sellStopLossSAR;

Sara *buyTakeProfitSAR;
Sara *sellTakeProfitSAR;

FluentDelta mmFluentDelta;

double OnTester() {
   double testData = 0;
   if(eTEST_LOSSES)
      testData = TesterStatistics(STAT_CONLOSSMAX_TRADES);
   if(eTEST_POWER){
      double profit=TesterStatistics(STAT_PROFIT);
      double dropdown=TesterStatistics(STAT_EQUITY_DD);
      double power = 0;
      
      if(profit <= 0)
         return power;
      if(dropdown != 0)
         power = profit/dropdown;

      testData = MathRound(power*100)/100;
   }
   return testData;
  }
//+------------------------------------------------------------------+
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
   lossesBox = new OrdersBox();
   
   //--------------------------УПРАВЛЕНИЕ СДЕЛКАМИ-----------------------
   orderBuy=new Buy();
   orderBuy
      .withMagicNumber(5)
      .withSymbol(Symbol())
      .withComment("Buy for new system")
      .withOpenColor(clrBlue)
      .withModifyColor(clrAliceBlue)
      .withStopLoss(eMAX_STOP_LOSS)
      .withTakeProfit(eMIN_TAKE_PROFIT);
   
   orderSell=new Sell();
   orderSell
      .withMagicNumber(5)
      .withSymbol(Symbol())
      .withComment("Sell for new system")
      .withOpenColor(clrRed)
      .withModifyColor(clrRosyBrown)
      .withStopLoss(eMAX_STOP_LOSS)
      .withTakeProfit(eMIN_TAKE_PROFIT);
   
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
   buyTakeProfitSAR = new Sara();
   buyTakeProfitSAR
      .withSymbol(Symbol())
      .withTimeframe(ChartPeriod(0))
      .withStep(eTPROFIT_SAR_STEP)
      .withMax(eTPROFIT_SAR_MAX)
      .withPriceShift(-eTPROFIT_SAR_PRICE_SHIFT);
     
   sellTakeProfitSAR = new Sara();
   sellTakeProfitSAR
      .withSymbol(Symbol())
      .withTimeframe(ChartPeriod(0))
      .withStep(-eTPROFIT_SAR_STEP)
      .withMax(eTPROFIT_SAR_MAX)
      .withPriceShift(eTPROFIT_SAR_PRICE_SHIFT);
   //--------------------------MONEY MANAGEMENT-----------------------------
   mmFluentDelta = FluentDelta();
   
   mmFileName = StringConcatenate("MM_",AccountNumber(), Symbol(), Period(),".csv");
   
   mmFluentDelta
      .withFile(StringConcatenate("MM_",AccountNumber(), Symbol(), Period(),".csv"));
 
   if(eMM_FLUENT_DELTA_LOT_MIN == 0){
       minLot=MarketInfo(Symbol(), MODE_MINLOT);
       eMM_FLUENT_DELTA_LOT_MIN=minLot;
   } else
       minLot=eMM_FLUENT_DELTA_LOT_MIN;
   
   delta = eMM_FLUENT_DELTA_DELTA; //Задаем начальную дельту
   StartDepo =  eMM_FLUENT_DELTA_DEPOSIT_START;   
   tLot = minLot; //Задаем текущий объем
   
   if(eMM_FLUENT_DELTA)
   {
      MM_file_handle = FileOpen(mmFileName, FILE_CSV|FILE_READ, ';');  
      if(MM_file_handle < 1)
         Print("Файл ", mmFileName, "не обнаружен. Последняя ошибка", GetLastError());   
      else
      {
         FileSeek(MM_file_handle, 0, SEEK_SET);
         Lot = FileReadNumber(MM_file_handle);         //считываем из файла Lot 
         StartDepo = FileReadNumber(MM_file_handle);   //Считываем из файла rStartDepo
         FreeDepo = FileReadNumber(MM_file_handle);    //Счиьываем из файла FreeDepo 
         FileClose(MM_file_handle);
      }
   }   

   orderBuy.withLots(eMM_FLUENT_DELTA_LOT_MIN);
   orderSell.withLots(eMM_FLUENT_DELTA_LOT_MIN);
   
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
void OnTick() {
  
   
   Order lastFromHistory = history.last();
   
   if(eSYNCHRONOUS && history.isChanged()){
      lastFromHistory = history.last();
      weight = lossesBox.getWeight(eMAX_LOSSES_COUNT, eMAX_LOSS, weights);
      orderBuy.withWeight(weight);
      orderSell.withWeight(weight);
   }
   
   
   
   
   if (!orderSell.isOpened() && 
      (!eSYNCHRONOUS ||   
      (eSYNCHRONOUS && (OrdersTotal() == 0 && 
           ((!eOPEN_AFTER_PROFIT && orderSell.isAsyncWith(lastFromHistory)) ||
            (eOPEN_AFTER_PROFIT && orderSell.isSyncWith(lastFromHistory))))))){
  
      orderSell.open();
   }

   if(!orderBuy.isOpened() && 
         (!eSYNCHRONOUS ||
         (eSYNCHRONOUS && (OrdersTotal() == 0 && 
              ((!eOPEN_AFTER_PROFIT && orderBuy.isAsyncWith(lastFromHistory)) ||
               (eOPEN_AFTER_PROFIT && orderBuy.isSyncWith(lastFromHistory))))))){
      orderBuy.open();
   }
   
  
   if(orderSell.isOpened()){
      if(eTSTOP_MA && stopSellLineMA.directionForCandles(1,2)==-1)
         orderSell.setStopLossPrice(stopSellLineMA.price(eTSTOP_MA_BAR_SHIFT));
      if(eTLOSS_SAR && sellStopLossSAR.Direction(1,2)==-1)
         orderSell.setStopLossPrice(sellStopLossSAR.price(eTLOSS_SAR_BAR_SHIFT));
         
      //if(eTPROFIT_SAR && sellTakeProfitSAR.Direction(1,2)==1)
      //   orderSell.setTakeProfitPrice(sellTakeProfitSAR.price(eTPROFIT_SAR_BAR_SHIFT));
   }
//  
   if(orderBuy.isOpened()){
      if(eTSTOP_MA && stopBuyLineMA.directionForCandles(1,2)==1)
         orderBuy.setStopLossPrice(stopBuyLineMA.price(eTSTOP_MA_BAR_SHIFT));
      if(eTLOSS_SAR && buyStopLossSAR.Direction(1,2)==1)
         orderBuy.setStopLossPrice(buyStopLossSAR.price(eTLOSS_SAR_BAR_SHIFT));
         
      //if(eTPROFIT_SAR && buyTakeProfitSAR.Direction(1,2)==-1)
      //   orderBuy.setTakeProfitPrice(buyTakeProfitSAR.price(eTPROFIT_SAR_BAR_SHIFT));
   }
   
   if(eMM_FLUENT_DELTA){
      CurrentDepo=AccountBalance();
      //------------------------1. ПЕРЕКЛЮЧАТЕЛЬ ОБЪЕМОВ-------------------------
      if(CurrentDepo >= 2*eMM_FLUENT_DELTA_SWITCHER*eMM_FLUENT_DELTA_DEPOSIT_START){ //когда текущий объем больше начального в 20 раз
         for(int i = 1; i<=10; i++)
            if(CurrentDepo >= MathPow(eMM_FLUENT_DELTA_SWITCHER, i)*MathPow(2, i)*eMM_FLUENT_DELTA_DEPOSIT_START) {
               StartDepo = MathPow(eMM_FLUENT_DELTA_SWITCHER, i)*MathPow(2,i)*eMM_FLUENT_DELTA_DEPOSIT_START; //меняем планку начального объема
               minLot = MathPow(eMM_FLUENT_DELTA_SWITCHER, i) * eMM_FLUENT_DELTA_LOT_MIN ; //меняем минимальный шаг 
               delta = MathPow(eMM_FLUENT_DELTA_SWITCHER, i) * eMM_FLUENT_DELTA_DELTA;  //меняем дельту
            }
      }
     //-------------------------2. ПРЯМОЙ ХОД-------------------------------------
      if(CurrentDepo >= StartDepo){
         Lot = minLot * (MathFloor(0.5*(1+MathSqrt(1+8*(CurrentDepo-StartDepo)/delta))));
         }
      else {
         Lot = minLot;
      }
   
      //------------------------3. РАСЧЕТ ВЫСВОБОЖДЕННЫХ СРЕДСТВ
      if(Lot > tLot){
         kLevel = (int) MathFloor(Lot/minLot);
         FreeDepo = 0.5 * delta * kLevel * (kLevel-1) * (1-eMM_FLUENT_DELTA_RATE_DOWN);
         rStartDepo = StartDepo+FreeDepo;
         tLot = Lot; //только при повышении объемов
         //FileWriteDates(mmFileName, Lot, rStartDepo, FreeDepo);
      }

      //------------------------4. ОБРАТНЫЙ ХОД----------------------------------------
      if(tDepo > CurrentDepo && Lot >= 2*minLot){
            Lot = minLot * (MathFloor(0.5*(1+MathSqrt(1+8*(CurrentDepo-rStartDepo)/(delta*eMM_FLUENT_DELTA_RATE_DOWN)))));
            StartDepo = rStartDepo;
            //FileWriteDates(mmFileName, Lot, rStartDepo, FreeDepo);
      }
      //if(Lot < tempLot) //запись данных в файл при уменьшении объема
      //   FileWriteDates(mmFileName, Lot  , rStartDepo, FreeDepo);
      tDepo = CurrentDepo;   //временно хранит последний уровень объемов
   }
   else 
      Lot = minLot;
   if(Lot >= MarketInfo(Symbol(), MODE_MAXLOT))
      Lot = MarketInfo(Symbol(), MODE_MAXLOT);

   orderBuy.withLots(Lot);
   orderSell.withLots(Lot);
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
