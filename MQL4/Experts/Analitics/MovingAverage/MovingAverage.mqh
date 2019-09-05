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
   int               price_shift; //в пунктаз
   ENUM_MA_METHOD    method;
   ENUM_APPLIED_PRICE priceType;
   color             lineColor;
   short             direction; 
public:
                     MovingAverage();
                     MovingAverage(string symbol_in,ENUM_TIMEFRAMES timeframel_in,int periodl_in,int price_shift_in,ENUM_MA_METHOD method_in,ENUM_APPLIED_PRICE priceType_in,color lineColor_in);
   double            GetPrice(int _candle_number);
   double            GetConor(int _candle_number);
   double            GetPeak(int _candle_number);
   short             Direction(int candle_first, int canle_second); //Направление линии :-1 вниз, 0 - горизонталь, 1 - вверх

                    ~MovingAverage();

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MovingAverage::MovingAverage()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MovingAverage::MovingAverage( string symbol_in, ENUM_TIMEFRAMES timeframel_in, int periodl_in,
                              int price_shift_in,ENUM_MA_METHOD method_in,
                              ENUM_APPLIED_PRICE priceType_in,color lineColor_in)
  {
   symbol=symbol_in;
   timeframe=timeframel_in;
   period=periodl_in;
   price_shift=price_shift_in;
   method=method_in;
   priceType=priceType_in;
   lineColor=lineColor_in;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MovingAverage::~MovingAverage()
  {
  }
//+------------------------------------------------------------------+
double MovingAverage::GetPrice(int candle_number_in){
   double price = iMA(symbol, timeframe, period, 0, method, priceType, candle_number_in)+price_shift*Point;
   Comment("iMAprice = " + price);
   return price;
  }

short MovingAverage::Direction(int candle_first, int candle_second){
   if(candle_first<candle_second){
      if(this.GetPrice(candle_first) < this.GetPrice(candle_second)) return (-1);
      if(this.GetPrice(candle_first) > this.GetPrice(candle_second)) return (1);
      }
   return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
