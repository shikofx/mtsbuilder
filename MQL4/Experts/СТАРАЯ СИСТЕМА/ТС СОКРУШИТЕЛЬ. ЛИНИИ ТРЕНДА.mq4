//+------------------------------------------------------------------+
//|                                                     СОВЕТНИК.mq4 |
//|     Copyright © 2012, Инвестиционная группа "Витязи Духа"  Corp. |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, Инвестиционная группа Витязи Духа  Corp."


#include <money_managment_lib.mqh>
#include <Signals.mqh>


extern bool       РЕЖИМ_РИСОВАНИЯ = false;

extern bool        ФИЛЬТР_МАКСИМАЛЬНОГО_ДВИЖЕНИЯ = 0; //0 - выключен, 1 - включен
extern int        МД_МАКСИМАЛЬНОЕ_ДВИЖЕНИЕ = 1000; //максимальное расстояние между ценой открытия и стоп-лоссом

bool       ПОДЖАТИЕ_ЛТ = false;
int        П_ЗАЩИТНЫЙ_ИНТЕРВАЛ = 250;
extern int        П_ПРОФИТ = 2900;
int        П_НОМЕР_СВЕЧИ = 0;

//много сделок
extern int        КОЛИЧЕСТВО_СДЕЛОК = 1; //0 - 1 сделка
bool       ФИЛЬТР_ШАГ_СДЕЛОК = 0; //0 - выключен, 1 - включен
int        ШАГ_СДЕЛОК = 300; //минимальное расстояние между сделками

bool       ОБЩИЙ_ЛОСС = false;
bool       ОБЩИЙ_ПРОФИТ = false;

extern bool       СИСТЕМА_УПРАВЛЕНИЯ_КАПИТАЛОМ = false;

extern bool       ФПБЛ0_ФИЛЬТР = true;
extern int        ФПБЛ0_ТАЙМФРЕЙМсс = 4; //0 - период текущего графика, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
extern int        ФПБЛ0_ПЕРИОДсс = 10;
extern int        ФПБЛ0_МЕТОДсс = 0; //0 - простой, 1 - экспонента, 2 - сглаженное, 3 - линейно-взвешенное
extern int        ФПБЛ0_ЦЕНАсс = 6;
extern int        ФПБЛ0_СВЕЧИ_СЛЕВА = 2;
extern int        ФПБЛ0_СВЕЧИ_СПРАВА = 5; 
extern int        ФПБЛ0_ТИП_ПИКА = 1;
extern int        ФПБЛ0_ТАЙМФРЕЙМ = 4; //0 - период текущего графика, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
extern int        ФПБЛ0_ПЕРИОД = 15;
extern int        ФПБЛ0_ОТКЛОНЕНИЕ = 2; 
extern int        ФПБЛ0_ЦЕНА = 2; //0...6 - простой, 1 - экспонента, 2 - сглаженное, 3 - линейно-взвешенное
extern int        ФПБЛ0_КОРИДОР = 0; 

extern bool       КОНТРАТАКА = true;
extern int        КАТ_УРОВЕНЬ = -400;
extern int        КАТ_КОЛИЧЕСТВО_СДЕЛОК = 2;
bool КАТ_покупка = false;
bool КАТ_продажа = false;

extern bool       ЗАЦЕП = false;
extern int        ЗЦ_ЗАЩИТНЫЙ_ИНТЕРВАЛ = 300;
extern int        ЗЦ_ИНТЕРВАЛ = 2;//количество свечей для анализа
extern int        ЗЦ_ЗАДЕРЖКА = 0;//через  сколько свечей начинаем анализ
extern int        ЗЦ_MagicNumber = 33333;
extern bool       УДАЛЕНИЕ_ЛИШНЕГО = true;

extern bool       РЕЖИМ_ТЕСТИРОВАНИЯ = true;

extern bool       РТ_РЕЖИМ1 = true;                            
extern int        РТ_ПРОФИТ_ТРЕНД1 = 2900;
extern bool       РТ_РЕЖИМ2 = true; 
extern int        РТ_ПРОФИТ_ТРЕНД2 = 5400;
extern int        РТ_ТАЙМФРЕЙМ = 4;
extern int        РТ_СВЕЧИ_СПРАВА = 1;
extern int        РТ_СВЕЧИ_СЛЕВА = 1;
extern int        РТ_ПЕРИОД = 40;
extern int        РТ_ТИП_ПИКА = 0;
extern int        РТ_МЕТОД = 0;

bool РТ_покупка1 = true;
bool РТ_продажа1 = false;

bool РТ_покупка2 = true;
bool РТ_продажа2 = false;

extern bool       ФИЛЬТР_ЗАНУЛЕНИЕ = true; //0 - выключен, 1 - включен
extern int        З_УРОВЕНЬ_ЗАНУЛЕНИЯ = 1000; //уровень зануления
extern int        З_ПРОФИТ_ЗАНУЛЕНИЯ = 330;

extern bool       ФИЛЬТР_ЗАНУЛЕНИЕ1 = true; //0 - выключен, 1 - включен
extern int        З_УРОВЕНЬ_ЗАНУЛЕНИЯ1 = 1870; //уровень зануления
extern int        З_ПРОФИТ_ЗАНУЛЕНИЯ1 = 860;

extern bool       ФИЛЬТР_ЗАНУЛЕНИЕ2 = true; //0 - выключен, 1 - включен
extern int        З_УРОВЕНЬ_ЗАНУЛЕНИЯ2 = 3000; //уровень зануления
extern int        З_ПРОФИТ_ЗАНУЛЕНИЯ2 = 2800;

extern bool       _ЛИНИИ_ТРЕНДА = true;
extern int        ЛТ_ЛОСС_МАКСИМАЛЬНЫЙ = 2600;
extern int        ЛТ_ЛОСС_ЗАЩ_ИНТЕРВАЛ = 300;

extern int        ЛТ_ПРОФИТ = 8000;
extern int        ЛТ_КОРИДОР = 1200;                                       
extern int        ЛТ_ПРЕДВЕСТНИК_СЛЕВА = 2;  //кличество свечей до возможного пика (слева) 
extern int        ЛТ_ПРЕДВЕСТНИК_СПРАВА = 1; //кличество свечей после возможного пика (справа)
extern int        ЛТ_ПРЕСТУПНИК_СЛЕВА = 1;   //кличество свечей до возможного пика (слева) 
extern int        ЛТ_ПРЕСТУПНИК_СПРАВА = 1;  //кличество свечей после возможного пика (справа)
int        ЛТ_КВАЛИФИКАТОР_ПРОРЫВА = -1;           //-1 - ВСЕ ПРОРЫВЫ СЧИТАЮТСЯ ЛОЖНЫМИ
                                                          //0 - РАБОТАЮТ ВСЕ КВАЛИФИКАТОРЫ
                                                          //>0 - РАБОТАЕТ КОНКРЕТНЫЙ КВАЛИФИКАТОР
int        ЛТ_ТИП_ПЕРЕСЕЧЕНИЯ = 0; //тип пересечения линеей тренда подтверждающей свечи, для 
                              //проверки на истинность пика 0 - по вершинам, 1 - по Close
int        ЛТ_MAGIC_NUMBER = 55555;
color      ЛТ_ВНИЗ_ЦВЕТ = Blue;
color      ЛТ_ВВЕРХ_ЦВЕТ = Red;

extern color      ______ОТКРЫТИЕ_______;
//условия открытия дополнительных сделок
extern bool       ФMACDОТКР_ФИЛЬТР = true;
extern int        ФMACDОТКР_ТАЙМФРЕЙМ = 4;
extern int        ФMACDОТКР_БЫСТРАЯ_СС = 4;
extern int        ФMACDОТКР_МЕДЛЕННАЯ_СС = 10;
extern int        ФMACDОТКР_СИГНАЛЬНАЯ_СС = 1;
extern int        ФMACDОТКР_ЦЕНА = 0;
int        ФMACDОТКР_ПОРОГ_РАЗР = 0;
int        ФMACDОТКР_ПОРОГ_ЗАПР = 0;

extern color      ____ПОДЖАТИЕ_____;
//ПОДЖАТИЕ НА СКОЛЬЗЯЩЕЙ СРЕДНЕЙ
extern bool       ФПСС_ФИЛЬТР = false;
extern int        ФПСС_ПОРОГ_СРАБАТЫВАНИЯ = 6000;
extern int        ФПСС_ТАЙМФРЕЙМ = 0; //0 - период текущего графика, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
extern int        ФПСС_ПЕРИОД = 1;
extern int        ФПСС_МЕТОД = 0; //0 - простой, 1 - экспонента, 2 - сглаженное, 3 - линейно-взвешенное
extern int        ФПСС_ЦЕНА = 2;
extern int        ФПСС_КОРИДОР = 500; 
extern int        ФПСС_СВЕЧИ_СЛЕВА = 3;
extern int        ФПСС_СВЕЧИ_СПРАВА = 1; 
extern int        ФПСС_ТИП_ПИКА = 0;
//ПОДЖАТИЕ НА ЛИНИЯХ БОЛЛИНДЖЕРА

 bool       ФПБЛ_ФИЛЬТР = false;

 int        ФПБЛ_ТАЙМФРЕЙМ = 4; //0 - период текущего графика, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
 int        ФПБЛ_ПЕРИОД = 10;
 int        ФПБЛ_ОТКЛОНЕНИЕ = 2; 
 int        ФПБЛ_ЦЕНА = 0; //0...6 - простой, 1 - экспонента, 2 - сглаженное, 3 - линейно-взвешенное
 int        ФПБЛ_КОРИДОР = 500; 

//ПОДЖАТИЕ НА ЛИНИЯХ SAR
 bool       ФПСАРА_ФИЛЬТР = false;

 int        ФПСАРА_ТАЙМФРЕЙМ = 4; //0 - период текущего графика, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
 double     ФПСАРА_ШАГ = 0.02;
 double     ФПСАРА_МАКСИМУМ = 0.2; 
 int        ФПСАРА_КОРИДОР = 200;

extern color      __УПРАВЛЕНИЕ_КАПИТАЛОМ_;
extern int        СУК_ПЕРЕКЛЮЧАТЕЛЬ = 10;

extern double     СУК_НАЧ_ДЕПОЗИТ = 100; //ДЕПОЗИТ НЕОБХОДИМЫЙ ДЛЯ НАЧАЛА ТОРГОВЛИ 
extern int        СУК_DELTA = 30;
extern double     СУК_MIN_LOT = 0.01; //определяет минимальный шаг для изменения объема позиции
extern double     СУК_DOWN_RATE = 1.0; //ставка снижения при движении в убыток
      
extern bool       РУЧНАЯ_ТОРГОВЛЯ = false;
extern color      РТ_BColor = LawnGreen;
extern color      РТ_BTPColor = MediumSpringGreen;
extern color      РТ_BSLColor = YellowGreen;
extern color      РТ_SColor = DarkViolet;
extern color      РТ_STPColor = MediumVioletRed;
extern color      РТ_SSLColor = Violet;
extern int        РТ_MAGIC_NUMBER = 10000; //магический номер для ручной торговли                  

extern color      ОБЩИЕ_ПАРАМЕТРЫ;
extern int        SLIPPAGE = 50; 

//управление капиталом
double   CurrentDepo=0, //хранит значение текущего депозита
         minLot=0,      //хранит значение минимального объема для инструмента
         StartDepo=0, rStartDepo=0, FreeDepo=0, delta=0, Lot=0, tempLot=0, tLot=0, tDepo=0;
int Experts=0, ticket=0, kLevel=0, distance=0, day=0, day1=0, i, j, k, n, fwrite=0;
string   MM_file_name, 
         ЛТ_МИНИМУМ_ФАЙЛ, 
         ЛТ_МАКСИМУМ_ФАЙЛ, 
         ЛТ_ВВЕРХ_ФАЙЛ, 
         ЛТ_ВНИЗ_ФАЙЛ,
         ОТКРЛТ_МИНИМУМ_ФАЙЛ, 
         ОТКРЛТ_МАКСИМУМ_ФАЙЛ, 
         ОТКРЛТ_ВВЕРХ_ФАЙЛ, 
         ОТКРЛТ_ВНИЗ_ФАЙЛ;
