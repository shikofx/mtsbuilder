//+------------------------------------------------------------------+
//|                                             ЛинииБоуленджера.mqh |
//|                                Инвестиционная группа Витязи Духа |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Инвестиционная группа Витязи Духа"
#property link      ""
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BollingerBands
  {
private:
   string            symbol;
   ENUM_TIMEFRAMES   timeframe;
   int               period; //период
   double            deviation;        // кол-во стандартных отклонений
   int               priceShift;      // сдвиг относительно цены
   ENUM_APPLIED_PRICE priceType; // тип цены
   int               lineNumber;             // индекс линии
   int               timeShift;
   
public:
                     BollingerBands();
 
   BollingerBands    *withSymbol(string symbolIn)                    {this.symbol = symbolIn; return GetPointer(this);}
   BollingerBands    *withTimeframe(ENUM_TIMEFRAMES timeframeIn)     {this.timeframe = timeframeIn; return GetPointer(this);}
   BollingerBands    *withPeriod(int periodIn)                       {this.period = periodIn; return GetPointer(this);}
   BollingerBands    *withDeviation(double deviationIn)              {this.deviation = deviationIn; return GetPointer(this);}
   BollingerBands    *withPriceShift(int priceShiftIn)               {this.priceShift = priceShiftIn; return GetPointer(this);}
   BollingerBands    *withTimeShift(int timeShiftIn)                 {this.timeShift = timeShiftIn; return GetPointer(this);}
   BollingerBands    *withLineNumber(int lineNumberIn)               {this.lineNumber = lineNumberIn; return GetPointer(this);}
   BollingerBands    *withPriceType(ENUM_APPLIED_PRICE priceTypeIn)  {this.priceType = priceTypeIn; return GetPointer(this);}
   double            price(int candleNumberIn);  

   short             directionForCandles(int candleShiftIn);
   short             directionForCandles(int candleFirst, int candleSecond);
               
                    ~BollingerBands();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BollingerBands::BollingerBands()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BollingerBands::~BollingerBands()
  {

  }
//+------------------------------------------------------------------+
double BollingerBands::price(int candleNumberIn){
   return iBands(symbol, timeframe, period, deviation, 0, priceType, lineNumber, candleNumberIn) + priceShift*Point;
}//+------------------------------------------------------------------+

short BollingerBands::directionForCandles(int candleFirst, int candleSecond){
   if(candleFirst<candleSecond){
      if(this.price(candleFirst) < this.price(candleSecond)) return (-1);
      if(this.price(candleFirst) > this.price(candleSecond)) return (1);
      }
   return (0);
}