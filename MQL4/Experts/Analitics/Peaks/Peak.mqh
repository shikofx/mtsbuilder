//+------------------------------------------------------------------+
//|                                                          Pic.mqh |
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
class Peak
  {
private:
   string            name;
   int               rightCandles;
   int               leftCandles;
   int               shift;
   bool              direction; //0 - пики снизу, 1 - пики сверху
   color             curentColor;
   int               verticalShift;
   double            price;
   datetime          time;
   ENUM_TIMEFRAMES   timeframe;
   int               frameWeight;
   
public:
   void              drop();
   bool              find(string _name);
   
   
   Peak              *withName(string _name)              {  name=IntegerToString(direction)+"___"+_name+"___"+TimeToString(time); return GetPointer(this);}
   Peak              *withPrice(double _price)            {  price=_price; return GetPointer(this);}
   Peak              *updateCandlePrice();
   Peak              *withTime(datetime _time)            {  time=_time; return GetPointer(this);}
   Peak              *withTime()                          {  time=Time[rightCandles+shift+1];  return GetPointer(this);}
   Peak              *withRightCandles(int _rightCandles) {  rightCandles = frameWeight * _rightCandles; return GetPointer(this);}
   Peak              *withLeftCandles(int _leftCandles)   {  leftCandles=frameWeight * _leftCandles; return GetPointer(this);}
   Peak              *withDirection(bool _direction)      {  direction = _direction; return GetPointer(this);}
   Peak              *withColor(color _color)        {  curentColor = _color; return GetPointer(this);}
   Peak              *withShift(int _shift)               {  shift=_shift; return GetPointer(this);}
   Peak              *withArrowShift(int _arrowShift)     {  this.verticalShift = _arrowShift; return GetPointer(this);}
     
   string            getName(){return(name);}
   double            getPrice(){return(price);}
   datetime          getTime(){return(time);}
   int               getRightCandles(){return(rightCandles);}
   int               getLeftCandles(){return(leftCandles);}
   bool              getDirection(){return(direction);}
   color             getArrowColor(){return(curentColor);}
   int               getShift(){return(shift);}
   
   void              putArrow();
   void              dropArrow();
   string            toString();
   bool              isExist();
   //void              operator=(Peak &_пик);
                     Peak();
                     Peak(ENUM_TIMEFRAMES timefr);
                     Peak(Peak *peak);
                     Peak(int _rightCandles,int _leftCandles,int shift,bool _direction,color _color, int _verticalShift);
                    ~Peak();
  };
//+------------------------------------------------------------------+
//| Конструктор класса Peak                                                                 |
//+------------------------------------------------------------------+
//Peak::Peak(){
//  }

Peak::Peak(ENUM_TIMEFRAMES timefr){
   if(timefr >= Period())
      this.timeframe = timefr;
   else
      this.timeframe = Period();
   this.frameWeight = timefr / Period();
  }
    
Peak::~Peak(){
   name="";
   price=0.0;
   time=0;
  }
//+------------------------------------------------------------------+
//| Определяет существует ли пик                                                                  |
//+------------------------------------------------------------------+
bool Peak::isExist(){
   if(price != 0)
      return(true);
   else
      return(false);
  }
//+------------------------------------------------------------------+
//| Устанавливает стрелку для пика                                                                 |
//+------------------------------------------------------------------+
Peak *Peak::updateCandlePrice(){
   
   if(!direction)
      price = Low[rightCandles+shift+1];
   if(direction)
      price = High[rightCandles+shift+1];
   
   return GetPointer(this);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Peak::putArrow(){
   if(!direction){
      ObjectCreate(0, name, OBJ_ARROW_UP, 0, time, price - (verticalShift * 50 + 30) * Point);
      ObjectSet(name, OBJPROP_COLOR, curentColor);
      ObjectSet(name, OBJPROP_ARROWCODE, 217);
      ObjectSet(name, OBJPROP_WIDTH, 2);
      ObjectSet(name, OBJPROP_ANCHOR, ANCHOR_TOP);
     }
   if(direction){
      ObjectCreate(0, name,OBJ_ARROW_DOWN, 0,time, price + (verticalShift * 50 + 60) * Point);
      ObjectSet(name, OBJPROP_ARROWCODE, 218);
      ObjectSet(name, OBJPROP_COLOR, curentColor);
      ObjectSet(name, OBJPROP_WIDTH, 2);
      ObjectSet(name, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Peak::drop(){
//this.dropArrow();
   this.name="";
   this.price=0.0;
   this.time=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Peak::dropArrow(){   
   ObjectDelete(name);
}
//+------------------------------------------------------------------+
//| Определяет, является ли свеча пиком                                                                 |
//+------------------------------------------------------------------+
bool Peak::find(string _name){
   bool isPeak=true;
   this.updateCandlePrice();
   for(int i = shift + 1; i <= (leftCandles + rightCandles + shift + 1); i++){
      if(i == rightCandles + shift + 1)
         continue;
      if((price >= Low[i] && !direction) ||
         (price <= High[i] && direction)){
         isPeak=false;
         price = 0;
         break;
      }
   }
   if(isPeak){
      time = Time[rightCandles + shift + 1];
      name = IntegerToString(direction)+_name+TimeToString(time);
      this.putArrow();
   }
   return isPeak;
  }
//+------------------------------------------------------------------+
//| Формирует строку для вывода на экран или в журнал                |
//+------------------------------------------------------------------+
string Peak::toString(){
   return(this.name + ": Time = " + TimeToString(time) + "; Price = "+DoubleToString(price));
  }
//+------------------------------------------------------------------+