int MM_file_handle=0, LT_file_handle;
//РУЧНАЯ ТОРГОВЛЯ
double   Y1_BOX, Y2_BOX;
datetime СЕРЕДИНА_ЛИНИИ, X1_BOX = 2, X2_BOX=3;
string object_name[8][2];
string object_note[8][2];

bool  sBUY, sMBUY, sCLBUY, sDPBUY, sBTP, sBSP, sBLP, sBSL, sSELL, sMSELL, sCLSELL, sDPSELL, sSTP, sSSP, sSLP, sSSL;

//подсистема управления сделками
bool  SB=false, SBS=false, SBL=false, SBM=false, SBSM = false, SBLM = false, SBCL=false, SBSD=false, SBLD=false, 
      SS=false, SSS=false, SSL=false, SSM=false, SSSM = false, SSLM = false, SSCL=false, SSSD=false, SSLD=false, 
      BUY=false, BUY_STOP=false, BUY_LIMIT=false, BUY_MODIFY=false, BUYSTOP_PRICE_MODIFY=false, BUYLIMIT_PRICE_MODIFY = false, BUY_CLOSE=false, BUYLIMIT_DELETE=false, BUYSTOP_DELETE=false,
      SELL=false, SELL_STOP=false, SELL_LIMIT=false, SELL_MODIFY=false, SELLSTOP_PRICE_MODIFY=false, SELLLIMIT_PRICE_MODIFY=false, SELL_CLOSE=false, SELLLIMIT_DELETE=false, SELLSTOP_DELETE=false;
double BuyTakeProfit=0, BuyStopPrice=0, BuyLimitPrice=0, BuyStopLoss=0, BuyOpenPrice,  SellTakeProfit=0, SellStopPrice=0, SellLimitPrice=0, SellStopLoss=0;    
int totalBars = 0;
int qObjects = 8; 
datetime время_текущей_свечи;

bool  линия_тренда = false,
      линия_тренда_вниз = false,
      линия_тренда_вверх = false;

datetime points_down[2] = {0}; 
datetime points_up[2] = {0}; 
datetime points_down2[2] = {0}; 
datetime points_up2[2] = {0}; 

bool  новая_ЛТ_вниз = false;
bool  новая_ЛТ_вверх = false;
bool  продажа_день = false;
bool  покупка_день = false;
bool  включить_доп_покупку = false;
bool  включить_доп_продажу = false;

bool  ФMACDОТКР_продажа = false;
bool  ФMACDОТКР_покупка = false;
int   ФMACDОТКР = 0;

bool  ФMACD_открытие_покупок = false;
bool  ФMACD_открытие_продаж = false;

bool  РТ_MACD_продажа = false;
bool  РТ_MACD_покупка = false;
int   РТ_MACD = 0;

bool  РТ_MACD_открытие_покупок = false;
bool  РТ_MACD_открытие_продаж = false;

bool  новая_ОТКРЛТ_вниз = false;
bool  новая_ОТКРЛТ_вверх = false;


bool  ФПСС_продажа = false;
bool  ФПСС_покупка = false;
int   ФПСС_HIGH = 0;
int   ФПСС_LOW = 0;
double ПСС_HIGH = 0;
double ПСС_LOW = 0;

bool  ФПБЛ_продажа = false;
bool  ФПБЛ_покупка = false;
int   ФПБЛ = 0;
double ПБЛ_ВЕРХ = 0;
double ПБЛ_НИЗ = 0;

bool   ФПБЛ0_продажа_СС = false;
bool   ФПБЛ0_покупка_СС = false;
int    ФПБЛ0_HIGHсс = 0;
int    ФПБЛ0_LOWсс = 0;
double ПБЛ0_HIGHсс = 0;
double ПБЛ0_LOWсс = 0;
bool   ФПБЛ0_продажа = false;
bool   ФПБЛ0_покупка = false;
int    ФПБЛ0 = 0;
double ПБЛ0_ВЕРХсс = 0;
double ПБЛ0_НИЗсс = 0;
double ПБЛ0_ВЕРХ = 0;
double ПБЛ0_НИЗ = 0;

bool  ФПСАРА_продажа = false;
bool  ФПСАРА_покупка = false;
int   ФПСАРА = 0;
double ПСАРА = 0;

bool модификация_продаж_ПСС = false;
bool модификация_покупок_ПСС = false;

bool модификация_продаж_ПБЛ = false;
bool модификация_покупок_ПБЛ = false;


bool модификация_продаж_ПБЛ0 = false;
bool модификация_покупок_ПБЛ0 = false;

bool  ФЗАКРСС_продажа = false;
bool  ФЗАКРСС_покупка = false;
int   ФЗАКРСС_HIGH = 0;
int   ФЗАКРСС_LOW = 0;
double ЗАКРСС = 0;


bool  зануление_покупки = true;
bool  зануление_продажи = true;

bool  зануление_покупки1 = true;
bool  зануление_продажи1= true;

bool  зануление_покупки2 = true;
bool  зануление_продажи2= true;

double день = 0;
double trendline_down, trendline1_down, trendline_up, trendline1_up;

int свеча_предвестника_вниз = 0;
int свеча_предвестника_вверх = 0;
int свеча_преступника_вниз = 0;
int свеча_преступника_вверх = 0;
int количество_тиков = 0;
int количество_продаж = 0;
int количество_покупок = 0;

int свеча_пика = 0;
int   ФРТ_HIGH = 0, ФРТ_LOW = 0;
double РТ_HIGH = 0, РТ_LOW = 0;
double РТ_минимум = 0, РТ_максимум = 0;

bool  закрыть_покупку = false,
      закрыть_продажу = false;

int количествоПокупокПредыдущее = 0,
   количествоПродажПредыдущее = 0,
   количествоПокупокТекущее = 0,
   количествоПродажТекущее = 0;
double high_РТ2 = 0;
double low_РТ2 = 0;
bool дубль_покупки = false, дубль_продажи = false;
datetime время_дубль_покупки = 0, время_дубль_продажи = 0;

//-------------------------------------------------- 
int init(){
   //0 - период текущего графика, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
   ФПСС_ТАЙМФРЕЙМ = УстановитьПериод(ФПСС_ТАЙМФРЕЙМ);
   ФПБЛ_ТАЙМФРЕЙМ = УстановитьПериод(ФПБЛ_ТАЙМФРЕЙМ);
   ФПБЛ0_ТАЙМФРЕЙМсс = УстановитьПериод(ФПБЛ0_ТАЙМФРЕЙМсс);
   ФПБЛ0_ТАЙМФРЕЙМ = УстановитьПериод(ФПБЛ0_ТАЙМФРЕЙМ);
   ФПСАРА_ТАЙМФРЕЙМ = УстановитьПериод(ФПСАРА_ТАЙМФРЕЙМ);
   ФMACDОТКР_ТАЙМФРЕЙМ = УстановитьПериод(ФMACDОТКР_ТАЙМФРЕЙМ);
   РТ_ТАЙМФРЕЙМ = УстановитьПериод(РТ_ТАЙМФРЕЙМ);
   день = Day()-1;
   линия_тренда_вниз = ЭтоЛинияТренда(ЛТ_ВНИЗ_ФАЙЛ, points_down);
   линия_тренда_вверх = ЭтоЛинияТренда(ЛТ_ВВЕРХ_ФАЙЛ, points_up);
   
  
   object_name[0][0] = "BUY";
   object_name[1][0] = "BUY_MODIFY";
   object_name[2][0] = "BUY_CLOSE";
   object_name[3][0] = "BUY_DELETE_PENDING";
   object_name[4][0] = "BUY_TakeProfit";
   object_name[5][0] = "BUY_STOP_Price";
   object_name[6][0] = "BUY__LIMIT_Price";
   object_name[7][0] = "BUY_StopLoss";
   
   object_name[0][1] = "SELL";
   object_name[1][1] = "SELL_MODIFY";
   object_name[2][1] = "SELL_CLOSE";
   object_name[3][1] = "SELL_DELETE_PENDING";
   object_name[4][1] = "SELL_StopLoss";
   object_name[5][1] = "SELL__LIMIT_Price";
   object_name[6][1] = "SELL__STOP_Price";
   object_name[7][1] = "SELL_TakeProfit";
   
   object_note[0][0] = "BUY";
   object_note[1][0] = "BUY_MODIFY";
   object_note[2][0] = "BUY_CLOSE";
   object_note[3][0] = "BUY_DELETE";
   object_note[0][1] = "SELL";
   object_note[1][1] = "SELL_MODIFY";
   object_note[2][1] = "SELL_CLOSE";
   object_note[3][1] = "SELL_DELETE";
      
//ПРОРИСОВКА ПАРАМЕТРОВ

   X1_BOX = 4;   
  // РисованиеОбъектовПокупки(qObjects);
  // РисованиеОбъектовПродажи(qObjects);
   MM_file_name = StringConcatenate("MM_",AccountNumber(), Symbol(), Period(),".csv");
  // EX_file_name_ЛТ = StringConcatenate("EX_ЛТ",AccountNumber(), Symbol(), Period(),"_",ЛТ_ПРЕДВЕСТНИК_СЛЕВА, ЛТ_ПРЕДВЕСТНИК_СПРАВА, "+", ЛТ_ПРЕСТУПНИК_СЛЕВА, ЛТ_ПРЕСТУПНИК_СПРАВА, ".csv");
   ЛТ_МИНИМУМ_ФАЙЛ = StringConcatenate("MIN_ЛТ_",AccountNumber(), Symbol(), Period(),"_",ЛТ_ПРЕДВЕСТНИК_СЛЕВА, ЛТ_ПРЕДВЕСТНИК_СПРАВА, "+", ЛТ_ПРЕСТУПНИК_СЛЕВА, ЛТ_ПРЕСТУПНИК_СПРАВА, ".csv");
   ЛТ_МАКСИМУМ_ФАЙЛ = StringConcatenate("MAX_ЛТ_",AccountNumber(), Symbol(), Period(),"_",ЛТ_ПРЕДВЕСТНИК_СЛЕВА, ЛТ_ПРЕДВЕСТНИК_СПРАВА, "+", ЛТ_ПРЕСТУПНИК_СЛЕВА, ЛТ_ПРЕСТУПНИК_СПРАВА, ".csv");
   ЛТ_ВВЕРХ_ФАЙЛ = StringConcatenate("ЛВВ_ЛТ_",AccountNumber(), Symbol(), Period(),"_",ЛТ_ПРЕДВЕСТНИК_СЛЕВА, ЛТ_ПРЕДВЕСТНИК_СПРАВА, "+", ЛТ_ПРЕСТУПНИК_СЛЕВА, ЛТ_ПРЕСТУПНИК_СПРАВА, ".csv");
   ЛТ_ВНИЗ_ФАЙЛ = StringConcatenate("ЛВН_ЛТ_",AccountNumber(), Symbol(), Period(),"_",ЛТ_ПРЕДВЕСТНИК_СЛЕВА, ЛТ_ПРЕДВЕСТНИК_СПРАВА, "+", ЛТ_ПРЕСТУПНИК_СЛЕВА, ЛТ_ПРЕСТУПНИК_СПРАВА, ".csv");
   
   Experts = SetExpertsQuantity();
   day = Day();
  //  StartDepo = 100;
   delta = СУК_DELTA; //Задаем начальную дельту
   if(СУК_MIN_LOT == 0){
       minLot=MarketInfo(Symbol(), MODE_MINLOT);
       СУК_MIN_LOT=minLot;
   }
   else
       minLot=СУК_MIN_LOT;
   StartDepo =  СУК_НАЧ_ДЕПОЗИТ;   
   tLot = minLot; //Задаем текущий объем
   
   if(СИСТЕМА_УПРАВЛЕНИЯ_КАПИТАЛОМ)
   {
      MM_file_handle = FileOpen(MM_file_name, FILE_CSV|FILE_READ, ';');  
      if(MM_file_handle < 1)
         Print("Файл ", MM_file_name, "не обнаружен. Последняя ошибка", GetLastError());   
      else
      {
         FileSeek(MM_file_handle, 0, SEEK_SET);
         Lot = FileReadNumber(MM_file_handle);         //считываем из файла Lot 
         StartDepo = FileReadNumber(MM_file_handle);   //Считываем из файла rStartDepo
         FreeDepo = FileReadNumber(MM_file_handle);    //Счиьываем из файла FreeDepo 
         FileClose(MM_file_handle);
      }
   }   
   время_текущей_свечи = Time[0];
   return(0);
}

