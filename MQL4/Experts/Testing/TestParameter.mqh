//+------------------------------------------------------------------+
//|                                                TestParameter.mqh |
//|                                                        PKT Group |
//|                                               https://www.pkt.by |
//+------------------------------------------------------------------+
#property copyright "PKT Group"
#property link      "https://www.pkt.by"
#property version   "1.00"
#property strict
class TestParameter
  {
private:

public:
                     enum TEST_PARAMETER{
                        LOSSES,
                        POWER
                     };
   double            power();
   int               losses();
                     TestParameter();
                    ~TestParameter();
  };
TestParameter::TestParameter()
  {
  }
TestParameter::~TestParameter()
  {
  }
//+------------------------------------------------------------------+
int TestParameter::losses(void){
   return (int) TesterStatistics(STAT_CONLOSSMAX_TRADES);;
}

double TestParameter::power(void){
   double profit=TesterStatistics(STAT_PROFIT);
   double dropdown=TesterStatistics(STAT_EQUITY_DD);
   double power = 0;   
   if(dropdown > 0)
      power = profit/dropdown;

   return MathRound(power*100)/100;
}