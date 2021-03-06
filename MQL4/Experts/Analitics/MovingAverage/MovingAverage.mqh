//+------------------------------------------------------------------+
//|                                            MovingAverage.mqh |
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
class MovingAverage
  {
private:
   string            symbol;
   ENUM_TIMEFRAMES   timeframe;
   int               period;
   int               priceShift; //в пунктаз
   ENUM_MA_METHOD    method;
   ENUM_APPLIED_PRICE priceType;
   color             lineColor;
   short             direction; 
public:
                     MovingAverage();
                     MovingAverage(string symbol_in,ENUM_TIMEFRAMES timeframe_in,int period_in,int priceShift_in,ENUM_MA_METHOD method_in,ENUM_APPLIED_PRICE priceType_in,color lineColor_in);
   double            price(int candleNumber);
   double            getConor(int candleNumber);
   double            getPeak(int candleNumber);
   short             directionForCandles(int firstCandle, int canle_second); //Направление линии :-1 вниз, 0 - горизонталь, 1 - вверх
   MovingAverage     *withSymbol(string symbolIn)                    {this.symbol = symbolIn;         return GetPointer(this);}
   MovingAverage     *withTimeframe(ENUM_TIMEFRAMES timeframeIn)     {this.timeframe = timeframeIn;   return GetPointer(this);}          
   MovingAverage     *withPeriod(int periodIn)                       {this.period = periodIn;         return GetPointer(this);}
   MovingAverage     *withPriceShift(int priceShiftIn)               {this.priceShift = priceShiftIn; return GetPointer(this);}        
   MovingAverage     *withMethod(ENUM_MA_METHOD methodIn)            {this.method = methodIn;         return GetPointer(this);}
   MovingAverage     *withPrice(ENUM_APPLIED_PRICE priceTypeIn)      {this.priceType = priceTypeIn;   return GetPointer(this);}
   MovingAverage     *withColor(color lineColorIn)                   {this.lineColor = lineColorIn;   return GetPointer(this);}
   
                    ~MovingAverage();

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

MovingAverage::MovingAverage() {

  }
  
MovingAverage::MovingAverage(string symbol_in,ENUM_TIMEFRAMES timeframe_in,int period_in,int priceShift_in,ENUM_MA_METHOD method_in,ENUM_APPLIED_PRICE priceType_in,color lineColor_in){
   this.symbol = symbol_in;
   this.timeframe = timeframe_in;
   this.period = period_in;
   this.priceShift = priceShift_in;
   this.method = method_in;
   this.priceType = priceType_in;
   this.lineColor = lineColor_in;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MovingAverage::~MovingAverage()
  {
  }
//+------------------------------------------------------------------+
double MovingAverage::price(int candle_number_in){
   double price = iMA(symbol, timeframe, period, 0, method, priceType, candle_number_in)+priceShift*Point;
   
   return price;
  }

short MovingAverage::directionForCandles(int firstCandle, int secondCandle){
   if(firstCandle<secondCandle){
      if(this.price(firstCandle) < this.price(secondCandle)) return (-1);
      if(this.price(firstCandle) > this.price(secondCandle)) return (1);
      }
   return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
