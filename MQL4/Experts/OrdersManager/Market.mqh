//+------------------------------------------------------------------+
//|                                                       Market.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict


class Market
  {
private: 
   int magicNumber;
   int size;
   datetime openTimeM1;
   datetime openTimeM5;
   datetime openTimeM15;
   datetime openTimeM30;
   datetime openTimeH1;
   datetime openTimeH4;
   datetime openTimeD1;
   datetime openTimeW1;
   datetime openTimeMnth;
   
public:
                     Market();
                     Market(int magicNumberIn);
                    ~Market();
   bool              isChanged();
   bool              isEmpty();
   bool              isNew(int timeframe);
   bool              isNewMinute();
   bool              isNew5Minutes();
   bool              isNew15Minutes();
   bool              isNew30Minutes();
   bool              isNewHour();
   bool              isNew4Hour();
   bool              isNewDay();
   bool              isNewWeek();
   bool              isNewMonth();
   int               count();
   int               getSize();
   
  };
Market::Market(){
   this.openTimeM1 = 0;
   this.openTimeM5 = 0;
   this.openTimeM15 = 0;
   this.openTimeM30 = 0;
   this.openTimeH1 = 0;
   this.openTimeH4 = 0;
   this.openTimeD1 = 0;
   this.openTimeW1 = 0;
   this.openTimeMnth = 0;
   
   this.size = OrdersTotal();
  }
  
Market::Market(int magicNumberIn){
   this.size = this.count();
   this.magicNumber = magicNumberIn;
}

Market::~Market()
  {
  }
  
int Market::getSize(void){
   return this.size = this.count();
}
   
bool Market::isChanged(void){
   int counter = this.count();
   if(counter > this.size) {
      this.size = counter;
      return true;
   }   
   return false;
}

bool Market::isEmpty(){
   if(this.getSize() == 0)
      return true;
   return false;
}

int Market::count(){
   int counter = 0;
   
   if(OrdersTotal() > 0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderMagicNumber() == magicNumber)
            counter++;         
      }
   }
   return counter;
}

bool Market::isNew(int timeframe){
   bool isNew = false;
   switch(timeframe){
      case PERIOD_M1:
         isNew = this.isNewMinute();
         break;
      case PERIOD_M5:
         isNew = this.isNew5Minutes();
         break;
      case PERIOD_M15:
         isNew = this.isNew15Minutes();
         break;
      case PERIOD_M30:
         isNew = this.isNew30Minutes();
         break;
      case PERIOD_H1:
         isNew = this.isNewHour();
         break;
      case PERIOD_H4:
         isNew = this.isNew4Hour();
         break;
      case PERIOD_D1:
         isNew = this.isNewDay();
         break;
      case PERIOD_W1:
         isNew = this.isNewWeek();
         break;
      case PERIOD_MN1:
         isNew = this.isNewMonth();
         break;
   }
   return isNew;
}

bool Market::isNewMinute(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();

   if(TimeHour(timeCurrent) > TimeHour(this.openTimeM1) ||
      TimeDayOfYear(timeCurrent) > TimeDayOfYear(this.openTimeM1) || 
      TimeMonth(timeCurrent) > TimeMonth(this.openTimeM1) ||
      TimeMinute(timeCurrent) > TimeMinute(this.openTimeM1)){
         this.openTimeM1 = timeCurrent;
         isNew = true;
   }

   return isNew;
}

bool Market::isNew5Minutes(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   
   int current5Minute = (int) MathFloor(TimeMinute(timeCurrent)/12);
   int last5Minute = (int) MathFloor(TimeMinute(timeCurrent)/12);
   
   if(TimeHour(timeCurrent) > TimeHour(this.openTimeM5) ||
      TimeDayOfYear(timeCurrent) > TimeDayOfYear(this.openTimeM5) || 
      TimeMonth(timeCurrent) > TimeMonth(this.openTimeM5) || 
      current5Minute > last5Minute){
         this.openTimeM5 = timeCurrent;
         isNew = true;
   }

   return isNew;
}

bool Market::isNew15Minutes(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   int current15Minute = (int) MathFloor(TimeMinute(timeCurrent)/4);
   int last15Minute = (int) MathFloor(TimeMinute(openTimeM15)/4);
         
   if(TimeHour(timeCurrent) > TimeHour(this.openTimeM15) ||
      TimeDayOfYear(timeCurrent) > TimeDayOfYear(this.openTimeM15) || 
      TimeMonth(timeCurrent) >  TimeMonth(this.openTimeM15) ||
      current15Minute > last15Minute){
         this.openTimeM15 = timeCurrent;
         isNew = true;   
   }
   return isNew;
}

bool Market::isNew30Minutes(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   int current30Minute = (int) MathFloor(TimeMinute(timeCurrent)/2);
   int last30Minute = (int) MathFloor(TimeMinute(openTimeM30)/2);
   
   if(TimeHour(timeCurrent) > TimeHour(this.openTimeM30) ||
      TimeDayOfYear(timeCurrent) > TimeDayOfYear(this.openTimeM30) || 
      TimeMonth(timeCurrent) > TimeMonth(this.openTimeM30) ||
      current30Minute > last30Minute){
         this.openTimeM30 = timeCurrent;
         isNew = true;
      
      
   }
   return isNew;
}

bool Market::isNewHour(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
  
   if(TimeDayOfYear(timeCurrent) > TimeDayOfYear(this.openTimeH1) || 
      TimeMonth(timeCurrent) > TimeMonth(this.openTimeH1) || 
      TimeHour(timeCurrent) > TimeHour(this.openTimeH1)){
      this.openTimeH1 = timeCurrent;
      isNew = true;
   }
   
   return isNew;
}

bool Market::isNew4Hour(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   int current4Hours = (int) MathFloor(TimeHour(timeCurrent)/6);
   int last4Hours = (int) MathFloor(TimeHour(timeCurrent)/6);
   if(TimeDayOfYear(timeCurrent) > TimeDayOfYear(this.openTimeH4) || 
      TimeMonth(timeCurrent) > TimeMonth(this.openTimeH4) || 
      current4Hours > last4Hours){
      this.openTimeH4 = timeCurrent;
      isNew = true;
   }
   return isNew;
}

bool Market::isNewDay(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   if(TimeDay(timeCurrent) > TimeDayOfYear(this.openTimeD1)){
      this.openTimeD1 = timeCurrent;
      isNew = true;
   }
   return isNew;
}

bool Market::isNewWeek(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   if(TimeDayOfYear(timeCurrent) > TimeDayOfYear(openTimeD1) &&
      TimeDayOfWeek(timeCurrent) == 1){
      this.openTimeW1 = timeCurrent;
      isNew = true;
   }
   return isNew;
}

bool Market::isNewMonth(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   if(TimeMonth(timeCurrent) > TimeMonth(this.openTimeMnth) || TimeYear(timeCurrent) > TimeYear(openTimeMnth)){
      this.openTimeMnth = timeCurrent;
      isNew = true;
   }
   return isNew;
}

//+------------------------------------------------------------------+
