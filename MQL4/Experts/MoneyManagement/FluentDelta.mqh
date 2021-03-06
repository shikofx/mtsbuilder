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
   double            lotsCountMinBase;
   double            lotsCountMax;
   bool              realAccount;
   int               switcher;
   
   double            depositStartBase;
   double            depositStart;
   double            depositTemp;
   double            depositDown;
   double            depositFree;
   double            deltaBase;
   double            delta;
   double            downRate;
   double            levelNumber;
   string            fileName;
   int               fileHandle;
public:
                     FluentDelta();
   
   double            initLotsCountMin(double lotMinIn);
                     
   FluentDelta       *initFromFile();
   
   FluentDelta       *toFile();
   
   FluentDelta       *withRealAccount(bool realIn) { realAccount = realIn; return GetPointer(this); }
   FluentDelta       *withDelta(double deltaIn){
                        this.deltaBase = deltaIn; 
                        this.delta = deltaIn; 
                        return GetPointer(this);                 
                     }
   
   FluentDelta       *withLotsCountMin(double minLotIn){
                        this.lotsCountMinBase = minLotIn; 
                        this.lotsCountMin = minLotIn;
                        return GetPointer(this);   
                     }
   
   FluentDelta       *withDepositStart(double depositStartIn){
                        this.depositStart = depositStartIn; 
                        this.depositStartBase = depositStartIn;
                        return GetPointer(this);
                     }
   
   FluentDelta       *withDownRate(double downRateIn)          {this.downRate = downRateIn; return GetPointer(this);                   }
   
   FluentDelta       *withSwitcher(int switcherIn)             {this.switcher = switcherIn; return GetPointer(this);                   }
  
   FluentDelta       *withFile(string fileNameIn)             {this.fileName = fileNameIn; return GetPointer(this);                    }
   
   
   FluentDelta       *switchToNextLevel();
   
   
   FluentDelta       *directMoving();
   FluentDelta       *backMoving();
   FluentDelta       *freeMoneyCount();
   
   double            getLotsCount();
   double            getMinLot(){ return lotsCountMinBase; }
   double            getFreeMoney() { return depositFree; }
   double            getStartDepo();
                    ~FluentDelta();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FluentDelta::FluentDelta(void){
   lotsCountMax = MarketInfo(Symbol(),MODE_MAXLOT);
   lotsCountTemp = 0;
   depositTemp = 0;
   depositDown = 0;
   depositFree = 0;
   levelNumber = 0;
   realAccount = false;
}

double FluentDelta::initLotsCountMin(double lotMinIn){
   if(lotMinIn == 0)
       this.lotsCountMin = MarketInfo(Symbol(), MODE_MINLOT);
   else
       this.lotsCountMin = lotMinIn;
   return this.lotsCountMin;
}

FluentDelta *FluentDelta::initFromFile(){
   if(realAccount){
      fileHandle = FileOpen(fileName, FILE_CSV|FILE_READ, ';');  
      if(fileHandle < 1)
         Print("Файл ", fileName, "не обнаружен. Последняя ошибка", GetLastError());   
      else{
         FileSeek(fileHandle, 0, SEEK_SET);
         lotsCount = FileReadNumber(fileHandle);         //считываем из файла lotsCount 
         depositStart = FileReadNumber(fileHandle);   //Считываем из файла depositeStart
         depositFree = FileReadNumber(fileHandle);    //Счиьываем из файла depositeFree 
         FileClose(fileHandle);
      }
   }
   return GetPointer(this);
}

FluentDelta *FluentDelta::toFile(){
   fileHandle = FileOpen(fileName, FILE_CSV|FILE_WRITE, ';');  
   if(fileHandle < 1)
      Print("Файл ", fileName, "не обнаружен. Последняя ошибка", GetLastError());   
   else{
      FileSeek(fileHandle, 0, SEEK_SET);
      FileWrite(fileHandle, lotsCount, depositStart, depositFree);         //считываем из файла lotsCount 
      FileClose(fileHandle);
   }
   return GetPointer(this);
}


FluentDelta *FluentDelta::switchToNextLevel(void){
   double depositCurrent = AccountBalance();
   //------------------------1. ПЕРЕКЛЮЧАТЕЛЬ ОБЪЕМОВ-------------------------
   if(depositCurrent >= 2 * switcher * depositStartBase){ //когда текущий объем больше начального в 20 раз
      for(int i = 1; i<=10; i++){
         double nextLevel = MathPow(switcher, i) * MathPow(2, i) * depositStartBase;
         if(depositCurrent >= nextLevel) {
            depositStart = nextLevel; //меняем планку начального объема
            lotsCountMin = MathPow(switcher, i) * lotsCountMinBase ; //меняем минимальный шаг 
            delta = MathPow(switcher, i) * deltaBase;  //меняем дельту
         }
      }
   }
   return GetPointer(this);
}

FluentDelta *FluentDelta::directMoving(){
   double currentDeposit=AccountBalance();
   if(currentDeposit >= this.depositStart){
      lotsCount = this.lotsCountMin * (MathFloor(0.5*(1+MathSqrt(1+8*(currentDeposit - this.depositStart)/this.delta))));
   } else {
      lotsCount = this.lotsCountMin;
   }
   return GetPointer(this);
}

FluentDelta *FluentDelta::freeMoneyCount(){
   double currentDepo=AccountBalance();
   if(lotsCount > lotsCountTemp){
      int kLevel = (int) MathFloor(lotsCount/this.lotsCountMin);
      this.depositFree = 0.5 * this.delta * kLevel * (kLevel-1) * (1-this.downRate);
      this.depositDown = this.depositStart + depositFree;
      lotsCountTemp = lotsCount; //только при повышении объемов
      if(realAccount){
         this.toFile();
      }
      
   }
   return GetPointer(this);
}

FluentDelta *FluentDelta::backMoving(){
   double currentDepo=AccountBalance();
   if(depositTemp > currentDepo && lotsCount >= 2 * this.lotsCountMin){
      lotsCount = this.lotsCountMin * (MathFloor(0.5 * (1+MathSqrt(1+8 * (currentDepo-depositDown)/(this.delta * this.downRate)))));
      depositStart = depositDown;
      if(realAccount){
         this.toFile();
      }
   }
   
   if(lotsCount < lotsCountTemp && realAccount) //запись данных в файл при уменьшении объема
      this.toFile();
   return GetPointer(this);
}

double FluentDelta::getLotsCount(){      
      
      //-------------------------1. ПЕРЕЙТИ НА НОВЫЙ УРОВЕНЬ-----------------------
      this.switchToNextLevel();
      
      //-------------------------2. ПРЯМОЙ ХОД-------------------------------------
      this.directMoving();
      
      //------------------------3. РАСЧЕТ ВЫСВОБОЖДЕННЫХ СРЕДСТВ
      this.freeMoneyCount();
      
      //------------------------4. ОБРАТНЫЙ ХОД----------------------------------------
      this.backMoving();
      
      depositTemp = AccountBalance();   //временно хранит последний уровень объемов
      
      
   
      return lotsCount;
   }

double FluentDelta::getStartDepo(){
   return depositStart;
}

FluentDelta::~FluentDelta()
  {
  }
   

