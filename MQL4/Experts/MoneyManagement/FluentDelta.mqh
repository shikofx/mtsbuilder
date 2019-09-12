//+------------------------------------------------------------------+
//|                                                  FluentDelta.mqh |
//|                                                        PKT GROUP |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "PKT Group"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class FluentDelta
  {
private:
   double            lotsCount;
   double            lotsCountTemp;
   double            lotsCountMin;
   double            lotsCountMax;
   int               switcher;
   double            depositStart;
   double            depositTemp;
   double            depositCurrent;
   double            depositDown;
   double            freeMoney;
   double            decreasingRate;
   double            delta;
   double            levelNumber;
   string            fileName;

public:
                     FluentDelta();
                     FluentDelta(int switcherIn, double depositStartIn, double lotsCountIn, double decreasingRate, double deltaIn);
   FluentDelta       *withFile(string fileNameIn)             {this.fileName = fileNameIn; return GetPointer(this);                }
   FluentDelta       *withSwitcher(int switcherIn)             {this.switcher = switcherIn; return GetPointer(this);                }
   FluentDelta       *withDepositStart(double depositStartIn)  {this.depositStart = depositStartIn; return GetPointer(this);        }
   FluentDelta       *withLotsCount(double lotsCountIn)        {this.lotsCount = lotsCountIn; return GetPointer(this);              }
   double            lotMin(double lotMinIn);
   FluentDelta       *withDecreasingRate(double decreasingRateIn){this.decreasingRate = decreasingRateIn; return GetPointer(this);  }
   FluentDelta       *withDelta(double deltaIn)                {this.delta = deltaIn; return GetPointer(this);                      }
   double            traidingLots();
                    ~FluentDelta();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FluentDelta::FluentDelta(void){
   lotsCountMax = MarketInfo(Symbol(),MODE_MAXLOT);
   lotsCountTemp = 0;
   depositTemp = 0;
   depositCurrent = 0;
   depositDown = 0;
   freeMoney = 0;
   levelNumber = 0;
}

//double FluentDelta::withLotMin(double lotMinIn){
//   if(lotMinIn == 0)
//       return MarketInfo(Symbol(), MODE_MINLOT);
//   else
//       return lotMinIn;
//}

FluentDelta::FluentDelta(int switcherIn, double depositStartIn,double lotsCountIn,double decreasingRateIn,double deltaIn){
   switcher = switcherIn;
   depositStart = depositStartIn;
   lotsCountMin =  lotsCountIn;
   decreasingRate = decreasingRateIn;
   delta = deltaIn;
   lotsCount = lotsCountIn;
   lotsCountMax = MarketInfo(Symbol(),MODE_MAXLOT);
   lotsCountTemp = 0;
   depositTemp = 0;
   depositCurrent = 0;
   depositDown = 0;
   freeMoney = 0;
   levelNumber = 0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FluentDelta::~FluentDelta()
  {
  }
//+------------------------------------------------------------------+
double FluentDelta::traidingLots() {
   if(delta != 0){
      depositCurrent = AccountBalance();
      //------------------------1. переключатель ОБЪЕМОВ-------------------------
      if(depositCurrent >= 2 * switcher * depositStart) { //когда текущий объем больше начального в 20 раз
         for(int i = 1; i <= 10; i++){
            double newDepositStart = MathPow(switcher,i)*MathPow(2,i)*depositStart;            
            if(depositCurrent >= newDepositStart) {
               depositStart = newDepositStart; //меняем планку начального объема
               lotsCountMin = MathPow(switcher, i) * lotsCountMin; //меняем минимальный шаг 
               delta = MathPow(switcher,i) * delta;  //меняем дельту
              }
         }
      }
      //-------------------------2. ПРЯМОЙ ХОД-------------------------------------
      if(depositCurrent >= depositStart){
         lotsCount = lotsCountMin *(MathFloor(0.5*(1+MathSqrt(1+8*(depositCurrent-depositStart)/delta))));
      } else {
         lotsCount = lotsCountMin;
      }

      //------------------------3. РАСЧЕТ ВЫСВОБОЖДЕННЫХ СРЕДСТВ
      if(lotsCount>lotsCountTemp) {
         levelNumber = MathFloor(lotsCount / lotsCountMin);
         freeMoney = 0.5*delta*levelNumber * (levelNumber-1) * (1-decreasingRate);
         depositDown = depositStart + freeMoney;
         lotsCountTemp = lotsCount; //только при повышении объемов
      }

      //------------------------4. ОБРАТНЫЙ ХОД----------------------------------------
      if(depositTemp>depositCurrent && lotsCount >= 2*lotsCountMin){
         lotsCount = lotsCountMin * (MathFloor(0.5 * (1 + MathSqrt(1 + 8 * (depositCurrent - depositDown) / (delta * decreasingRate)))));
         depositStart = depositDown;
      }
      depositTemp = depositCurrent;   //временно хранит последний уровень объемов

      if(lotsCount < lotsCountMin)
         lotsCount = lotsCountMin;
      if(lotsCount >=  lotsCountMax)
         lotsCount = lotsCountMax;
   } else {
      lotsCount = lotsCountMin;
   }
   
   return lotsCount;
}
//+------------------------------------------------------------------+
