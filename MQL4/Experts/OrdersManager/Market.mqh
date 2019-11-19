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

public:
                     Market();
                     Market(int magicNumberIn);
                    ~Market();
   bool              isChanged();
   bool              isEmpty();
   int               count();
   int               getSize();
  };
Market::Market()
  {
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

//+------------------------------------------------------------------+