//-------------------------------------------------
int deinit()
   {
      DeinitExpertsQuantiy(Experts);  //удаление эксперта сопровождается уменьшением количества экспертов в коллекции
      if(УДАЛЕНИЕ_ЛИШНЕГО)
      {
         FileDelete(MM_file_name);
         FileDelete(ЛТ_МИНИМУМ_ФАЙЛ);
         FileDelete(ЛТ_МАКСИМУМ_ФАЙЛ);
         FileDelete(ЛТ_ВВЕРХ_ФАЙЛ);
         FileDelete(ЛТ_ВНИЗ_ФАЙЛ);
         FileDelete(ОТКРЛТ_МИНИМУМ_ФАЙЛ);
         FileDelete(ОТКРЛТ_МАКСИМУМ_ФАЙЛ);
         FileDelete(ОТКРЛТ_ВВЕРХ_ФАЙЛ);
         FileDelete(ОТКРЛТ_ВНИЗ_ФАЙЛ);
      }
   //   ObjectsDeleteAll();
      return(0);
   }


datetime  пиковая_свеча=0, tmp_свеча = 0; //коктролирует чтобы на одной свече открывалась только одна сделка
datetime  time_tmp = 0;
int start()
{
   количествоПокупокПредыдущее = количествоПокупокТекущее;
   количествоПродажПредыдущее = количествоПродажТекущее;
   
   количествоПокупокТекущее =    QOrders(OP_BUY);
   количествоПродажТекущее = QOrders(OP_SELL);
   
   if(количествоПокупокТекущее==0 && количествоПокупокПредыдущее > 1)
      новая_ЛТ_вверх = true;   
   if(количествоПродажТекущее==0 && количествоПродажПредыдущее > 1)
      новая_ЛТ_вниз = true;   
   
   if(количествоПокупокТекущее!=0 && CurrentProfit(OP_BUY)>П_ПРОФИТ)
      закрыть_покупку = true;
   if(количествоПродажТекущее!=0 && CurrentProfit(OP_SELL)>П_ПРОФИТ)
      закрыть_продажу = true;
   
   if(количествоПокупокТекущее == 0)   
      закрыть_покупку = false;
   if(количествоПродажТекущее == 0)   
      закрыть_продажу = false;
      
   BuyStopLoss = 0;
   SellStopLoss = 0;
   
    
   bool новая_свеча = false;
   if(time_tmp<Time[0] && количество_тиков == 0)
   {
      time_tmp = Time[0];
      новая_свеча = true;   
      количество_тиков++;
   }
   else 
      количество_тиков = 0;
      
   int MagicNumber = 0;
   
   
   //__________________АНАЛИЗ И ПРИНЯТИЕ РЕШЕНИЙ____________________
   //+++++++++++++++++++++++РУЧНАЯ ТОРГОВЛЯ+++++++++++++++++++++++++
   if(РУЧНАЯ_ТОРГОВЛЯ)
   {
      if(totalBars != WindowBarsPerChart())
      {
         totalBars = WindowBarsPerChart(); 
         РисованиеОбъектовПокупки(qObjects);
         РисованиеОбъектовПродажи(qObjects);
      }
      СмещениеОбъектовПокупки();     
      СмещениеОбъектовПродажи();  
      ПерерисовкаОбъектовПокупки();
      ПерерисовкаОбъектовПродажи();
      РасчетЦенПокупки();
      РасчетЦенПродажи();
      ОктрытьПокупку();
      ОктрытьПродажу();
      ЗакрытьПокупку();
      ЗакрытьПродажу();
      УдалитьПокупку();
      УдалитьПродажу();
      ИзменитьПокупку();
      ИзменитьПродажу();
      MagicNumber = РТ_MAGIC_NUMBER;
   }
   //+++++++++++++++++++++++++ЛИНИИ ТРЕНДА++++++++++++++++++++++++++
   //Определим начало новой свечи
   
   if(ФИЛЬТР_ЗАНУЛЕНИЕ != 0)
   {
      if(зануление_покупки)
      {
         
         BuyStopLoss = Зануление(OP_BUY, З_УРОВЕНЬ_ЗАНУЛЕНИЯ, З_ПРОФИТ_ЗАНУЛЕНИЯ);
         if(BuyStopLoss > 0  && BuyStopLoss > CurrentStopLoss(OP_BUY))
         {
            BUY_MODIFY = true;
            зануление_покупки = false;
         }
      }      
      
      if(зануление_продажи)
      {
         
         SellStopLoss = Зануление(OP_SELL, З_УРОВЕНЬ_ЗАНУЛЕНИЯ, З_ПРОФИТ_ЗАНУЛЕНИЯ);
         
         if(SellStopLoss > 0 && SellStopLoss < CurrentStopLoss(OP_SELL))
         {
            SELL_MODIFY = true;
            зануление_продажи = false;
         }
      }    
      
      if(количествоПокупокТекущее == 0 )
         зануление_покупки = true;  
      if(количествоПродажТекущее == 0)
         зануление_продажи = true;     
   } 
   
   if(ФИЛЬТР_ЗАНУЛЕНИЕ1 != 0)
   {
      if(зануление_покупки1)
      {
         double BuyStopLoss1 = Зануление(OP_BUY, З_УРОВЕНЬ_ЗАНУЛЕНИЯ1, З_ПРОФИТ_ЗАНУЛЕНИЯ1);
         if(BuyStopLoss1 > 0 && BuyStopLoss1 > CurrentStopLoss(OP_BUY))
         {
            BuyStopLoss = BuyStopLoss1;
            BUY_MODIFY = true;
            зануление_покупки1 = false;
         }
      }      
      
      if(зануление_продажи1)
      {
         double SellStopLoss1 = Зануление(OP_SELL, З_УРОВЕНЬ_ЗАНУЛЕНИЯ1, З_ПРОФИТ_ЗАНУЛЕНИЯ1);
         if(SellStopLoss1 > 0 && SellStopLoss1 < CurrentStopLoss(OP_SELL))
         {
            SellStopLoss = SellStopLoss1;
            SELL_MODIFY = true;
            зануление_продажи1 = false;
         }
      }    
      
      if(количествоПокупокТекущее == 0 )
         зануление_покупки1 = true;  
      if(количествоПродажТекущее == 0)
         зануление_продажи1 = true;     
   } 
   
   if(ФИЛЬТР_ЗАНУЛЕНИЕ2 != 0)
   {
      if(зануление_покупки2)
      {
         double BuyStopLoss2 = Зануление(OP_BUY, З_УРОВЕНЬ_ЗАНУЛЕНИЯ2, З_ПРОФИТ_ЗАНУЛЕНИЯ2);
         if(BuyStopLoss2 > 0 && BuyStopLoss2 > CurrentStopLoss(OP_BUY))
         {
            BuyStopLoss = BuyStopLoss2;
            BUY_MODIFY = true;
            зануление_покупки2 = false;
         }
      }      
      
      if(зануление_продажи2)
      {
         double SellStopLoss2 = Зануление(OP_SELL, З_УРОВЕНЬ_ЗАНУЛЕНИЯ2, З_ПРОФИТ_ЗАНУЛЕНИЯ2);
         if(SellStopLoss2 > 0 && SellStopLoss2 < CurrentStopLoss(OP_SELL))
         {
            SellStopLoss = SellStopLoss2;
            SELL_MODIFY = true;
            зануление_продажи2 = false;
         }
      }    
      
      if(количествоПокупокТекущее == 0 )
         зануление_покупки2 = true;  
      if(количествоПродажТекущее == 0)
         зануление_продажи2 = true;     
   } 
   
    
   //ФИЛЬТРЫ**************************************************************
   if(РЕЖИМ_ТЕСТИРОВАНИЯ)
   {
      if(РТ_РЕЖИМ1)
      {
         datetime время_закрытия_продажи = 0, 
                  время_закрытия_покупки = 0;
               
         if(ClosedByProfit(OP_SELL, РТ_ПРОФИТ_ТРЕНД1))
            время_закрытия_продажи = LastClosedTime(OP_SELL);
         if(ClosedByProfit(OP_BUY, РТ_ПРОФИТ_ТРЕНД1))
            время_закрытия_покупки = LastClosedTime(OP_BUY);
         
         if((закрыть_продажу && РТ_ПРОФИТ_ТРЕНД1 > 0) || (время_закрытия_продажи > время_закрытия_покупки && РТ_ПРОФИТ_ТРЕНД1 <0))
         {
            РТ_покупка1 = true;
            РТ_продажа1 = false;
         }
         else if((закрыть_покупку && РТ_ПРОФИТ_ТРЕНД1 > 0) || (время_закрытия_покупки > время_закрытия_продажи && РТ_ПРОФИТ_ТРЕНД1 < 0))
         {
            РТ_продажа1 = true;
            РТ_покупка1 = false;
         }
      }
      if(РТ_РЕЖИМ2)   
      {
         if(новая_свеча)
         {
            ФРТ_HIGH = ФМА_ФИЛЬТР_ПИК(РТ_ТИП_ПИКА, РТ_СВЕЧИ_СПРАВА, РТ_СВЕЧИ_СЛЕВА, РТ_ТАЙМФРЕЙМ, РТ_ПЕРИОД, РТ_МЕТОД, 2, РТ_HIGH);
            ФРТ_LOW = ФМА_ФИЛЬТР_ПИК(РТ_ТИП_ПИКА, РТ_СВЕЧИ_СПРАВА, РТ_СВЕЧИ_СЛЕВА, РТ_ТАЙМФРЕЙМ, РТ_ПЕРИОД, РТ_МЕТОД, 3, РТ_LOW);
            ФМА_ФИЛЬТР(РТ_ТИП_ПИКА, 1, 1, РТ_ТАЙМФРЕЙМ, РТ_ПЕРИОД, РТ_МЕТОД, 2, high_РТ2);
            ФМА_ФИЛЬТР(РТ_ТИП_ПИКА, 1, 1, РТ_ТАЙМФРЕЙМ, РТ_ПЕРИОД, РТ_МЕТОД, 3, low_РТ2);
            if(ФРТ_HIGH == 1 && РТ_продажа2 && РТ_максимум == 0)
               РТ_максимум = РТ_HIGH;
               
            if(ФРТ_LOW == 2 && РТ_покупка2  && РТ_минимум == 0)
               РТ_минимум = РТ_LOW;
        
         }
         
      
         if(Bid > РТ_максимум && РТ_максимум != 0)
            РТ_максимум = 0; 
         if(Ask < РТ_минимум && РТ_минимум != 0)
            РТ_минимум = 0; 
      
      
         if(Bid <= (РТ_максимум - РТ_ПРОФИТ_ТРЕНД2*Point) && РТ_максимум != 0)
         {
            РТ_максимум = 0;
            РТ_покупка2 = true;
            РТ_продажа2 = false;
           
         }
         if(Ask >= (РТ_минимум + РТ_ПРОФИТ_ТРЕНД2*Point) && РТ_минимум != 0)
         {
            РТ_минимум = 0;
            РТ_продажа2 = true;
            РТ_покупка2 = false;
          
         }
         
      }
   }   
   
   if(КОНТРАТАКА)
      if(новая_свеча)
      {
         if(РТ_покупка1 && РТ_покупка2 && QOrders(OP_SELL) == 0 && !дубль_покупки)
         {  
            время_дубль_покупки = TimeCurrent();
            дубль_покупки = true;
         }
         else if(!(РТ_покупка1 && РТ_покупка2))
         {
            время_дубль_покупки = 0;
            дубль_покупки = false;
         }
            
         if(РТ_покупка1 && РТ_покупка2)
         {
            if(QOrdersByProfitByTime(OP_BUY, КАТ_УРОВЕНЬ, время_дубль_покупки) >= КАТ_КОЛИЧЕСТВО_СДЕЛОК)
               КАТ_продажа = true;
            else
               КАТ_продажа = false;
         }
         else
            КАТ_продажа = false;
         
         if(РТ_продажа1 && РТ_продажа2 && QOrders(OP_BUY) == 0 && !дубль_продажи)
         {  
            время_дубль_продажи = TimeCurrent();
            дубль_продажи = true;
         }
         else if(!(РТ_продажа1 && РТ_продажа2))
         {
            время_дубль_продажи = 0;
            дубль_продажи = false;
         }
         if(РТ_продажа1 && РТ_продажа2)
         {
            if(QOrdersByProfitByTime(OP_SELL, КАТ_УРОВЕНЬ, время_дубль_продажи) >= КАТ_КОЛИЧЕСТВО_СДЕЛОК)
               КАТ_покупка = true;
            else 
               КАТ_покупка = false;
         }
         else
            КАТ_покупка = false;
         Comment(QOrdersByProfitByTime(OP_BUY, КАТ_УРОВЕНЬ, время_дубль_покупки), "   ", TimeToStr(время_дубль_покупки), "   ", РТ_покупка1 && РТ_покупка2, "\n",                  
                 QOrdersByProfitByTime(OP_SELL, КАТ_УРОВЕНЬ, время_дубль_продажи), "   ", TimeToStr(время_дубль_продажи), "   ", РТ_продажа1 && РТ_продажа2);

      }
      
   
   if(ЗАЦЕП && новая_свеча)
   {
      if(Зацеп(OP_BUY, ЗЦ_ИНТЕРВАЛ) && QOrders(OP_BUY)==0)
      {
         BuyStopLoss = Low[ЗЦ_ИНТЕРВАЛ+1]-ЗЦ_ЗАЩИТНЫЙ_ИНТЕРВАЛ*Point;
         //if(BuyStopLoss < Bid)
         {
            BUY = true;
            MagicNumber = ЗЦ_MagicNumber;
         }
      }
      else
         BUY = false;
         
      if(Зацеп(OP_SELL, ЗЦ_ИНТЕРВАЛ) && QOrders(OP_SELL)==0)
      {
         SellStopLoss = Low[ЗЦ_ИНТЕРВАЛ+1]+ЗЦ_ЗАЩИТНЫЙ_ИНТЕРВАЛ*Point;
       //  if(SellStopLoss > Ask)
         {
            SELL = true;
            MagicNumber = ЗЦ_MagicNumber;
         }
            
      }
      else
         SELL = false;
   }  
    
   
   bool новый_день = false;
   if(новая_свеча)
   {
      if(DayOfYear() != день)
         новый_день = true;   
      
      //----------------------------------Путешествующий стоп лосс-------------
            
      if(ФMACDОТКР_ФИЛЬТР)
      {
         if(ФMACDОТКР_БЫСТРАЯ_СС > ФMACDОТКР_МЕДЛЕННАЯ_СС)
            return(0);
         ФMACDОТКР = ФMACD_ФИЛЬТР(ФMACDОТКР_ТАЙМФРЕЙМ, ФMACDОТКР_БЫСТРАЯ_СС, ФMACDОТКР_МЕДЛЕННАЯ_СС, ФMACDОТКР_СИГНАЛЬНАЯ_СС, ФMACDОТКР_ЦЕНА, ФMACDОТКР_ПОРОГ_РАЗР, ФMACDОТКР_ПОРОГ_ЗАПР);
         if(ФMACDОТКР == 1)
           ФMACD_открытие_продаж = true;
         else 
           ФMACD_открытие_продаж = false;
         
         if(ФMACDОТКР == -1)
            ФMACD_открытие_покупок = true;
         else 
            ФMACD_открытие_покупок = false;
      }
      else
      {
         ФMACD_открытие_продаж = true;
         ФMACD_открытие_покупок = true;      
      }
      
      if(ФПСС_ФИЛЬТР)
      {
         if(ФПСС_ЦЕНА == 2 || ФПСС_ЦЕНА == 3)
         {
            ФПСС_HIGH = ФМА_ФИЛЬТР(ФПСС_ТИП_ПИКА, ФПСС_СВЕЧИ_СПРАВА, ФПСС_СВЕЧИ_СЛЕВА, ФПСС_ТАЙМФРЕЙМ, ФПСС_ПЕРИОД, ФПСС_МЕТОД, 2, ПСС_HIGH);
            ФПСС_LOW = ФМА_ФИЛЬТР(ФПСС_ТИП_ПИКА, ФПСС_СВЕЧИ_СПРАВА, ФПСС_СВЕЧИ_СЛЕВА, ФПСС_ТАЙМФРЕЙМ, ФПСС_ПЕРИОД, ФПСС_МЕТОД, 3, ПСС_LOW);
         }
         else
         {
            ФПСС_HIGH = ФМА_ФИЛЬТР(ФПСС_ТИП_ПИКА, ФПСС_СВЕЧИ_СПРАВА, ФПСС_СВЕЧИ_СЛЕВА, ФПСС_ТАЙМФРЕЙМ, ФПСС_ПЕРИОД, ФПСС_МЕТОД, ФПСС_ЦЕНА, ПСС_HIGH);
            ФПСС_LOW = ФПСС_HIGH;
            ПСС_LOW = ПСС_HIGH;
         }
         
         if(ФПСС_HIGH == 1 && CurrentProfit(OP_SELL) >= ФПСС_ПОРОГ_СРАБАТЫВАНИЯ)
            модификация_продаж_ПСС = true;
         else if(ФПСС_HIGH == 2)
            модификация_продаж_ПСС = false;
         if(модификация_продаж_ПСС && закрыть_продажу && (ПСС_HIGH+ФПСС_КОРИДОР*Point) > iMA(Symbol(), ФПСС_ТАЙМФРЕЙМ, 1, 0, 0, 2, 0) && количествоПродажТекущее>0)
         {
            
            double ПСС_SellStopLoss = ПСС_HIGH+ФПСС_КОРИДОР*Point;
            if((ПСС_SellStopLoss < SellStopLoss && SellStopLoss!=0) || (ПСС_SellStopLoss >0 && SellStopLoss==0))
            {
               SellStopLoss = ПСС_SellStopLoss;
               if((SellStopLoss<CurrentStopLoss(OP_SELL) && CurrentStopLoss(OP_SELL)!=0))
                  SELL_MODIFY = true;
               else
                  SELL_MODIFY = false;
            }
         }
         
         if(ФПСС_LOW == 2 && CurrentProfit(OP_BUY) >= ФПСС_ПОРОГ_СРАБАТЫВАНИЯ)
            модификация_покупок_ПСС = true;
         else if(ФПСС_LOW == 1)
            модификация_покупок_ПСС = false;
         
         if(модификация_покупок_ПСС && закрыть_покупку && (ПСС_LOW - ФПСС_КОРИДОР*Point) < iMA(Symbol(), ФПСС_ТАЙМФРЕЙМ, 1, 0, 0, 3, 0) ) //количествоПокупокТекущее>0)
         {
            double ПСС_BuyStopLoss = ПСС_LOW - ФПСС_КОРИДОР*Point;
            if(ПСС_BuyStopLoss > BuyStopLoss)
            {
               BuyStopLoss = ПСС_BuyStopLoss;
               if((BuyStopLoss>CurrentStopLoss(OP_BUY) && CurrentStopLoss(OP_BUY)!=0 ))
                  BUY_MODIFY = true;
               else
                  BUY_MODIFY = false;
            }
         }   
      }
      
      if(ФПБЛ_ФИЛЬТР)
      {
         ФПБЛ = ФБЛ_ФИЛЬТР(ФПБЛ_ТАЙМФРЕЙМ, ФПБЛ_ПЕРИОД, ФПБЛ_ОТКЛОНЕНИЕ, ФПБЛ_ЦЕНА, ПБЛ_ВЕРХ, ПБЛ_НИЗ);
         if((ФПБЛ == 1 || ФПБЛ == 0) && закрыть_продажу)
            модификация_продаж_ПБЛ = true;
         else if(ФПБЛ == 2)
            модификация_продаж_ПБЛ = false;
         //если разрешена модификация продаж и стоп=лосс вышел за пределы цены 
         if(модификация_продаж_ПБЛ && (ПБЛ_ВЕРХ+ФПБЛ_КОРИДОР*Point) > iMA(Symbol(), ФПБЛ_ТАЙМФРЕЙМ, 1, 0, 0, 2, 0) && количествоПродажТекущее > 0)
         {
            double ПБЛ_SellStopLoss = ПБЛ_ВЕРХ+ФПБЛ_КОРИДОР*Point;
            if((ПБЛ_SellStopLoss < SellStopLoss && SellStopLoss !=0) || (ПБЛ_SellStopLoss>0 && SellStopLoss == 0))
            {
               SellStopLoss = ПБЛ_SellStopLoss;
               if((SellStopLoss<CurrentStopLoss(OP_SELL) && CurrentStopLoss(OP_SELL)!=0))// || CurrentStopLoss(OP_SELL)==0)
                  SELL_MODIFY = true;
               else 
                  SELL_MODIFY = false;
            }
         }
         
         if((ФПБЛ == 2 || ФПБЛ == 0) && закрыть_покупку)
            модификация_покупок_ПБЛ = true;
         else if(ФПБЛ == 1)
            модификация_покупок_ПБЛ = false;
          
         if(модификация_покупок_ПБЛ && (ПБЛ_НИЗ - ФПБЛ_КОРИДОР*Point) < iMA(Symbol(), ФПБЛ_ТАЙМФРЕЙМ, 1, 0, 0, 3, 0) && количествоПокупокТекущее > 0)
         {
            double ПБЛ_BuyStopLoss = ПБЛ_НИЗ - ФПБЛ_КОРИДОР*Point;
            if(ПБЛ_BuyStopLoss > BuyStopLoss)
            {
               BuyStopLoss = ПБЛ_BuyStopLoss;
               if((BuyStopLoss>CurrentStopLoss(OP_BUY) && CurrentStopLoss(OP_BUY)!=0 && BuyStopLoss < Ask))
                  BUY_MODIFY = true;
               else
                  BUY_MODIFY = false;
            }
         }
      }
      
      
      if(ФПБЛ0_ФИЛЬТР)
      {
         if(ФПБЛ0_ЦЕНАсс == 2 || ФПБЛ0_ЦЕНАсс == 3)
         {
            ФПБЛ0_HIGHсс = ФМА_ФИЛЬТР(ФПБЛ0_ТИП_ПИКА, ФПБЛ0_СВЕЧИ_СПРАВА, ФПБЛ0_СВЕЧИ_СЛЕВА, ФПБЛ0_ТАЙМФРЕЙМсс, ФПБЛ0_ПЕРИОДсс, ФПБЛ0_МЕТОДсс, 2, ПБЛ0_HIGHсс);            
            ФПБЛ0_LOWсс = ФМА_ФИЛЬТР(ФПБЛ0_ТИП_ПИКА, ФПБЛ0_СВЕЧИ_СПРАВА, ФПБЛ0_СВЕЧИ_СЛЕВА, ФПБЛ0_ТАЙМФРЕЙМсс, ФПБЛ0_ПЕРИОДсс, ФПБЛ0_МЕТОДсс, 3, ПБЛ0_HIGHсс);
         }
         else
         {
            ФПБЛ0_HIGHсс = ФМА_ФИЛЬТР(ФПБЛ0_ТИП_ПИКА, ФПБЛ0_СВЕЧИ_СПРАВА, ФПБЛ0_СВЕЧИ_СЛЕВА, ФПБЛ0_ТАЙМФРЕЙМсс, ФПБЛ0_ПЕРИОДсс, ФПБЛ0_МЕТОДсс, ФПБЛ0_ЦЕНАсс, ПБЛ0_HIGHсс);
            ФПБЛ0_LOWсс = ФПБЛ0_HIGHсс;
            ПБЛ0_LOWсс = ПБЛ0_HIGHсс;
         }
         
         if(ФПБЛ0_HIGHсс == 1)
            модификация_продаж_ПБЛ0 = true;
         else if(ФПБЛ0_HIGHсс == 2)
            модификация_продаж_ПБЛ0 = false;
         
         if(ФПБЛ0_LOWсс == 2)
            модификация_покупок_ПБЛ0 = true;
         else if(ФПБЛ0_LOWсс == 1)
            модификация_покупок_ПБЛ0 = false;
            
         ФПБЛ0 = ФБЛ_ФИЛЬТР(ФПБЛ0_ТАЙМФРЕЙМ, ФПБЛ0_ПЕРИОД, ФПБЛ0_ОТКЛОНЕНИЕ, ФПБЛ0_ЦЕНА, ПБЛ0_ВЕРХ, ПБЛ0_НИЗ);
         if((ФПБЛ0 == 1 || ФПБЛ0 == 0) && закрыть_продажу)
            модификация_продаж_ПБЛ0 = true;
         else if(ФПБЛ0 == 2)
            модификация_продаж_ПБЛ0 = false;
         //если разрешена модификация продаж и стоп=лосс вышел за пределы цены 
         if(модификация_продаж_ПБЛ0 && (ПБЛ0_ВЕРХ+ФПБЛ0_КОРИДОР*Point) > iMA(Symbol(), ФПБЛ0_ТАЙМФРЕЙМ, 1, 0, 0, 2, 0) && количествоПродажТекущее > 0)
         {
            double ПБЛ0_SellStopLoss = ПБЛ0_ВЕРХ+ФПБЛ0_КОРИДОР*Point;
            if((ПБЛ0_SellStopLoss < SellStopLoss && SellStopLoss !=0) || (ПБЛ0_SellStopLoss>0 && SellStopLoss == 0))
            {
               SellStopLoss = ПБЛ0_SellStopLoss;
               if((SellStopLoss<CurrentStopLoss(OP_SELL) && CurrentStopLoss(OP_SELL)!=0))// || CurrentStopLoss(OP_SELL)==0)
                  SELL_MODIFY = true;
               else 
                  SELL_MODIFY = false;
            }
         }
         
         if((ФПБЛ0 == 2 || ФПБЛ0 == 0) && закрыть_покупку)
            модификация_покупок_ПБЛ0 = true;
         else if(ФПБЛ0 == 1)
            модификация_покупок_ПБЛ0 = false;
          
         if(модификация_покупок_ПБЛ0 && (ПБЛ0_НИЗ - ФПБЛ0_КОРИДОР*Point) < iMA(Symbol(), ФПБЛ0_ТАЙМФРЕЙМ, 1, 0, 0, 3, 0) && количествоПокупокТекущее > 0)
         {
            double ПБЛ0_BuyStopLoss = ПБЛ0_НИЗ - ФПБЛ0_КОРИДОР*Point;
            if(ПБЛ0_BuyStopLoss > BuyStopLoss)
            {
               BuyStopLoss = ПБЛ0_BuyStopLoss;
               if((BuyStopLoss>CurrentStopLoss(OP_BUY) && CurrentStopLoss(OP_BUY)!=0 && BuyStopLoss < Ask))
                  BUY_MODIFY = true;
               else
                  BUY_MODIFY = false;
            }
         }
      }
      if(ФПСАРА_ФИЛЬТР)
      {
         
         ФПСАРА = ФСАРА_ФИЛЬТР(ФПСАРА_ТАЙМФРЕЙМ, ФПСАРА_ШАГ, ФПСАРА_МАКСИМУМ, ПСАРА);
         
         if(ФПСАРА == 1 && количествоПродажТекущее>0 && закрыть_продажу)
         {
            SellStopLoss = ПСАРА+ФПСАРА_КОРИДОР*Point;
            if(SellStopLoss < CurrentStopLoss(OP_SELL))
               SELL_MODIFY = true;
            BUY_MODIFY = false;
         }
         if(ФПСАРА == 2 && количествоПокупокТекущее > 0 && закрыть_покупку)
         {
            BuyStopLoss = ПСАРА-ФПСАРА_КОРИДОР*Point;
            SELL_MODIFY = false;
            if(BuyStopLoss > CurrentStopLoss(OP_BUY))
               BUY_MODIFY = true;
            
         }
      }
   }
   
   
      
   if(_ЛИНИИ_ТРЕНДА)
   {
      int прорыв_вверх = -1;
      int прорыв_вниз = -1;
      if(ЛТ_ПРЕДВЕСТНИК_СЛЕВА < ЛТ_ПРЕСТУПНИК_СЛЕВА)
         return(0);
      if(новая_свеча)
      {  
         int линия_тренда = ЛинияТренда(0, РЕЖИМ_РИСОВАНИЯ, ЛТ_ВНИЗ_ФАЙЛ, ЛТ_ВВЕРХ_ФАЙЛ, ЛТ_МАКСИМУМ_ФАЙЛ, ЛТ_МИНИМУМ_ФАЙЛ, 
                                       ЛТ_ПРЕДВЕСТНИК_СЛЕВА, ЛТ_ПРЕДВЕСТНИК_СПРАВА, ЛТ_ПРЕСТУПНИК_СЛЕВА, ЛТ_ПРЕСТУПНИК_СПРАВА, 
                                       ЛТ_ТИП_ПЕРЕСЕЧЕНИЯ, ЛТ_ВНИЗ_ЦВЕТ, ЛТ_ВВЕРХ_ЦВЕТ);
        
         switch(линия_тренда)
         {
            case 1:
            новая_ЛТ_вниз = false;
                  break;
            case 2:
                  новая_ЛТ_вниз = true;
                  новая_ЛТ_вверх = false;
                  break;
            case 3:
                  новая_ЛТ_вверх = false;
                  break;
            case 4:
                  новая_ЛТ_вверх = true;
                  новая_ЛТ_вниз = false;
                  break;
         }
         
         линия_тренда_вниз = ЭтоЛинияТренда(ЛТ_ВНИЗ_ФАЙЛ, points_down);
         линия_тренда_вверх = ЭтоЛинияТренда(ЛТ_ВВЕРХ_ФАЙЛ, points_up);
         double ЛТ_dSLoss = 0;
         if(линия_тренда_вниз)
         {
            trendline_down = ЛинияТрендаВТочке("вниз", Time[0], points_down[0], points_down[1]);
            trendline1_down = ЛинияТрендаВТочке("вниз", Time[1], points_down[0], points_down[1]);
            свеча_предвестника_вниз = TimeToBars(points_down[0]);
            свеча_преступника_вниз = TimeToBars(points_down[1]);
            if(Bid>High[свеча_предвестника_вниз])
            {
               линия_тренда_вниз = false;
               ЗакончитьЛиниюТренда(ЛТ_МАКСИМУМ_ФАЙЛ, ЛТ_ВНИЗ_ФАЙЛ);
               SELL = false;
            }
            if(РЕЖИМ_РИСОВАНИЯ/* &&новая_ЛТ_вниз*/)
            {
               DrawExtremum(1, Time[свеча_предвестника_вниз], 1);
               DrawExtremum(1, Time[свеча_преступника_вниз], 2);
            }
         }
        
         if(линия_тренда_вверх)
         {
            trendline_up = ЛинияТрендаВТочке("вверх", Time[0], points_up[0], points_up[1]);
            trendline1_up = ЛинияТрендаВТочке("вверх", Time[1], points_up[0], points_up[1]);
            свеча_предвестника_вверх = TimeToBars(points_up[0]);
            свеча_преступника_вверх = TimeToBars(points_up[1]);
            if(Ask<Low[свеча_предвестника_вверх])
            {
               линия_тренда_вверх = false;
               ЗакончитьЛиниюТренда(ЛТ_МИНИМУМ_ФАЙЛ, ЛТ_ВВЕРХ_ФАЙЛ);
               BUY = false;
            }
            if(РЕЖИМ_РИСОВАНИЯ/* &&новая_ЛТ_вверх*/)
            {
               DrawExtremum(2, Time[свеча_предвестника_вверх], 1);
               DrawExtremum(2, Time[свеча_преступника_вверх], 2);
            }
         }
      }
     
      double ЛТ_предвестник = 0;
      if(новая_ЛТ_вниз)
      {
         
         if(QOrders(OP_BUY) > 0 && закрыть_покупку && ПОДЖАТИЕ_ЛТ)
         {
            BuyStopLoss = Low[свеча_преступника_вниз-П_НОМЕР_СВЕЧИ] - П_ЗАЩИТНЫЙ_ИНТЕРВАЛ*Point;
            if(CurrentStopLoss(OP_BUY) < BuyStopLoss)
               BUY_MODIFY = true;
         }
         
         if(((((РТ_продажа1&&РТ_РЕЖИМ1) || (РТ_продажа2&&РТ_РЕЖИМ2)) && РЕЖИМ_ТЕСТИРОВАНИЯ ) || !РЕЖИМ_ТЕСТИРОВАНИЯ) ||
            (КАТ_продажа && КОНТРАТАКА))
         {
            прорыв_вверх = Прорыв("вниз", trendline_down, trendline1_down, ЛТ_КОРИДОР);
         
            if((ЛТ_КВАЛИФИКАТОР_ПРОРЫВА < 0 && прорыв_вверх >= 0) ||
               (ЛТ_КВАЛИФИКАТОР_ПРОРЫВА == 0 && прорыв_вверх == 0) ||
               (ЛТ_КВАЛИФИКАТОР_ПРОРЫВА > 0 && прорыв_вверх >=0 &&прорыв_вверх != ЛТ_КВАЛИФИКАТОР_ПРОРЫВА))
            {
               if(ОБЩИЙ_ЛОСС)
               {
                  if(количествоПродажТекущее == 0 && SellStopLoss == 0)
                     SellStopLoss = High[свеча_предвестника_вниз]+ЛТ_ЛОСС_ЗАЩ_ИНТЕРВАЛ*Point;         
                  else if(SellStopLoss == 0)
                  {  
                     SellStopLoss = CurrentStopLoss(OP_SELL);
                     SELL_MODIFY = false;
                  }
               }
               else if(количествоПродажТекущее == 0)
               {
                  SellStopLoss = High[свеча_предвестника_вниз]+ЛТ_ЛОСС_ЗАЩ_ИНТЕРВАЛ*Point;         
                  ЛТ_предвестник = High[свеча_предвестника_вниз] - Bid;
               }   
               
               ЛТ_dSLoss = SellStopLoss - Bid;
               if(ЛТ_dSLoss > ЛТ_ЛОСС_МАКСИМАЛЬНЫЙ*Point)
                  SellStopLoss = Bid+ЛТ_ЛОСС_МАКСИМАЛЬНЫЙ*Point;
               
               if(ОБЩИЙ_ПРОФИТ)
               {
                  if(количествоПродажТекущее == 0 && !SELL_MODIFY)// && SellStopLoss == 0)
                      SellTakeProfit = Bid - ЛТ_ПРОФИТ*Point;
                  else 
                  {  
                     SellTakeProfit = CurrentTakeProfit(OP_SELL);
                  
                  }
               }
               else if(количествоПродажТекущее == 0)
                  SellTakeProfit = Bid - ЛТ_ПРОФИТ*Point;
               //if(количествоПродажТекущее>1 && SellStopLoss < CurrentStopLoss(OP_SELL))
        //          SELL_MODIFY = true;
     
               
               if(!SELL_CLOSE && ФMACD_открытие_продаж &&
                  (количествоПродажТекущее <= КОЛИЧЕСТВО_СДЕЛОК) &&
                 (!ФИЛЬТР_МАКСИМАЛЬНОГО_ДВИЖЕНИЯ||ЛТ_предвестник<МД_МАКСИМАЛЬНОЕ_ДВИЖЕНИЕ*Point/* && количествоПродажТекущее == 0*/))//&&
               //  (!ФИЛЬТР_ШАГ_СДЕЛОК || (CurrentOpenPrice(OP_SELL)==0 || ШАГ_СДЕЛОК*Point<=(CurrentOpenPrice(OP_SELL)-Bid))))
               {
                  MagicNumber = ЛТ_MAGIC_NUMBER;
                  if(Bid < (SellStopLoss-50*Point))// && OrdersTotal() == 0)// && (/*(количествоПродажТекущее>0 && CurrentOpenPrice(OP_SELL) < Ask) || */количествоПродажТекущее == 0))
                     SELL = true;
                  новая_ЛТ_вниз = false;
               }
            
               if(SellStopLoss <= Bid && SellStopLoss != 0)
               {
                  линия_тренда_вниз = false;
                  ЗакончитьЛиниюТренда(ЛТ_МАКСИМУМ_ФАЙЛ, ЛТ_ВНИЗ_ФАЙЛ);
                  SELL = false;
               }
            
            }
         }
      }
      if(новая_ЛТ_вверх)
      {
         if(QOrders(OP_SELL) > 0 && закрыть_продажу && ПОДЖАТИЕ_ЛТ)
         {
            SellStopLoss = High[свеча_преступника_вверх-П_НОМЕР_СВЕЧИ] + П_ЗАЩИТНЫЙ_ИНТЕРВАЛ*Point;
            if(CurrentStopLoss(OP_SELL) > SellStopLoss)
               SELL_MODIFY = true;
                  
         }
         if(((((РТ_покупка1&&РТ_РЕЖИМ1) || (РТ_покупка2&& РТ_РЕЖИМ2))&&РЕЖИМ_ТЕСТИРОВАНИЯ) || !РЕЖИМ_ТЕСТИРОВАНИЯ) ||
            (КАТ_покупка && КОНТРАТАКА))
            
         {
            прорыв_вниз = Прорыв("вверх", trendline_up, trendline1_up, ЛТ_КОРИДОР);
            if((ЛТ_КВАЛИФИКАТОР_ПРОРЫВА < 0 && прорыв_вниз >= 0) ||
               (ЛТ_КВАЛИФИКАТОР_ПРОРЫВА == 0 && прорыв_вниз == 0) ||
               (ЛТ_КВАЛИФИКАТОР_ПРОРЫВА > 0 && прорыв_вниз >= 0 && прорыв_вниз != ЛТ_КВАЛИФИКАТОР_ПРОРЫВА))
            {  
               if(ОБЩИЙ_ЛОСС)
               {   
                  if(количествоПокупокТекущее==0)
                     BuyStopLoss = Low[свеча_предвестника_вверх]-ЛТ_ЛОСС_ЗАЩ_ИНТЕРВАЛ*Point;
                  else if(BuyStopLoss == 0)
                  {   
                     BuyStopLoss = CurrentStopLoss(OP_BUY);
                     BUY_MODIFY = false;
                  }
               }
               else if(количествоПокупокТекущее == 0)
               {
               
                  if(BuyStopLoss == 0)
                     BuyStopLoss = Low[свеча_предвестника_вверх]-ЛТ_ЛОСС_ЗАЩ_ИНТЕРВАЛ*Point;
                  ЛТ_предвестник = Ask - Low[свеча_предвестника_вверх];
               }
               ЛТ_dSLoss = Ask - BuyStopLoss;
               if(ЛТ_dSLoss > ЛТ_ЛОСС_МАКСИМАЛЬНЫЙ*Point && BuyStopLoss != 0)
                  BuyStopLoss = Ask - ЛТ_ЛОСС_МАКСИМАЛЬНЫЙ*Point; 
               
               if(ОБЩИЙ_ПРОФИТ)
               {
                  if(количествоПокупокТекущее==0 &&!BUY_MODIFY)// && BuyStopLoss == 0)
                     BuyTakeProfit = Ask + ЛТ_ПРОФИТ*Point;
                  else 
                  {   
                     BuyTakeProfit = CurrentTakeProfit(OP_BUY);
                  
                  }
               }
               else if(количествоПокупокТекущее == 0)
                  BuyTakeProfit = Ask + ЛТ_ПРОФИТ*Point;
            
               if(!BUY_CLOSE && ФMACD_открытие_покупок&&
                 (количествоПокупокТекущее <= КОЛИЧЕСТВО_СДЕЛОК)&&
                 (!ФИЛЬТР_МАКСИМАЛЬНОГО_ДВИЖЕНИЯ||ЛТ_предвестник<МД_МАКСИМАЛЬНОЕ_ДВИЖЕНИЕ*Point/* && количествоПокупокТекущее == 0*/) )//&&
                // (!ФИЛЬТР_ШАГ_СДЕЛОК || (CurrentOpenPrice(OP_BUY)==0 || ШАГ_СДЕЛОК*Point<(Ask-CurrentOpenPrice(OP_BUY)))))
               {
                  MagicNumber = ЛТ_MAGIC_NUMBER;
                //  включить_доп_покупку = true;
                  if(Ask > (50*Point+BuyStopLoss))// && OrdersTotal()==0)// &&(/*(количествоПокупокТекущее>0 && CurrentOpenPrice(OP_BUY) > Bid) || количествоПокупокТекущее == 0))
                     BUY = true;
                  новая_ЛТ_вверх = false;
               }
               if(BuyStopLoss >= Ask)
               {
                  линия_тренда_вверх = false;
                  ЗакончитьЛиниюТренда(ЛТ_МИНИМУМ_ФАЙЛ, ЛТ_ВВЕРХ_ФАЙЛ);
                  BUY = false;
               }
              
            }
         }
      }
      
   }  
   
   
//**************************************************************************    
   //_______________________УПРАВЛЕНИЕ КАПИТАЛОМ______________________________
   //определение общего количество экспертов и определение выделенного депозита для текущег советника
   
   if(СИСТЕМА_УПРАВЛЕНИЯ_КАПИТАЛОМ)
   {
      CurrentDepo=AccountBalance();
      //------------------------1. ПЕРЕКЛЮЧАТЕЛЬ ОБЪЕМОВ-------------------------
      if(CurrentDepo >= 2*СУК_ПЕРЕКЛЮЧАТЕЛЬ*СУК_НАЧ_ДЕПОЗИТ){ //когда текущий объем больше начального в 20 раз
         for(int i = 1; i<=10; i++)
            if(CurrentDepo >= MathPow(СУК_ПЕРЕКЛЮЧАТЕЛЬ, i)*MathPow(2, i)*СУК_НАЧ_ДЕПОЗИТ) {
               StartDepo = MathPow(СУК_ПЕРЕКЛЮЧАТЕЛЬ, i)*MathPow(2,i)*СУК_НАЧ_ДЕПОЗИТ; //меняем планку начального объема
               minLot = MathPow(СУК_ПЕРЕКЛЮЧАТЕЛЬ, i) * СУК_MIN_LOT ; //меняем минимальный шаг 
               delta = MathPow(СУК_ПЕРЕКЛЮЧАТЕЛЬ, i) * СУК_DELTA;  //меняем дельту
            }
      }
     //-------------------------2. ПРЯМОЙ ХОД-------------------------------------
      if(CurrentDepo >= StartDepo){
         Lot = minLot * (MathFloor(0.5*(1+MathSqrt(1+8*(CurrentDepo-StartDepo)/delta))));
         }
      else {
         Lot = minLot;
      }
   
      //------------------------3. РАСЧЕТ ВЫСВОБОЖДЕННЫХ СРЕДСТВ
      if(Lot > tLot){
         kLevel = MathFloor(Lot/minLot);
         FreeDepo = 0.5 * delta * kLevel * (kLevel-1) * (1-СУК_DOWN_RATE);
         rStartDepo = StartDepo+FreeDepo;
         tLot = Lot; //только при повышении объемов
         FileWriteDates(MM_file_name, Lot, rStartDepo, FreeDepo);
      }

      //------------------------4. ОБРАТНЫЙ ХОД----------------------------------------
      if(tDepo > CurrentDepo && Lot >= 2*minLot){
            Lot = minLot * (MathFloor(0.5*(1+MathSqrt(1+8*(CurrentDepo-rStartDepo)/(delta*СУК_DOWN_RATE)))));
            StartDepo = rStartDepo;
            FileWriteDates(MM_file_name, Lot, rStartDepo, FreeDepo);
      }
      if(Lot < tempLot) //запись данных в файл при уменьшении объема
         FileWriteDates(MM_file_name, Lot  , rStartDepo, FreeDepo);
      tDepo = CurrentDepo;   //временно хранит последний уровень объемов
      int error = check_error();
   }
   else 
      Lot = minLot;
   if(Lot >= MarketInfo(Symbol(), MODE_MAXLOT))
      Lot = MarketInfo(Symbol(), MODE_MAXLOT);
   
         
  

   string направление = "";
   if((РТ_продажа1&&РТ_РЕЖИМ1) || (РТ_продажа2&& РТ_РЕЖИМ2))
       направление = "ПОКУПКА";
   if((РТ_покупка1&&РТ_РЕЖИМ1) || (РТ_покупка2&& РТ_РЕЖИМ2))
      направление = "ПРОДАЖА";
   if((РТ_продажа1&&РТ_РЕЖИМ1) || (РТ_продажа2&& РТ_РЕЖИМ2) &&
      (РТ_покупка1&&РТ_РЕЖИМ1) || (РТ_покупка2&& РТ_РЕЖИМ2))
      направление = "ОБА НАПРАВЛЕНИЯ";
   Comment( "\n\nВремя:   ", TimeToStr(TimeCurrent()), 
            "\nТоргуемый объем: ", Lot, "\nНаправление: ", направление, 
             "\n\nТекущая прибыль покупки: ", CurrentProfit(OP_BUY),
            "\n\nТекущая прибыль продажи: ", CurrentProfit(OP_SELL));
        
   //____________________ПОДСИСТЕМА УПРАВЛЕНИЯ СДЕЛКАМИ__________________
   //Нормализация цен:
   BuyTakeProfit = NormalizeDouble(BuyTakeProfit, Digits);      
   BuyStopPrice = NormalizeDouble(BuyStopPrice, Digits);   
   BuyLimitPrice = NormalizeDouble(BuyLimitPrice, Digits);   
   BuyStopLoss = NormalizeDouble(BuyStopLoss, Digits);   
   SellTakeProfit = NormalizeDouble(SellTakeProfit, Digits);   
   SellStopPrice = NormalizeDouble(SellStopPrice, Digits);   
   SellLimitPrice = NormalizeDouble(SellLimitPrice, Digits);   
   SellStopLoss = NormalizeDouble(SellStopLoss, Digits);    
   //-------------------------Закрытие и удаление------------------------
  
   if(BUY_CLOSE && SBCL && количествоПокупокТекущее > 0)
      SBCL = !OCLOSE(OP_BUY, SLIPPAGE, РТ_BColor);
   else
      if(количествоПокупокТекущее == 0)
         SBCL = false;  
    
      
   if(SELL_CLOSE && SSCL && количествоПродажТекущее > 0)
      SSCL = !OCLOSE(OP_SELL, SLIPPAGE, РТ_SColor);
   else
      if(количествоПродажТекущее == 0)
         SSCL = false;
      
   if(BUYLIMIT_DELETE && SBLD && QOrders(OP_BUYLIMIT) > 0)
      SBLD = !ODELETE(OP_BUYLIMIT, РТ_BColor);
   else
      if(QOrders(OP_BUYLIMIT) == 0)
         SBLD = false;
      
   if(BUYSTOP_DELETE && SBSD && QOrders(OP_BUYSTOP) > 0)
      SBSD = !ODELETE(OP_BUYSTOP, РТ_BColor);
   else
      if(QOrders(OP_BUYSTOP) == 0)
         SBSD = false;  
      
   if(SELLLIMIT_DELETE && SSLD && QOrders(OP_SELLLIMIT) > 0)
      SSLD = !ODELETE(OP_SELLLIMIT, РТ_SColor);
   else
      if(QOrders(OP_SELLLIMIT) == 0)
         SSLD = false;
      
   if(SELLSTOP_DELETE && SSSD && QOrders(OP_SELLSTOP) > 0)
      SSSD = !ODELETE(OP_SELLSTOP, РТ_SColor);
      
   else
      if(QOrders(OP_SELLSTOP) == 0)
         SSSD = false;
      
      
   //------------------------------Открытие-------------------------------   
  
   //Немедленно
   //----покупка
   if(BUY && SB)
      SB = !OBUY(Lot, BuyStopLoss, BuyTakeProfit, MagicNumber, SLIPPAGE, РТ_BColor);
 
   //----продажа
   if(SELL && SS)
      SS= !OSELL(Lot, SellStopLoss, SellTakeProfit, MagicNumber, SLIPPAGE, РТ_SColor);   
      
   //ОТЛОЖЕННЫЕ
   //----BUY_STOP
   if(BUY_STOP && SBS)
      SBS = !OBUYSTOP(Lot, BuyStopPrice, BuyStopLoss, BuyTakeProfit, MagicNumber, SLIPPAGE, РТ_BColor);
      
   //----SELL_STOP
   if(SELL_STOP && SSS)      
      SSS = !OSELLSTOP(Lot, SellStopPrice, SellStopLoss, SellTakeProfit, MagicNumber, SLIPPAGE, РТ_SColor);
      
   //----BUY_LIMIT
   if(BUY_LIMIT && SBL)
      SBL = !OBUYLIMIT(Lot, BuyLimitPrice, BuyStopLoss, BuyTakeProfit, MagicNumber, SLIPPAGE, РТ_BColor);
      
   //----SELL_LIMIT
   if(SELL_LIMIT && SSL)
      SSL = !OSELLLIMIT(Lot, SellLimitPrice, SellStopLoss, SellTakeProfit, MagicNumber, SLIPPAGE, РТ_SColor);
      
   //ПОДЖАТИЕ  
   //----модификация покупки
   if(BUY_MODIFY && SBM)
      SBM = !MORDER(OP_BUY, 0, BuyStopLoss, BuyTakeProfit, SLIPPAGE, РТ_BColor);
   else
      if(количествоПокупокТекущее== 0 && QOrders(OP_BUYLIMIT)==0 && QOrders(OP_BUYSTOP)==0)
         SBM = false;
         
   //----модификация продажи
   if(SELL_MODIFY && SSM)
      SSM = !MORDER(OP_SELL, 0, SellStopLoss, SellTakeProfit, SLIPPAGE, РТ_SColor); 
   else
      if(количествоПродажТекущее== 0 && QOrders(OP_SELLLIMIT)==0 && QOrders(OP_SELLSTOP)==0)
         SSM = false;
      
   //----модификация цены BUY_STOP
   if(BUYSTOP_PRICE_MODIFY && SBSM)
      SBSM = !MORDER(OP_BUYSTOP, BuyStopPrice, BuyStopLoss, BuyTakeProfit, SLIPPAGE, РТ_BColor);
   else
      if(QOrders(OP_BUYSTOP)==0)
         SBSM = false;
            
   //----модификация цены SELL_STOP
   if(SELLSTOP_PRICE_MODIFY && SSSM)
      SSSM = !MORDER(OP_SELLSTOP, SellStopPrice, SellStopLoss, SellTakeProfit, SLIPPAGE, РТ_SColor);
   else
      if(QOrders(OP_SELLSTOP)==0)
         SSSM = false;  
          
   //----модификация цены BUY_LIMIT
   if(BUYLIMIT_PRICE_MODIFY && SBLM)
      SBLM = !MORDER(OP_BUYLIMIT, BuyLimitPrice, BuyStopLoss, BuyTakeProfit, SLIPPAGE, РТ_BColor);
   else
      if(QOrders(OP_BUYLIMIT)==0)
         SBLM = false;
            
   //----модификация цены SELL_LIMIT
   if(SELLLIMIT_PRICE_MODIFY && SSLM)
      SSLM = !MORDER(OP_SELLLIMIT, SellLimitPrice, SellStopLoss, SellTakeProfit, SLIPPAGE, РТ_SColor); 
   else
      if(QOrders(OP_SELLLIMIT)==0)
         SSLM = false;   
         
   if(РЕЖИМ_РИСОВАНИЯ && РУЧНАЯ_ТОРГОВЛЯ)
   {
      ПроверкаСостоянияОпераций();
   }
   СбросПараметров();
   
   return(0);

  }

