//+------------------------------------------------------------------+
//|                                                         math.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property strict

//+------------------------------------------------------------------+
//| Герерирует случайные числа от -precision до +precision           |
//+------------------------------------------------------------------+

int randInt(double precision){
   return (int) (-precision + 2 * precision * rand() / 32768 + 1);
}