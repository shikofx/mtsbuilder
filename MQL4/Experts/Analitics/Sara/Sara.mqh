//+------------------------------------------------------------------+
//|                                                         Sara.mqh |
//|                                  Пархейчук Дмитрий Александрович |
//|                                                           pkt.by |
//+------------------------------------------------------------------+
#property copyright "Пархейчук Дмитрий Александрович"
#property link      "pkt.by"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Sara
  {
private:
   string            symbol;
   ENUM_TIMEFRAMES   timeframe;
   double            step; //0.02
   double            maximum; //0.2
   int               price_shift; //на сколько пунктов цены вверх (+) или вниз (-)

public:
                     Sara();
                     Sara(string symbol_in, ENUM_TIMEFRAMES timeframe_in, double step_in, double maximum_in, int price_shift_in);
                    ~Sara();
   double            GetPrice(int _candle_number);
   double            GetConor(int _candle_number);
   double            GetPeak(int _candle_number);
   short             Direction(int candle_first, int candle_second);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Sara::Sara(){
  }

Sara::Sara(string symbol_in, ENUM_TIMEFRAMES timeframe_in, double step_in, double maximum_in, int price_shift_in){
   symbol = symbol_in;
   timeframe = timeframe_in;
   step = step_in; //0.02
   maximum = maximum_in; //0.2
   price_shift = price_shift_in; //на сколько пунктов цены вверх (+) или вниз (-)
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Sara::~Sara(){
  }
  
double Sara::GetPrice(int candle_number_in){
   return (iSAR(symbol, timeframe, step, maximum, candle_number_in) + price_shift*Point);
   }

short Sara::Direction(int candle_first, int candle_second){
   if(candle_first<candle_second){
      if(this.GetPrice(candle_first) < this.GetPrice(candle_second)) return (-1);
      if(this.GetPrice(candle_first) > this.GetPrice(candle_second)) return (1);
      }
   return (0);
}