void СбросПараметров(){
   if(!SBCL)
      BUY_CLOSE = false;
   if(!BUY_CLOSE)
      SBCL = true;       
   if(!SSCL)
      SELL_CLOSE = false;
   if(!SELL_CLOSE)
      SSCL = true;  
   if(!SBLD)
      BUYLIMIT_DELETE = false;
   if(!BUYLIMIT_DELETE)
      SBLD = true;  
   if(!SBSD)
      BUYSTOP_DELETE = false;
   if(!BUYSTOP_DELETE)
      SBSD = true;        
   if(!SSLD)
      SELLLIMIT_DELETE = false;
   if(!SELLLIMIT_DELETE)
      SSLD = true;       
   if(!SSSD)
      SELLSTOP_DELETE = false;
   if(!SELLSTOP_DELETE)
      SSSD = true;  
   
   if(!SB)
      BUY = false;
   if(!BUY)
      SB = true; 
      
   if(!SS)
      SELL = false;
   if(!SELL)
      SS = true;  
        
   if(!SBS)
      BUY_STOP = false;
   if(!BUY_STOP)
      SBS = true; 
   if(!SSS)
      SELL_STOP = false;
   if(!SELL_STOP)
      SSS = true; 
   if(!SBL)
      BUY_LIMIT = false;
   if(!BUY_LIMIT)
      SBL = true; 
   if(!SSL)
      SELL_LIMIT = false;
   if(!SELL_LIMIT)
      SSL = true;       
   if(!SBM)
      BUY_MODIFY = false;
   if(!BUY_MODIFY)
      SBM = true;    
   if(!SSM)
      SELL_MODIFY = false;
   if(!SELL_MODIFY)
      SSM = true;
   if(!SBSM)
      BUYSTOP_PRICE_MODIFY = false;
   if(!BUYSTOP_PRICE_MODIFY)
      SBSM = true;  
   if(!SSSM)
      SELLSTOP_PRICE_MODIFY = false;
   if(!SELLSTOP_PRICE_MODIFY)
      SSSM = true; 
   if(!SBLM)
      BUYLIMIT_PRICE_MODIFY = false;
   if(!BUYLIMIT_PRICE_MODIFY)
      SBLM = true; 
   if(!SSLM)
      SELLLIMIT_PRICE_MODIFY = false;
   if(!SELLLIMIT_PRICE_MODIFY)
      SSLM = true; 
      
   день = DayOfYear();
}
//+------------------------------------------------------------------+
////////////////////////РИСОВАНИЕ///////////////////////////////////
/////////////////////////ПОКУПКА/////////////////////////////////////
void РисованиеОбъектовПокупки(int qObjects){
   int q = qObjects;
   double   Y0 = WindowPriceMin(),
            ВЫСОТА_ШРИФТА = ВысотаОкна()/2/15,
            шагY = 1.5*ВЫСОТА_ШРИФТА;
   Y1_BOX = Y0+ВЫСОТА_ШРИФТА;
   Y2_BOX = Y0+(q)*шагY+ВЫСОТА_ШРИФТА;
   double ШАГ_СЕТКИ = WindowBarsPerChart()/3/2;
   datetime X_0 = WindowFirstVisibleBar()-5,
            X_1 = X_0-ШАГ_СЕТКИ,
            ШИРИНА_ЛИНИИ = ШАГ_СЕТКИ-3,
            СЕРЕДИНА_ЛИНИИ = ШИРИНА_ЛИНИИ/2;
   int   X0_1 = Time[X_0],
         X0_2 = Time[X_0 - ШИРИНА_ЛИНИИ],
         X0_T = Time[X_0 - СЕРЕДИНА_ЛИНИИ],
         X1_1 = Time[X_1],
         X1_2 = Time[X_1 - ШИРИНА_ЛИНИИ],
         X1_T = Time[X_1 - СЕРЕДИНА_ЛИНИИ],
         
   X1_BOX = Time[X_0+3];
   X2_BOX = Time[X_1 - ШИРИНА_ЛИНИИ-3];
   Коробка("BOX", X1_BOX, Y1_BOX, X2_BOX, Y2_BOX, STYLE_SOLID, 0, White );
   
   
   Текст(object_name[0][0], X0_T, Y0+q*шагY, object_note[0][0], ВЫСОТА_ШРИФТА, "Times New Roman", РТ_BColor);
   q = q-1;
   Текст(object_name[1][0], X0_T, Y0+q*шагY, object_note[1][0], ВЫСОТА_ШРИФТА, "Times New Roman", РТ_BColor);
   q = q-1;
   Текст(object_name[2][0], X0_T, Y0+q*шагY, object_note[2][0], ВЫСОТА_ШРИФТА, "Times New Roman", РТ_BColor);
   q = q-1;
   Текст(object_name[3][0], X0_T, Y0+q*шагY, object_note[3][0], ВЫСОТА_ШРИФТА, "Times New Roman", РТ_BColor);
   q = q-1;
   Отрезок(object_name[4][0], X0_1, Y0+q*шагY, X0_2, Y0+q*шагY, false, STYLE_DASHDOTDOT, 0, РТ_BTPColor);
   q = q-1;
   Отрезок(object_name[5][0], X0_1, Y0+q*шагY, X0_2, Y0+q*шагY, false, STYLE_SOLID, 1, РТ_BColor);
   q = q-1;
   Отрезок(object_name[6][0], X0_1, Y0+q*шагY, X0_2, Y0+q*шагY, false, STYLE_SOLID, 3, РТ_BColor);
   q = q-1;
   Отрезок(object_name[7][0], X0_1, Y0+q*шагY, X0_2, Y0+q*шагY, false, STYLE_DASHDOT, 0, РТ_BSLColor);
}
/////////////////////////ПРОДАЖА/////////////////////////////////////
void РисованиеОбъектовПродажи(int qObjects){
   int q = qObjects;
   double   Y0 = WindowPriceMin(),
            ВЫСОТА_ШРИФТА = ВысотаОкна()/2/15,
            шагY = 1.5*ВЫСОТА_ШРИФТА;
   Y1_BOX = Y0+ВЫСОТА_ШРИФТА;
   Y2_BOX = Y0+(q)*шагY+ВЫСОТА_ШРИФТА;
   double ШАГ_СЕТКИ = WindowBarsPerChart()/3/2;
   datetime X_0 = WindowFirstVisibleBar()-5,
            X_1 = X_0-ШАГ_СЕТКИ,
            ШИРИНА_ЛИНИИ = ШАГ_СЕТКИ-3,
            СЕРЕДИНА_ЛИНИИ = ШИРИНА_ЛИНИИ/2;
   int   X0_1 = Time[X_0],
         X0_2 = Time[X_0 - ШИРИНА_ЛИНИИ],
         X0_T = Time[X_0 - СЕРЕДИНА_ЛИНИИ],
         X1_1 = Time[X_1],
         X1_2 = Time[X_1 - ШИРИНА_ЛИНИИ],
         X1_T = Time[X_1 - СЕРЕДИНА_ЛИНИИ],
         
   X1_BOX = Time[X_0+3];
   X2_BOX = Time[X_1 - ШИРИНА_ЛИНИИ-3];
   Коробка("BOX", X1_BOX, Y1_BOX, X2_BOX, Y2_BOX, STYLE_SOLID, 0, White );
   Текст(object_name[0][1], X1_T, Y0+q*шагY, object_note[0][1], ВЫСОТА_ШРИФТА, "Times New Roman", РТ_SColor);
   q = q-1;
   Текст(object_name[1][1], X1_T, Y0+q*шагY, object_note[1][1], ВЫСОТА_ШРИФТА, "Times New Roman", РТ_SColor);
   q = q-1;
   Текст(object_name[2][1], X1_T, Y0+q*шагY, object_note[2][1], ВЫСОТА_ШРИФТА, "Times New Roman", РТ_SColor);
   q = q-1;
   Текст(object_name[3][1], X1_T, Y0+q*шагY, object_note[3][1], ВЫСОТА_ШРИФТА, "Times New Roman", РТ_SColor);
   q = q-1;
   Отрезок(object_name[4][1], X1_1, Y0+q*шагY, X1_2, Y0+q*шагY, false, STYLE_DASHDOT, 0, РТ_SSLColor);
   q = q-1;
   Отрезок(object_name[5][1], X1_1, Y0+q*шагY, X1_2, Y0+q*шагY, false, STYLE_SOLID, 3, РТ_SColor);
   q = q-1;
   Отрезок(object_name[6][1], X1_1, Y0+q*шагY, X1_2, Y0+q*шагY, false, STYLE_SOLID, 1, РТ_SColor);
   q = q-1;
   Отрезок(object_name[7][1], X1_1, Y0+q*шагY, X1_2, Y0+q*шагY, false, STYLE_DASHDOTDOT, 0, РТ_STPColor);
}
////////////////////////СМЕЩЕНИЕ///////////////////////////////////
/////////////////////////ПОКУПКА/////////////////////////////////////

