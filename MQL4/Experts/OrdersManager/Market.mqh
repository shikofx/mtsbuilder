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
   bool              isNewMinute();
   bool              isNew5Minutes();
   bool              isNew15Minutes();
   bool              isNewHour();
   bool              isNew4Hour();
   bool              isNewDau();
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

bool Market::isNewMinute(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   if(TimeMinute(timeCurrent) > TimeMinute(this.openTimeM1)){
      this.openTimeM1 = timeCurrent;
      isNew = true;
   }
   return isNew;
}

//bool Market::isNew5Minutes(){
//   bool isNew = false;
//   datetime timeCurrent = TimeCurrent();
//   if(TimeMonth(timeCurrent) > TimeMonth(this.openTimeMnth)){
//      this.openTimeMnth = timeCurrent;
//      isNew = true;
//   }
//   return isNew;
//}

//bool Market::isNew15Minutes(){
//   bool isNew = false;
//   datetime timeCurrent = TimeCurrent();
//   if(TimeMonth(timeCurrent) > TimeMonth(this.openTimeMnth)){
//      this.openTimeMnth = timeCurrent;
//      isNew = true;
//   }
//   return isNew;
//}

bool Market::isNewHour(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   if(TimeHour(timeCurrent) > TimeHour(this.openTimeH1)){
      this.openTimeH1 = timeCurrent;
      isNew = true;
   }
   return isNew;
}

//bool Market::isNew4Hour(){
//   bool isNew = false;
//   datetime timeCurrent = TimeCurrent();
//   if(TimeMonth(timeCurrent) > TimeMonth(this.openTimeMnth)){
//      this.openTimeMnth = timeCurrent;
//      isNew = true;
//   }
//   return isNew;
//}

bool Market::isNewDay(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   if(TimeDay(timeCurrent) > TimeDayOfYear(this.openTimeD1)){
      this.openTimeD1 = timeCurrent;
      isNew = true;
   }
   return isNew;
}

//bool Market::isNewWeek(){
//   bool isNew = false;
//   datetime timeCurrent = TimeCurrent();
//   if(TimeMonth(timeCurrent) > TimeMonth(this.openTimeMnth)){
//      this.openTimeMnth = timeCurrent;
//      isNew = true;
//   }
//   return isNew;
//}

bool Market::isNewMonth(){
   bool isNew = false;
   datetime timeCurrent = TimeCurrent();
   if(TimeMonth(timeCurrent) > TimeMonth(this.openTimeMnth)){
      this.openTimeMnth = timeCurrent;
      isNew = true;
   }
   return isNew;
}

//+------------------------------------------------------------------+
