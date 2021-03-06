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
   int               priceShift; //на сколько пунктов цены вверх (+) или вниз (-)
   double            currentPrice;
public:
                     Sara();
                     
   Sara              *withSymbol(string symbolIn)                 {this.symbol = symbolIn;    return GetPointer(this);        } 
   Sara              *withTimeframe(ENUM_TIMEFRAMES timeframeIn)  {this.timeframe = timeframeIn;    return GetPointer(this);  }       
   Sara              *withStep(double stepIn)                     {this.step = stepIn;    return GetPointer(this);            } 
   Sara              *withMax(double maximumIn)               {this.maximum = maximumIn;    return GetPointer(this);      } 
   Sara              *withPriceShift(int priceShiftIn)            {this.priceShift = priceShiftIn;    return GetPointer(this);}
                    ~Sara();
   double            price(int candleNumber);
   double            GetConor(int candleNumber);
   double            GetPeak(int candleNumber);
   short             directionForCandles(int firstCandle, int secondCandle);
   string            getSymbol() {return symbol;}
   double            getStep() {return step;}
   double            getMaximum() {return maximum;}
   double            getPriceShift() {return priceShift;}
   string            toString();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Sara::Sara(){
  }

Sara::~Sara(){
  }
  
double Sara::price(int candleNumberIn){
   this.currentPrice = iSAR(symbol, timeframe, step, maximum, candleNumberIn) + priceShift*Point;
   return currentPrice;
   }

short Sara::directionForCandles(int firstCandle, int secondCandle){
   if(firstCandle < secondCandle){
      if(this.price(firstCandle) < this.price(secondCandle)) return (-1);
      if(this.price(firstCandle) > this.price(secondCandle)) return (1);
      }
   return (0);
}

string Sara::toString(void){
   string strTmp = "";
   strTmp += "symbol = " + symbol + "; ";    
   strTmp += "timeframe = " + EnumToString(timeframe) + "; ";
   strTmp += "step = " + DoubleToString(step) + "; ";
   strTmp += "priceShift = " + DoubleToString(priceShift) + "; ";
   strTmp += "currentPrice = " + DoubleToString(currentPrice) + "; ";
   return strTmp;
}