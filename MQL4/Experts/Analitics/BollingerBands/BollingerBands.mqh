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
   double            deviation_count;        // кол-во стандартных отклонений
   int               price_shift;      // сдвиг относительно цены
   ENUM_APPLIED_PRICE price_type; // тип цены
   int               line_number;             // индекс линии
   
public:
                     BollingerBands();

                     BollingerBands( string symbol_in, ENUM_TIMEFRAMES timeframe_in,int priod_in, 
                                     double deviation_count_in, int price_shift,int time_shift);
   double            BollingerBands::GetPrice(int candle_number_in);

   short             Direction(int candle_first, int candle_second);
               
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
//|                                                                  |
//+------------------------------------------------------------------+
BollingerBands::BollingerBands( string symbol_in, ENUM_TIMEFRAMES timeframe_in,int period_in, 
                                double deviation_count_in, int price_shift_in,int time_shift_in){
   symbol = symbol_in;
   timeframe = timeframe_in;
   period = period_in;
   deviation_count=deviation_count_in;
   price_shift=price_shift_in;
   time_shift=time_shift_in;
  }
//+------------------------------------------------------------------+
double BollingerBands::GetPrice(int candle_number_in){
   return (iBands(symbol, timeframe, period, deviation_count, 0, price_type, line_number, candle_number_in) + price_shift*Point);
}//+------------------------------------------------------------------+

short BollingerBands::Direction(int candle_first, int candle_second){
   if(candle_first<candle_second){
      if(this.GetPrice(candle_first) < this.GetPrice(candle_second)) return (-1);
      if(this.GetPrice(candle_first) > this.GetPrice(candle_second)) return (1);
      }
   return (0);
}