void СмещениеОбъектовПокупки(){
   sBUY = СмещениеОбъекта(object_name[0][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sMBUY = СмещениеОбъекта(object_name[1][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sCLBUY = СмещениеОбъекта(object_name[2][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sDPBUY = СмещениеОбъекта(object_name[3][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sBTP = СмещениеОбъекта(object_name[4][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sBSP = СмещениеОбъекта(object_name[5][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sBLP = СмещениеОбъекта(object_name[6][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sBSL = СмещениеОбъекта(object_name[7][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
}
/////////////////////////ПРОДАЖА/////////////////////////////////////
void СмещениеОбъектовПродажи(){
   sSELL = СмещениеОбъекта(object_name[0][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sMSELL = СмещениеОбъекта(object_name[1][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sCLSELL = СмещениеОбъекта(object_name[2][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sDPSELL = СмещениеОбъекта(object_name[3][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sSTP = СмещениеОбъекта(object_name[7][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sSSP = СмещениеОбъекта(object_name[6][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sSLP = СмещениеОбъекта(object_name[5][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sSSL = СмещениеОбъекта(object_name[4][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
}
///////////////////////ПЕРЕРИСОВКА////////////////////////////////////
/////////////////////////ПОКУПКА/////////////////////////////////////

void ПерерисовкаОбъектовПокупки(){
if(!sBUY&&!sMBUY&&!sCLBUY&&!sDPBUY&&!sBTP&&!sBSP&&!sBLP&&!sBSL){
      РисованиеОбъектовПокупки(qObjects);
   }
}
/////////////////////////ПРОДАЖА/////////////////////////////////////
void ПерерисовкаОбъектовПродажи(){
if(!sSELL&&!sMSELL&&!sCLSELL&&!sDPSELL&&!sSTP&&!sSSP&&!sSLP&&!sSSL){
      РисованиеОбъектовПродажи(qObjects);
   }
}
////////////////////////РАСЧЕТ ЦЕН///////////////////////////////////
/////////////////////////ПОКУПКА/////////////////////////////////////

void РасчетЦенПокупки(){
   //Расчет и формирование приказов по покупке   
   if(sBTP)
      BuyTakeProfit = ObjectGet(object_name[4][0], OBJPROP_PRICE1);
   else if(BuyTakeProfit != 0)
      BuyTakeProfit = 0;
      
   if(sBSP)
      BuyStopPrice = ObjectGet(object_name[5][0], OBJPROP_PRICE1);
      
   if(sBLP)
      BuyLimitPrice = ObjectGet(object_name[6][0], OBJPROP_PRICE1);
      
   if(sBSL)
      BuyStopLoss = ObjectGet(object_name[7][0], OBJPROP_PRICE1);
   else if(BuyStopLoss != 0)
      BuyStopLoss = 0;
}
/////////////////////////ПРОДАЖА/////////////////////////////////////
void РасчетЦенПродажи(){
   //Расчет и формирование приказов по продаже
   if(sSTP)
      SellTakeProfit = ObjectGet(object_name[7][1], OBJPROP_PRICE1);
   else if(SellTakeProfit != 0)
      SellTakeProfit = 0;
      
   if(sSSP)
      SellStopPrice = ObjectGet(object_name[6][1], OBJPROP_PRICE1);
      
   if(sSLP)
      SellLimitPrice = ObjectGet(object_name[5][1], OBJPROP_PRICE1);
      
   if(sSSL)
      SellStopLoss = ObjectGet(object_name[4][1], OBJPROP_PRICE1);
   else if(SellStopLoss != 0)
      SellStopLoss = 0;
}
////////////////////////ОТКРЫТИЕ/////////////////////////////////////
/////////////////////////ПОКУПКА/////////////////////////////////////

void ОктрытьПокупку(){
   
   if(sBUY){
      //покупка
      
      if(!sBSP && !sBLP)
         BUY = true;
      
      //отложенная вверх покупка   
      if(sBSP)
         BUY_STOP = true;
      //отложенная вниз покупка   
      if(sBLP)
         BUY_LIMIT = true;
   }
}
/////////////////////////ПРОДАЖА/////////////////////////////////////
void ОктрытьПродажу(){
   
   if(sSELL){
      //покупка
      if(!sSSP && !sSLP)
         SELL = true;
      
      //отложенная вниз продажа   
      if(sSSP)
         SELL_STOP = true;
         
      //отложенная вверх продажа   
      if(sSLP)
         SELL_LIMIT = true;
   }
}
////////////////////////ЗАКРЫТИЕ////////////////////////////////////
/////////////////////////ПОКУПКА/////////////////////////////////////

void ЗакрытьПокупку(){
   //Закрытие покупки
   if(sCLBUY)
      BUY_CLOSE = true;
}
/////////////////////////ПРОДАЖА/////////////////////////////////////
void ЗакрытьПродажу(){
     //Закрытие продажи
   if(sCLSELL)
      SELL_CLOSE = true;
}
////////////////////////УДАЛЕНИЕ/////////////////////////////////////
/////////////////////////ПОКУПКА/////////////////////////////////////

void УдалитьПокупку(){
   //Удаление отложенных ордеров
   if(sDPBUY){
      if(!sBSP && !sBLP)
         РисованиеОбъектовПокупки(qObjects);
      if(sBSP)
         BUYSTOP_DELETE = true;
       
      //удаление отложенной вниз покупки   
      if(sBLP)
         BUYLIMIT_DELETE = true;
   }   
}
/////////////////////////ПРОДАЖА/////////////////////////////////////
void УдалитьПродажу(){
   //Удаление отложенных ордеров
   if(sDPSELL){
      if(!sSSP && !sSLP)
         РисованиеОбъектовПродажи(qObjects);
      
      if(sSSP)
         SELLSTOP_DELETE = true;
      //удаление отложенной вниз покупки   
      if(sSLP)
         SELLLIMIT_DELETE = true;
   }   
}
////////////////////////ИЗМЕНЕНИЕ////////////////////////////////////
/////////////////////////ПОКУПКА/////////////////////////////////////

void ИзменитьПокупку(){
   //Модификация ордеров
   
   if(sMBUY){
      if(!sBTP&&!sBSL&&!sBLP&&!sBSP){
         РисованиеОбъектовПокупки(qObjects);   
      }
      if(sBTP || sBSL)
         BUY_MODIFY = true; 
    
      if(sBLP)
         BUYLIMIT_PRICE_MODIFY = true;
      if(sBSP)
         BUYSTOP_PRICE_MODIFY = true;  
   }  
}
/////////////////////////ПРОДАЖА/////////////////////////////////////
void ИзменитьПродажу(){
   if(sMSELL){
      if(!sSTP&&!sSSL&&!sSLP&&!sSSP){
         РисованиеОбъектовПродажи(qObjects);
      }
      
      if(sSTP || sSSL)
         SELL_MODIFY = true; 
      
      if(sSLP)
         SELLLIMIT_PRICE_MODIFY = true;
      
      if(sSSP)
         SELLSTOP_PRICE_MODIFY = true;  
   }  
}
      
void ПроверкаСостоянияОпераций(){
   if(BUY && !SB)
      РисованиеОбъектовПокупки(qObjects);
   
   if(BUY_STOP && !SBS)
      РисованиеОбъектовПокупки(qObjects);
   
   if(BUY_LIMIT && !SBL)
      РисованиеОбъектовПокупки(qObjects);
   
   if(BUY_CLOSE && !SBCL && количествоПокупокТекущее == 0)
      РисованиеОбъектовПокупки(qObjects);
    
   if(BUYLIMIT_DELETE && !SBLD && QOrders(OP_BUYLIMIT) == 0)
      РисованиеОбъектовПокупки(qObjects);
      
   if(BUYSTOP_DELETE && !SBSD && QOrders(OP_BUYSTOP) == 0)
      РисованиеОбъектовПокупки(qObjects);
   
   if(SELL && !SS)
      РисованиеОбъектовПродажи(qObjects);
   
   if(SELL_STOP && !SSS)
      РисованиеОбъектовПродажи(qObjects);
   
   if(SELL_LIMIT && !SSL)
      РисованиеОбъектовПродажи(qObjects);
   
   if(SELL_CLOSE && !SSCL && количествоПродажТекущее == 0)
      РисованиеОбъектовПродажи(qObjects);
      
   if(SELLLIMIT_DELETE && !SSLD && QOrders(OP_SELLLIMIT) == 0)
      РисованиеОбъектовПродажи(qObjects);
      
   if(SELLSTOP_DELETE && !SSSD && QOrders(OP_SELLSTOP) == 0)
      РисованиеОбъектовПродажи(qObjects);
      
   if(BUY_MODIFY && !SBM)
      РисованиеОбъектовПокупки(qObjects);
      
   if(BUYSTOP_PRICE_MODIFY && !SBSM)
      РисованиеОбъектовПокупки(qObjects);
      
   if(BUYLIMIT_PRICE_MODIFY && !SBLM)
      РисованиеОбъектовПокупки(qObjects);
            
   if(SELL_MODIFY && !SSM)
      РисованиеОбъектовПродажи(qObjects);
      
   if(SELLSTOP_PRICE_MODIFY && !SSSM)
      РисованиеОбъектовПродажи(qObjects);
   
   if(SELLLIMIT_PRICE_MODIFY && !SSLM)
      РисованиеОбъектовПродажи(qObjects);
  
}
    
    

   

