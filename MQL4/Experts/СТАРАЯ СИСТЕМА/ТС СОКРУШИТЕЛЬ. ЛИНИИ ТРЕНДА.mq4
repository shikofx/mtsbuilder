//+------------------------------------------------------------------+
//|                                                     ��������.mq4 |
//|     Copyright � 2012, �������������� ������ "������ ����"  Corp. |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2012, �������������� ������ ������ ����  Corp."


#include <money_managment_lib.mqh>
#include <Signals.mqh>


extern bool       �����_��������� = false;

extern bool        ������_�������������_�������� = 0; //0 - ��������, 1 - �������
extern int        ��_������������_�������� = 1000; //������������ ���������� ����� ����� �������� � ����-������

bool       ��������_�� = false;
int        �_��������_�������� = 250;
extern int        �_������ = 2900;
int        �_�����_����� = 0;

//����� ������
extern int        ����������_������ = 1; //0 - 1 ������
bool       ������_���_������ = 0; //0 - ��������, 1 - �������
int        ���_������ = 300; //����������� ���������� ����� ��������

bool       �����_���� = false;
bool       �����_������ = false;

extern bool       �������_����������_��������� = false;

extern bool       ����0_������ = true;
extern int        ����0_����������� = 4; //0 - ������ �������� �������, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
extern int        ����0_�������� = 10;
extern int        ����0_������� = 0; //0 - �������, 1 - ����������, 2 - ����������, 3 - �������-����������
extern int        ����0_������ = 6;
extern int        ����0_�����_����� = 2;
extern int        ����0_�����_������ = 5; 
extern int        ����0_���_���� = 1;
extern int        ����0_��������� = 4; //0 - ������ �������� �������, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
extern int        ����0_������ = 15;
extern int        ����0_���������� = 2; 
extern int        ����0_���� = 2; //0...6 - �������, 1 - ����������, 2 - ����������, 3 - �������-����������
extern int        ����0_������� = 0; 

extern bool       ���������� = true;
extern int        ���_������� = -400;
extern int        ���_����������_������ = 2;
bool ���_������� = false;
bool ���_������� = false;

extern bool       ����� = false;
extern int        ��_��������_�������� = 300;
extern int        ��_�������� = 2;//���������� ������ ��� �������
extern int        ��_�������� = 0;//�����  ������� ������ �������� ������
extern int        ��_MagicNumber = 33333;
extern bool       ��������_������� = true;

extern bool       �����_������������ = true;

extern bool       ��_�����1 = true;                            
extern int        ��_������_�����1 = 2900;
extern bool       ��_�����2 = true; 
extern int        ��_������_�����2 = 5400;
extern int        ��_��������� = 4;
extern int        ��_�����_������ = 1;
extern int        ��_�����_����� = 1;
extern int        ��_������ = 40;
extern int        ��_���_���� = 0;
extern int        ��_����� = 0;

bool ��_�������1 = true;
bool ��_�������1 = false;

bool ��_�������2 = true;
bool ��_�������2 = false;

extern bool       ������_��������� = true; //0 - ��������, 1 - �������
extern int        �_�������_��������� = 1000; //������� ���������
extern int        �_������_��������� = 330;

extern bool       ������_���������1 = true; //0 - ��������, 1 - �������
extern int        �_�������_���������1 = 1870; //������� ���������
extern int        �_������_���������1 = 860;

extern bool       ������_���������2 = true; //0 - ��������, 1 - �������
extern int        �_�������_���������2 = 3000; //������� ���������
extern int        �_������_���������2 = 2800;

extern bool       _�����_������ = true;
extern int        ��_����_������������ = 2600;
extern int        ��_����_���_�������� = 300;

extern int        ��_������ = 8000;
extern int        ��_������� = 1200;                                       
extern int        ��_�����������_����� = 2;  //��������� ������ �� ���������� ���� (�����) 
extern int        ��_�����������_������ = 1; //��������� ������ ����� ���������� ���� (������)
extern int        ��_����������_����� = 1;   //��������� ������ �� ���������� ���� (�����) 
extern int        ��_����������_������ = 1;  //��������� ������ ����� ���������� ���� (������)
int        ��_������������_������� = -1;           //-1 - ��� ������� ��������� �������
                                                          //0 - �������� ��� �������������
                                                          //>0 - �������� ���������� ������������
int        ��_���_����������� = 0; //��� ����������� ������ ������ �������������� �����, ��� 
                              //�������� �� ���������� ���� 0 - �� ��������, 1 - �� Close
int        ��_MAGIC_NUMBER = 55555;
color      ��_����_���� = Blue;
color      ��_�����_���� = Red;

extern color      ______��������_______;
//������� �������� �������������� ������
extern bool       �MACD����_������ = true;
extern int        �MACD����_��������� = 4;
extern int        �MACD����_�������_�� = 4;
extern int        �MACD����_���������_�� = 10;
extern int        �MACD����_����������_�� = 1;
extern int        �MACD����_���� = 0;
int        �MACD����_�����_���� = 0;
int        �MACD����_�����_���� = 0;

extern color      ____��������_____;
//�������� �� ���������� �������
extern bool       ����_������ = false;
extern int        ����_�����_������������ = 6000;
extern int        ����_��������� = 0; //0 - ������ �������� �������, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
extern int        ����_������ = 1;
extern int        ����_����� = 0; //0 - �������, 1 - ����������, 2 - ����������, 3 - �������-����������
extern int        ����_���� = 2;
extern int        ����_������� = 500; 
extern int        ����_�����_����� = 3;
extern int        ����_�����_������ = 1; 
extern int        ����_���_���� = 0;
//�������� �� ������ �����������

 bool       ����_������ = false;

 int        ����_��������� = 4; //0 - ������ �������� �������, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
 int        ����_������ = 10;
 int        ����_���������� = 2; 
 int        ����_���� = 0; //0...6 - �������, 1 - ����������, 2 - ����������, 3 - �������-����������
 int        ����_������� = 500; 

//�������� �� ������ SAR
 bool       ������_������ = false;

 int        ������_��������� = 4; //0 - ������ �������� �������, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
 double     ������_��� = 0.02;
 double     ������_�������� = 0.2; 
 int        ������_������� = 200;

extern color      __����������_���������_;
extern int        ���_������������� = 10;

extern double     ���_���_������� = 100; //������� ����������� ��� ������ �������� 
extern int        ���_DELTA = 30;
extern double     ���_MIN_LOT = 0.01; //���������� ����������� ��� ��� ��������� ������ �������
extern double     ���_DOWN_RATE = 1.0; //������ �������� ��� �������� � ������
      
extern bool       ������_�������� = false;
extern color      ��_BColor = LawnGreen;
extern color      ��_BTPColor = MediumSpringGreen;
extern color      ��_BSLColor = YellowGreen;
extern color      ��_SColor = DarkViolet;
extern color      ��_STPColor = MediumVioletRed;
extern color      ��_SSLColor = Violet;
extern int        ��_MAGIC_NUMBER = 10000; //���������� ����� ��� ������ ��������                  

extern color      �����_���������;
extern int        SLIPPAGE = 50; 

//���������� ���������
double   CurrentDepo=0, //������ �������� �������� ��������
         minLot=0,      //������ �������� ������������ ������ ��� �����������
         StartDepo=0, rStartDepo=0, FreeDepo=0, delta=0, Lot=0, tempLot=0, tLot=0, tDepo=0;
int Experts=0, ticket=0, kLevel=0, distance=0, day=0, day1=0, i, j, k, n, fwrite=0;
string   MM_file_name, 
         ��_�������_����, 
         ��_��������_����, 
         ��_�����_����, 
         ��_����_����,
         ������_�������_����, 
         ������_��������_����, 
         ������_�����_����, 
         ������_����_����;
int MM_file_handle=0, LT_file_handle;
//������ ��������
double   Y1_BOX, Y2_BOX;
datetime ��������_�����, X1_BOX = 2, X2_BOX=3;
string object_name[8][2];
string object_note[8][2];

bool  sBUY, sMBUY, sCLBUY, sDPBUY, sBTP, sBSP, sBLP, sBSL, sSELL, sMSELL, sCLSELL, sDPSELL, sSTP, sSSP, sSLP, sSSL;

//���������� ���������� ��������
bool  SB=false, SBS=false, SBL=false, SBM=false, SBSM = false, SBLM = false, SBCL=false, SBSD=false, SBLD=false, 
      SS=false, SSS=false, SSL=false, SSM=false, SSSM = false, SSLM = false, SSCL=false, SSSD=false, SSLD=false, 
      BUY=false, BUY_STOP=false, BUY_LIMIT=false, BUY_MODIFY=false, BUYSTOP_PRICE_MODIFY=false, BUYLIMIT_PRICE_MODIFY = false, BUY_CLOSE=false, BUYLIMIT_DELETE=false, BUYSTOP_DELETE=false,
      SELL=false, SELL_STOP=false, SELL_LIMIT=false, SELL_MODIFY=false, SELLSTOP_PRICE_MODIFY=false, SELLLIMIT_PRICE_MODIFY=false, SELL_CLOSE=false, SELLLIMIT_DELETE=false, SELLSTOP_DELETE=false;
double BuyTakeProfit=0, BuyStopPrice=0, BuyLimitPrice=0, BuyStopLoss=0, BuyOpenPrice,  SellTakeProfit=0, SellStopPrice=0, SellLimitPrice=0, SellStopLoss=0;    
int totalBars = 0;
int qObjects = 8; 
datetime �����_�������_�����;

bool  �����_������ = false,
      �����_������_���� = false,
      �����_������_����� = false;

datetime points_down[2] = {0}; 
datetime points_up[2] = {0}; 
datetime points_down2[2] = {0}; 
datetime points_up2[2] = {0}; 

bool  �����_��_���� = false;
bool  �����_��_����� = false;
bool  �������_���� = false;
bool  �������_���� = false;
bool  ��������_���_������� = false;
bool  ��������_���_������� = false;

bool  �MACD����_������� = false;
bool  �MACD����_������� = false;
int   �MACD���� = 0;

bool  �MACD_��������_������� = false;
bool  �MACD_��������_������ = false;

bool  ��_MACD_������� = false;
bool  ��_MACD_������� = false;
int   ��_MACD = 0;

bool  ��_MACD_��������_������� = false;
bool  ��_MACD_��������_������ = false;

bool  �����_������_���� = false;
bool  �����_������_����� = false;


bool  ����_������� = false;
bool  ����_������� = false;
int   ����_HIGH = 0;
int   ����_LOW = 0;
double ���_HIGH = 0;
double ���_LOW = 0;

bool  ����_������� = false;
bool  ����_������� = false;
int   ���� = 0;
double ���_���� = 0;
double ���_��� = 0;

bool   ����0_�������_�� = false;
bool   ����0_�������_�� = false;
int    ����0_HIGH�� = 0;
int    ����0_LOW�� = 0;
double ���0_HIGH�� = 0;
double ���0_LOW�� = 0;
bool   ����0_������� = false;
bool   ����0_������� = false;
int    ����0 = 0;
double ���0_������ = 0;
double ���0_����� = 0;
double ���0_���� = 0;
double ���0_��� = 0;

bool  ������_������� = false;
bool  ������_������� = false;
int   ������ = 0;
double ����� = 0;

bool �����������_������_��� = false;
bool �����������_�������_��� = false;

bool �����������_������_��� = false;
bool �����������_�������_��� = false;


bool �����������_������_���0 = false;
bool �����������_�������_���0 = false;

bool  �������_������� = false;
bool  �������_������� = false;
int   �������_HIGH = 0;
int   �������_LOW = 0;
double ������ = 0;


bool  ���������_������� = true;
bool  ���������_������� = true;

bool  ���������_�������1 = true;
bool  ���������_�������1= true;

bool  ���������_�������2 = true;
bool  ���������_�������2= true;

double ���� = 0;
double trendline_down, trendline1_down, trendline_up, trendline1_up;

int �����_������������_���� = 0;
int �����_������������_����� = 0;
int �����_�����������_���� = 0;
int �����_�����������_����� = 0;
int ����������_����� = 0;
int ����������_������ = 0;
int ����������_������� = 0;

int �����_���� = 0;
int   ���_HIGH = 0, ���_LOW = 0;
double ��_HIGH = 0, ��_LOW = 0;
double ��_������� = 0, ��_�������� = 0;

bool  �������_������� = false,
      �������_������� = false;

int ��������������������������� = 0,
   �������������������������� = 0,
   ������������������������ = 0,
   ����������������������� = 0;
double high_��2 = 0;
double low_��2 = 0;
bool �����_������� = false, �����_������� = false;
datetime �����_�����_������� = 0, �����_�����_������� = 0;

//-------------------------------------------------- 
int init(){
   //0 - ������ �������� �������, 1=m15, 2=m30, 3=m60, 4=m240, 5=m1440
   ����_��������� = ����������������(����_���������);
   ����_��������� = ����������������(����_���������);
   ����0_����������� = ����������������(����0_�����������);
   ����0_��������� = ����������������(����0_���������);
   ������_��������� = ����������������(������_���������);
   �MACD����_��������� = ����������������(�MACD����_���������);
   ��_��������� = ����������������(��_���������);
   ���� = Day()-1;
   �����_������_���� = ��������������(��_����_����, points_down);
   �����_������_����� = ��������������(��_�����_����, points_up);
   
  
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
      
//���������� ����������

   X1_BOX = 4;   
  // ������������������������(qObjects);
  // ������������������������(qObjects);
   MM_file_name = StringConcatenate("MM_",AccountNumber(), Symbol(), Period(),".csv");
  // EX_file_name_�� = StringConcatenate("EX_��",AccountNumber(), Symbol(), Period(),"_",��_�����������_�����, ��_�����������_������, "+", ��_����������_�����, ��_����������_������, ".csv");
   ��_�������_���� = StringConcatenate("MIN_��_",AccountNumber(), Symbol(), Period(),"_",��_�����������_�����, ��_�����������_������, "+", ��_����������_�����, ��_����������_������, ".csv");
   ��_��������_���� = StringConcatenate("MAX_��_",AccountNumber(), Symbol(), Period(),"_",��_�����������_�����, ��_�����������_������, "+", ��_����������_�����, ��_����������_������, ".csv");
   ��_�����_���� = StringConcatenate("���_��_",AccountNumber(), Symbol(), Period(),"_",��_�����������_�����, ��_�����������_������, "+", ��_����������_�����, ��_����������_������, ".csv");
   ��_����_���� = StringConcatenate("���_��_",AccountNumber(), Symbol(), Period(),"_",��_�����������_�����, ��_�����������_������, "+", ��_����������_�����, ��_����������_������, ".csv");
   
   Experts = SetExpertsQuantity();
   day = Day();
  //  StartDepo = 100;
   delta = ���_DELTA; //������ ��������� ������
   if(���_MIN_LOT == 0){
       minLot=MarketInfo(Symbol(), MODE_MINLOT);
       ���_MIN_LOT=minLot;
   }
   else
       minLot=���_MIN_LOT;
   StartDepo =  ���_���_�������;   
   tLot = minLot; //������ ������� �����
   
   if(�������_����������_���������)
   {
      MM_file_handle = FileOpen(MM_file_name, FILE_CSV|FILE_READ, ';');  
      if(MM_file_handle < 1)
         Print("���� ", MM_file_name, "�� ���������. ��������� ������", GetLastError());   
      else
      {
         FileSeek(MM_file_handle, 0, SEEK_SET);
         Lot = FileReadNumber(MM_file_handle);         //��������� �� ����� Lot 
         StartDepo = FileReadNumber(MM_file_handle);   //��������� �� ����� rStartDepo
         FreeDepo = FileReadNumber(MM_file_handle);    //��������� �� ����� FreeDepo 
         FileClose(MM_file_handle);
      }
   }   
   �����_�������_����� = Time[0];
   return(0);
}

//-------------------------------------------------
int deinit()
   {
      DeinitExpertsQuantiy(Experts);  //�������� �������� �������������� ����������� ���������� ��������� � ���������
      if(��������_�������)
      {
         FileDelete(MM_file_name);
         FileDelete(��_�������_����);
         FileDelete(��_��������_����);
         FileDelete(��_�����_����);
         FileDelete(��_����_����);
         FileDelete(������_�������_����);
         FileDelete(������_��������_����);
         FileDelete(������_�����_����);
         FileDelete(������_����_����);
      }
   //   ObjectsDeleteAll();
      return(0);
   }


datetime  �������_�����=0, tmp_����� = 0; //������������ ����� �� ����� ����� ����������� ������ ���� ������
datetime  time_tmp = 0;
int start()
{
   ��������������������������� = ������������������������;
   �������������������������� = �����������������������;
   
   ������������������������ =    QOrders(OP_BUY);
   ����������������������� = QOrders(OP_SELL);
   
   if(������������������������==0 && ��������������������������� > 1)
      �����_��_����� = true;   
   if(�����������������������==0 && �������������������������� > 1)
      �����_��_���� = true;   
   
   if(������������������������!=0 && CurrentProfit(OP_BUY)>�_������)
      �������_������� = true;
   if(�����������������������!=0 && CurrentProfit(OP_SELL)>�_������)
      �������_������� = true;
   
   if(������������������������ == 0)   
      �������_������� = false;
   if(����������������������� == 0)   
      �������_������� = false;
      
   BuyStopLoss = 0;
   SellStopLoss = 0;
   
    
   bool �����_����� = false;
   if(time_tmp<Time[0] && ����������_����� == 0)
   {
      time_tmp = Time[0];
      �����_����� = true;   
      ����������_�����++;
   }
   else 
      ����������_����� = 0;
      
   int MagicNumber = 0;
   
   
   //__________________������ � �������� �������____________________
   //+++++++++++++++++++++++������ ��������+++++++++++++++++++++++++
   if(������_��������)
   {
      if(totalBars != WindowBarsPerChart())
      {
         totalBars = WindowBarsPerChart(); 
         ������������������������(qObjects);
         ������������������������(qObjects);
      }
      �����������������������();     
      �����������������������();  
      ��������������������������();
      ��������������������������();
      ����������������();
      ����������������();
      ��������������();
      ��������������();
      ��������������();
      ��������������();
      ��������������();
      ��������������();
      ���������������();
      ���������������();
      MagicNumber = ��_MAGIC_NUMBER;
   }
   //+++++++++++++++++++++++++����� ������++++++++++++++++++++++++++
   //��������� ������ ����� �����
   
   if(������_��������� != 0)
   {
      if(���������_�������)
      {
         
         BuyStopLoss = ���������(OP_BUY, �_�������_���������, �_������_���������);
         if(BuyStopLoss > 0  && BuyStopLoss > CurrentStopLoss(OP_BUY))
         {
            BUY_MODIFY = true;
            ���������_������� = false;
         }
      }      
      
      if(���������_�������)
      {
         
         SellStopLoss = ���������(OP_SELL, �_�������_���������, �_������_���������);
         
         if(SellStopLoss > 0 && SellStopLoss < CurrentStopLoss(OP_SELL))
         {
            SELL_MODIFY = true;
            ���������_������� = false;
         }
      }    
      
      if(������������������������ == 0 )
         ���������_������� = true;  
      if(����������������������� == 0)
         ���������_������� = true;     
   } 
   
   if(������_���������1 != 0)
   {
      if(���������_�������1)
      {
         double BuyStopLoss1 = ���������(OP_BUY, �_�������_���������1, �_������_���������1);
         if(BuyStopLoss1 > 0 && BuyStopLoss1 > CurrentStopLoss(OP_BUY))
         {
            BuyStopLoss = BuyStopLoss1;
            BUY_MODIFY = true;
            ���������_�������1 = false;
         }
      }      
      
      if(���������_�������1)
      {
         double SellStopLoss1 = ���������(OP_SELL, �_�������_���������1, �_������_���������1);
         if(SellStopLoss1 > 0 && SellStopLoss1 < CurrentStopLoss(OP_SELL))
         {
            SellStopLoss = SellStopLoss1;
            SELL_MODIFY = true;
            ���������_�������1 = false;
         }
      }    
      
      if(������������������������ == 0 )
         ���������_�������1 = true;  
      if(����������������������� == 0)
         ���������_�������1 = true;     
   } 
   
   if(������_���������2 != 0)
   {
      if(���������_�������2)
      {
         double BuyStopLoss2 = ���������(OP_BUY, �_�������_���������2, �_������_���������2);
         if(BuyStopLoss2 > 0 && BuyStopLoss2 > CurrentStopLoss(OP_BUY))
         {
            BuyStopLoss = BuyStopLoss2;
            BUY_MODIFY = true;
            ���������_�������2 = false;
         }
      }      
      
      if(���������_�������2)
      {
         double SellStopLoss2 = ���������(OP_SELL, �_�������_���������2, �_������_���������2);
         if(SellStopLoss2 > 0 && SellStopLoss2 < CurrentStopLoss(OP_SELL))
         {
            SellStopLoss = SellStopLoss2;
            SELL_MODIFY = true;
            ���������_�������2 = false;
         }
      }    
      
      if(������������������������ == 0 )
         ���������_�������2 = true;  
      if(����������������������� == 0)
         ���������_�������2 = true;     
   } 
   
    
   //�������**************************************************************
   if(�����_������������)
   {
      if(��_�����1)
      {
         datetime �����_��������_������� = 0, 
                  �����_��������_������� = 0;
               
         if(ClosedByProfit(OP_SELL, ��_������_�����1))
            �����_��������_������� = LastClosedTime(OP_SELL);
         if(ClosedByProfit(OP_BUY, ��_������_�����1))
            �����_��������_������� = LastClosedTime(OP_BUY);
         
         if((�������_������� && ��_������_�����1 > 0) || (�����_��������_������� > �����_��������_������� && ��_������_�����1 <0))
         {
            ��_�������1 = true;
            ��_�������1 = false;
         }
         else if((�������_������� && ��_������_�����1 > 0) || (�����_��������_������� > �����_��������_������� && ��_������_�����1 < 0))
         {
            ��_�������1 = true;
            ��_�������1 = false;
         }
      }
      if(��_�����2)   
      {
         if(�����_�����)
         {
            ���_HIGH = ���_������_���(��_���_����, ��_�����_������, ��_�����_�����, ��_���������, ��_������, ��_�����, 2, ��_HIGH);
            ���_LOW = ���_������_���(��_���_����, ��_�����_������, ��_�����_�����, ��_���������, ��_������, ��_�����, 3, ��_LOW);
            ���_������(��_���_����, 1, 1, ��_���������, ��_������, ��_�����, 2, high_��2);
            ���_������(��_���_����, 1, 1, ��_���������, ��_������, ��_�����, 3, low_��2);
            if(���_HIGH == 1 && ��_�������2 && ��_�������� == 0)
               ��_�������� = ��_HIGH;
               
            if(���_LOW == 2 && ��_�������2  && ��_������� == 0)
               ��_������� = ��_LOW;
        
         }
         
      
         if(Bid > ��_�������� && ��_�������� != 0)
            ��_�������� = 0; 
         if(Ask < ��_������� && ��_������� != 0)
            ��_������� = 0; 
      
      
         if(Bid <= (��_�������� - ��_������_�����2*Point) && ��_�������� != 0)
         {
            ��_�������� = 0;
            ��_�������2 = true;
            ��_�������2 = false;
           
         }
         if(Ask >= (��_������� + ��_������_�����2*Point) && ��_������� != 0)
         {
            ��_������� = 0;
            ��_�������2 = true;
            ��_�������2 = false;
          
         }
         
      }
   }   
   
   if(����������)
      if(�����_�����)
      {
         if(��_�������1 && ��_�������2 && QOrders(OP_SELL) == 0 && !�����_�������)
         {  
            �����_�����_������� = TimeCurrent();
            �����_������� = true;
         }
         else if(!(��_�������1 && ��_�������2))
         {
            �����_�����_������� = 0;
            �����_������� = false;
         }
            
         if(��_�������1 && ��_�������2)
         {
            if(QOrdersByProfitByTime(OP_BUY, ���_�������, �����_�����_�������) >= ���_����������_������)
               ���_������� = true;
            else
               ���_������� = false;
         }
         else
            ���_������� = false;
         
         if(��_�������1 && ��_�������2 && QOrders(OP_BUY) == 0 && !�����_�������)
         {  
            �����_�����_������� = TimeCurrent();
            �����_������� = true;
         }
         else if(!(��_�������1 && ��_�������2))
         {
            �����_�����_������� = 0;
            �����_������� = false;
         }
         if(��_�������1 && ��_�������2)
         {
            if(QOrdersByProfitByTime(OP_SELL, ���_�������, �����_�����_�������) >= ���_����������_������)
               ���_������� = true;
            else 
               ���_������� = false;
         }
         else
            ���_������� = false;
         Comment(QOrdersByProfitByTime(OP_BUY, ���_�������, �����_�����_�������), "   ", TimeToStr(�����_�����_�������), "   ", ��_�������1 && ��_�������2, "\n",                  
                 QOrdersByProfitByTime(OP_SELL, ���_�������, �����_�����_�������), "   ", TimeToStr(�����_�����_�������), "   ", ��_�������1 && ��_�������2);

      }
      
   
   if(����� && �����_�����)
   {
      if(�����(OP_BUY, ��_��������) && QOrders(OP_BUY)==0)
      {
         BuyStopLoss = Low[��_��������+1]-��_��������_��������*Point;
         //if(BuyStopLoss < Bid)
         {
            BUY = true;
            MagicNumber = ��_MagicNumber;
         }
      }
      else
         BUY = false;
         
      if(�����(OP_SELL, ��_��������) && QOrders(OP_SELL)==0)
      {
         SellStopLoss = Low[��_��������+1]+��_��������_��������*Point;
       //  if(SellStopLoss > Ask)
         {
            SELL = true;
            MagicNumber = ��_MagicNumber;
         }
            
      }
      else
         SELL = false;
   }  
    
   
   bool �����_���� = false;
   if(�����_�����)
   {
      if(DayOfYear() != ����)
         �����_���� = true;   
      
      //----------------------------------�������������� ���� ����-------------
            
      if(�MACD����_������)
      {
         if(�MACD����_�������_�� > �MACD����_���������_��)
            return(0);
         �MACD���� = �MACD_������(�MACD����_���������, �MACD����_�������_��, �MACD����_���������_��, �MACD����_����������_��, �MACD����_����, �MACD����_�����_����, �MACD����_�����_����);
         if(�MACD���� == 1)
           �MACD_��������_������ = true;
         else 
           �MACD_��������_������ = false;
         
         if(�MACD���� == -1)
            �MACD_��������_������� = true;
         else 
            �MACD_��������_������� = false;
      }
      else
      {
         �MACD_��������_������ = true;
         �MACD_��������_������� = true;      
      }
      
      if(����_������)
      {
         if(����_���� == 2 || ����_���� == 3)
         {
            ����_HIGH = ���_������(����_���_����, ����_�����_������, ����_�����_�����, ����_���������, ����_������, ����_�����, 2, ���_HIGH);
            ����_LOW = ���_������(����_���_����, ����_�����_������, ����_�����_�����, ����_���������, ����_������, ����_�����, 3, ���_LOW);
         }
         else
         {
            ����_HIGH = ���_������(����_���_����, ����_�����_������, ����_�����_�����, ����_���������, ����_������, ����_�����, ����_����, ���_HIGH);
            ����_LOW = ����_HIGH;
            ���_LOW = ���_HIGH;
         }
         
         if(����_HIGH == 1 && CurrentProfit(OP_SELL) >= ����_�����_������������)
            �����������_������_��� = true;
         else if(����_HIGH == 2)
            �����������_������_��� = false;
         if(�����������_������_��� && �������_������� && (���_HIGH+����_�������*Point) > iMA(Symbol(), ����_���������, 1, 0, 0, 2, 0) && �����������������������>0)
         {
            
            double ���_SellStopLoss = ���_HIGH+����_�������*Point;
            if((���_SellStopLoss < SellStopLoss && SellStopLoss!=0) || (���_SellStopLoss >0 && SellStopLoss==0))
            {
               SellStopLoss = ���_SellStopLoss;
               if((SellStopLoss<CurrentStopLoss(OP_SELL) && CurrentStopLoss(OP_SELL)!=0))
                  SELL_MODIFY = true;
               else
                  SELL_MODIFY = false;
            }
         }
         
         if(����_LOW == 2 && CurrentProfit(OP_BUY) >= ����_�����_������������)
            �����������_�������_��� = true;
         else if(����_LOW == 1)
            �����������_�������_��� = false;
         
         if(�����������_�������_��� && �������_������� && (���_LOW - ����_�������*Point) < iMA(Symbol(), ����_���������, 1, 0, 0, 3, 0) ) //������������������������>0)
         {
            double ���_BuyStopLoss = ���_LOW - ����_�������*Point;
            if(���_BuyStopLoss > BuyStopLoss)
            {
               BuyStopLoss = ���_BuyStopLoss;
               if((BuyStopLoss>CurrentStopLoss(OP_BUY) && CurrentStopLoss(OP_BUY)!=0 ))
                  BUY_MODIFY = true;
               else
                  BUY_MODIFY = false;
            }
         }   
      }
      
      if(����_������)
      {
         ���� = ���_������(����_���������, ����_������, ����_����������, ����_����, ���_����, ���_���);
         if((���� == 1 || ���� == 0) && �������_�������)
            �����������_������_��� = true;
         else if(���� == 2)
            �����������_������_��� = false;
         //���� ��������� ����������� ������ � ����=���� ����� �� ������� ���� 
         if(�����������_������_��� && (���_����+����_�������*Point) > iMA(Symbol(), ����_���������, 1, 0, 0, 2, 0) && ����������������������� > 0)
         {
            double ���_SellStopLoss = ���_����+����_�������*Point;
            if((���_SellStopLoss < SellStopLoss && SellStopLoss !=0) || (���_SellStopLoss>0 && SellStopLoss == 0))
            {
               SellStopLoss = ���_SellStopLoss;
               if((SellStopLoss<CurrentStopLoss(OP_SELL) && CurrentStopLoss(OP_SELL)!=0))// || CurrentStopLoss(OP_SELL)==0)
                  SELL_MODIFY = true;
               else 
                  SELL_MODIFY = false;
            }
         }
         
         if((���� == 2 || ���� == 0) && �������_�������)
            �����������_�������_��� = true;
         else if(���� == 1)
            �����������_�������_��� = false;
          
         if(�����������_�������_��� && (���_��� - ����_�������*Point) < iMA(Symbol(), ����_���������, 1, 0, 0, 3, 0) && ������������������������ > 0)
         {
            double ���_BuyStopLoss = ���_��� - ����_�������*Point;
            if(���_BuyStopLoss > BuyStopLoss)
            {
               BuyStopLoss = ���_BuyStopLoss;
               if((BuyStopLoss>CurrentStopLoss(OP_BUY) && CurrentStopLoss(OP_BUY)!=0 && BuyStopLoss < Ask))
                  BUY_MODIFY = true;
               else
                  BUY_MODIFY = false;
            }
         }
      }
      
      
      if(����0_������)
      {
         if(����0_������ == 2 || ����0_������ == 3)
         {
            ����0_HIGH�� = ���_������(����0_���_����, ����0_�����_������, ����0_�����_�����, ����0_�����������, ����0_��������, ����0_�������, 2, ���0_HIGH��);            
            ����0_LOW�� = ���_������(����0_���_����, ����0_�����_������, ����0_�����_�����, ����0_�����������, ����0_��������, ����0_�������, 3, ���0_HIGH��);
         }
         else
         {
            ����0_HIGH�� = ���_������(����0_���_����, ����0_�����_������, ����0_�����_�����, ����0_�����������, ����0_��������, ����0_�������, ����0_������, ���0_HIGH��);
            ����0_LOW�� = ����0_HIGH��;
            ���0_LOW�� = ���0_HIGH��;
         }
         
         if(����0_HIGH�� == 1)
            �����������_������_���0 = true;
         else if(����0_HIGH�� == 2)
            �����������_������_���0 = false;
         
         if(����0_LOW�� == 2)
            �����������_�������_���0 = true;
         else if(����0_LOW�� == 1)
            �����������_�������_���0 = false;
            
         ����0 = ���_������(����0_���������, ����0_������, ����0_����������, ����0_����, ���0_����, ���0_���);
         if((����0 == 1 || ����0 == 0) && �������_�������)
            �����������_������_���0 = true;
         else if(����0 == 2)
            �����������_������_���0 = false;
         //���� ��������� ����������� ������ � ����=���� ����� �� ������� ���� 
         if(�����������_������_���0 && (���0_����+����0_�������*Point) > iMA(Symbol(), ����0_���������, 1, 0, 0, 2, 0) && ����������������������� > 0)
         {
            double ���0_SellStopLoss = ���0_����+����0_�������*Point;
            if((���0_SellStopLoss < SellStopLoss && SellStopLoss !=0) || (���0_SellStopLoss>0 && SellStopLoss == 0))
            {
               SellStopLoss = ���0_SellStopLoss;
               if((SellStopLoss<CurrentStopLoss(OP_SELL) && CurrentStopLoss(OP_SELL)!=0))// || CurrentStopLoss(OP_SELL)==0)
                  SELL_MODIFY = true;
               else 
                  SELL_MODIFY = false;
            }
         }
         
         if((����0 == 2 || ����0 == 0) && �������_�������)
            �����������_�������_���0 = true;
         else if(����0 == 1)
            �����������_�������_���0 = false;
          
         if(�����������_�������_���0 && (���0_��� - ����0_�������*Point) < iMA(Symbol(), ����0_���������, 1, 0, 0, 3, 0) && ������������������������ > 0)
         {
            double ���0_BuyStopLoss = ���0_��� - ����0_�������*Point;
            if(���0_BuyStopLoss > BuyStopLoss)
            {
               BuyStopLoss = ���0_BuyStopLoss;
               if((BuyStopLoss>CurrentStopLoss(OP_BUY) && CurrentStopLoss(OP_BUY)!=0 && BuyStopLoss < Ask))
                  BUY_MODIFY = true;
               else
                  BUY_MODIFY = false;
            }
         }
      }
      if(������_������)
      {
         
         ������ = �����_������(������_���������, ������_���, ������_��������, �����);
         
         if(������ == 1 && �����������������������>0 && �������_�������)
         {
            SellStopLoss = �����+������_�������*Point;
            if(SellStopLoss < CurrentStopLoss(OP_SELL))
               SELL_MODIFY = true;
            BUY_MODIFY = false;
         }
         if(������ == 2 && ������������������������ > 0 && �������_�������)
         {
            BuyStopLoss = �����-������_�������*Point;
            SELL_MODIFY = false;
            if(BuyStopLoss > CurrentStopLoss(OP_BUY))
               BUY_MODIFY = true;
            
         }
      }
   }
   
   
      
   if(_�����_������)
   {
      int ������_����� = -1;
      int ������_���� = -1;
      if(��_�����������_����� < ��_����������_�����)
         return(0);
      if(�����_�����)
      {  
         int �����_������ = �����������(0, �����_���������, ��_����_����, ��_�����_����, ��_��������_����, ��_�������_����, 
                                       ��_�����������_�����, ��_�����������_������, ��_����������_�����, ��_����������_������, 
                                       ��_���_�����������, ��_����_����, ��_�����_����);
        
         switch(�����_������)
         {
            case 1:
            �����_��_���� = false;
                  break;
            case 2:
                  �����_��_���� = true;
                  �����_��_����� = false;
                  break;
            case 3:
                  �����_��_����� = false;
                  break;
            case 4:
                  �����_��_����� = true;
                  �����_��_���� = false;
                  break;
         }
         
         �����_������_���� = ��������������(��_����_����, points_down);
         �����_������_����� = ��������������(��_�����_����, points_up);
         double ��_dSLoss = 0;
         if(�����_������_����)
         {
            trendline_down = �����������������("����", Time[0], points_down[0], points_down[1]);
            trendline1_down = �����������������("����", Time[1], points_down[0], points_down[1]);
            �����_������������_���� = TimeToBars(points_down[0]);
            �����_�����������_���� = TimeToBars(points_down[1]);
            if(Bid>High[�����_������������_����])
            {
               �����_������_���� = false;
               ��������������������(��_��������_����, ��_����_����);
               SELL = false;
            }
            if(�����_���������/* &&�����_��_����*/)
            {
               DrawExtremum(1, Time[�����_������������_����], 1);
               DrawExtremum(1, Time[�����_�����������_����], 2);
            }
         }
        
         if(�����_������_�����)
         {
            trendline_up = �����������������("�����", Time[0], points_up[0], points_up[1]);
            trendline1_up = �����������������("�����", Time[1], points_up[0], points_up[1]);
            �����_������������_����� = TimeToBars(points_up[0]);
            �����_�����������_����� = TimeToBars(points_up[1]);
            if(Ask<Low[�����_������������_�����])
            {
               �����_������_����� = false;
               ��������������������(��_�������_����, ��_�����_����);
               BUY = false;
            }
            if(�����_���������/* &&�����_��_�����*/)
            {
               DrawExtremum(2, Time[�����_������������_�����], 1);
               DrawExtremum(2, Time[�����_�����������_�����], 2);
            }
         }
      }
     
      double ��_����������� = 0;
      if(�����_��_����)
      {
         
         if(QOrders(OP_BUY) > 0 && �������_������� && ��������_��)
         {
            BuyStopLoss = Low[�����_�����������_����-�_�����_�����] - �_��������_��������*Point;
            if(CurrentStopLoss(OP_BUY) < BuyStopLoss)
               BUY_MODIFY = true;
         }
         
         if(((((��_�������1&&��_�����1) || (��_�������2&&��_�����2)) && �����_������������ ) || !�����_������������) ||
            (���_������� && ����������))
         {
            ������_����� = ������("����", trendline_down, trendline1_down, ��_�������);
         
            if((��_������������_������� < 0 && ������_����� >= 0) ||
               (��_������������_������� == 0 && ������_����� == 0) ||
               (��_������������_������� > 0 && ������_����� >=0 &&������_����� != ��_������������_�������))
            {
               if(�����_����)
               {
                  if(����������������������� == 0 && SellStopLoss == 0)
                     SellStopLoss = High[�����_������������_����]+��_����_���_��������*Point;         
                  else if(SellStopLoss == 0)
                  {  
                     SellStopLoss = CurrentStopLoss(OP_SELL);
                     SELL_MODIFY = false;
                  }
               }
               else if(����������������������� == 0)
               {
                  SellStopLoss = High[�����_������������_����]+��_����_���_��������*Point;         
                  ��_����������� = High[�����_������������_����] - Bid;
               }   
               
               ��_dSLoss = SellStopLoss - Bid;
               if(��_dSLoss > ��_����_������������*Point)
                  SellStopLoss = Bid+��_����_������������*Point;
               
               if(�����_������)
               {
                  if(����������������������� == 0 && !SELL_MODIFY)// && SellStopLoss == 0)
                      SellTakeProfit = Bid - ��_������*Point;
                  else 
                  {  
                     SellTakeProfit = CurrentTakeProfit(OP_SELL);
                  
                  }
               }
               else if(����������������������� == 0)
                  SellTakeProfit = Bid - ��_������*Point;
               //if(�����������������������>1 && SellStopLoss < CurrentStopLoss(OP_SELL))
        //          SELL_MODIFY = true;
     
               
               if(!SELL_CLOSE && �MACD_��������_������ &&
                  (����������������������� <= ����������_������) &&
                 (!������_�������������_��������||��_�����������<��_������������_��������*Point/* && ����������������������� == 0*/))//&&
               //  (!������_���_������ || (CurrentOpenPrice(OP_SELL)==0 || ���_������*Point<=(CurrentOpenPrice(OP_SELL)-Bid))))
               {
                  MagicNumber = ��_MAGIC_NUMBER;
                  if(Bid < (SellStopLoss-50*Point))// && OrdersTotal() == 0)// && (/*(�����������������������>0 && CurrentOpenPrice(OP_SELL) < Ask) || */����������������������� == 0))
                     SELL = true;
                  �����_��_���� = false;
               }
            
               if(SellStopLoss <= Bid && SellStopLoss != 0)
               {
                  �����_������_���� = false;
                  ��������������������(��_��������_����, ��_����_����);
                  SELL = false;
               }
            
            }
         }
      }
      if(�����_��_�����)
      {
         if(QOrders(OP_SELL) > 0 && �������_������� && ��������_��)
         {
            SellStopLoss = High[�����_�����������_�����-�_�����_�����] + �_��������_��������*Point;
            if(CurrentStopLoss(OP_SELL) > SellStopLoss)
               SELL_MODIFY = true;
                  
         }
         if(((((��_�������1&&��_�����1) || (��_�������2&& ��_�����2))&&�����_������������) || !�����_������������) ||
            (���_������� && ����������))
            
         {
            ������_���� = ������("�����", trendline_up, trendline1_up, ��_�������);
            if((��_������������_������� < 0 && ������_���� >= 0) ||
               (��_������������_������� == 0 && ������_���� == 0) ||
               (��_������������_������� > 0 && ������_���� >= 0 && ������_���� != ��_������������_�������))
            {  
               if(�����_����)
               {   
                  if(������������������������==0)
                     BuyStopLoss = Low[�����_������������_�����]-��_����_���_��������*Point;
                  else if(BuyStopLoss == 0)
                  {   
                     BuyStopLoss = CurrentStopLoss(OP_BUY);
                     BUY_MODIFY = false;
                  }
               }
               else if(������������������������ == 0)
               {
               
                  if(BuyStopLoss == 0)
                     BuyStopLoss = Low[�����_������������_�����]-��_����_���_��������*Point;
                  ��_����������� = Ask - Low[�����_������������_�����];
               }
               ��_dSLoss = Ask - BuyStopLoss;
               if(��_dSLoss > ��_����_������������*Point && BuyStopLoss != 0)
                  BuyStopLoss = Ask - ��_����_������������*Point; 
               
               if(�����_������)
               {
                  if(������������������������==0 &&!BUY_MODIFY)// && BuyStopLoss == 0)
                     BuyTakeProfit = Ask + ��_������*Point;
                  else 
                  {   
                     BuyTakeProfit = CurrentTakeProfit(OP_BUY);
                  
                  }
               }
               else if(������������������������ == 0)
                  BuyTakeProfit = Ask + ��_������*Point;
            
               if(!BUY_CLOSE && �MACD_��������_�������&&
                 (������������������������ <= ����������_������)&&
                 (!������_�������������_��������||��_�����������<��_������������_��������*Point/* && ������������������������ == 0*/) )//&&
                // (!������_���_������ || (CurrentOpenPrice(OP_BUY)==0 || ���_������*Point<(Ask-CurrentOpenPrice(OP_BUY)))))
               {
                  MagicNumber = ��_MAGIC_NUMBER;
                //  ��������_���_������� = true;
                  if(Ask > (50*Point+BuyStopLoss))// && OrdersTotal()==0)// &&(/*(������������������������>0 && CurrentOpenPrice(OP_BUY) > Bid) || ������������������������ == 0))
                     BUY = true;
                  �����_��_����� = false;
               }
               if(BuyStopLoss >= Ask)
               {
                  �����_������_����� = false;
                  ��������������������(��_�������_����, ��_�����_����);
                  BUY = false;
               }
              
            }
         }
      }
      
   }  
   
   
//**************************************************************************    
   //_______________________���������� ���������______________________________
   //����������� ������ ���������� ��������� � ����������� ����������� �������� ��� ������� ���������
   
   if(�������_����������_���������)
   {
      CurrentDepo=AccountBalance();
      //------------------------1. ������������� �������-------------------------
      if(CurrentDepo >= 2*���_�������������*���_���_�������){ //����� ������� ����� ������ ���������� � 20 ���
         for(int i = 1; i<=10; i++)
            if(CurrentDepo >= MathPow(���_�������������, i)*MathPow(2, i)*���_���_�������) {
               StartDepo = MathPow(���_�������������, i)*MathPow(2,i)*���_���_�������; //������ ������ ���������� ������
               minLot = MathPow(���_�������������, i) * ���_MIN_LOT ; //������ ����������� ��� 
               delta = MathPow(���_�������������, i) * ���_DELTA;  //������ ������
            }
      }
     //-------------------------2. ������ ���-------------------------------------
      if(CurrentDepo >= StartDepo){
         Lot = minLot * (MathFloor(0.5*(1+MathSqrt(1+8*(CurrentDepo-StartDepo)/delta))));
         }
      else {
         Lot = minLot;
      }
   
      //------------------------3. ������ �������������� �������
      if(Lot > tLot){
         kLevel = MathFloor(Lot/minLot);
         FreeDepo = 0.5 * delta * kLevel * (kLevel-1) * (1-���_DOWN_RATE);
         rStartDepo = StartDepo+FreeDepo;
         tLot = Lot; //������ ��� ��������� �������
         FileWriteDates(MM_file_name, Lot, rStartDepo, FreeDepo);
      }

      //------------------------4. �������� ���----------------------------------------
      if(tDepo > CurrentDepo && Lot >= 2*minLot){
            Lot = minLot * (MathFloor(0.5*(1+MathSqrt(1+8*(CurrentDepo-rStartDepo)/(delta*���_DOWN_RATE)))));
            StartDepo = rStartDepo;
            FileWriteDates(MM_file_name, Lot, rStartDepo, FreeDepo);
      }
      if(Lot < tempLot) //������ ������ � ���� ��� ���������� ������
         FileWriteDates(MM_file_name, Lot  , rStartDepo, FreeDepo);
      tDepo = CurrentDepo;   //�������� ������ ��������� ������� �������
      int error = check_error();
   }
   else 
      Lot = minLot;
   if(Lot >= MarketInfo(Symbol(), MODE_MAXLOT))
      Lot = MarketInfo(Symbol(), MODE_MAXLOT);
   
         
  

   string ����������� = "";
   if((��_�������1&&��_�����1) || (��_�������2&& ��_�����2))
       ����������� = "�������";
   if((��_�������1&&��_�����1) || (��_�������2&& ��_�����2))
      ����������� = "�������";
   if((��_�������1&&��_�����1) || (��_�������2&& ��_�����2) &&
      (��_�������1&&��_�����1) || (��_�������2&& ��_�����2))
      ����������� = "��� �����������";
   Comment( "\n\n�����:   ", TimeToStr(TimeCurrent()), 
            "\n��������� �����: ", Lot, "\n�����������: ", �����������, 
             "\n\n������� ������� �������: ", CurrentProfit(OP_BUY),
            "\n\n������� ������� �������: ", CurrentProfit(OP_SELL));
        
   //____________________���������� ���������� ��������__________________
   //������������ ���:
   BuyTakeProfit = NormalizeDouble(BuyTakeProfit, Digits);      
   BuyStopPrice = NormalizeDouble(BuyStopPrice, Digits);   
   BuyLimitPrice = NormalizeDouble(BuyLimitPrice, Digits);   
   BuyStopLoss = NormalizeDouble(BuyStopLoss, Digits);   
   SellTakeProfit = NormalizeDouble(SellTakeProfit, Digits);   
   SellStopPrice = NormalizeDouble(SellStopPrice, Digits);   
   SellLimitPrice = NormalizeDouble(SellLimitPrice, Digits);   
   SellStopLoss = NormalizeDouble(SellStopLoss, Digits);    
   //-------------------------�������� � ��������------------------------
  
   if(BUY_CLOSE && SBCL && ������������������������ > 0)
      SBCL = !OCLOSE(OP_BUY, SLIPPAGE, ��_BColor);
   else
      if(������������������������ == 0)
         SBCL = false;  
    
      
   if(SELL_CLOSE && SSCL && ����������������������� > 0)
      SSCL = !OCLOSE(OP_SELL, SLIPPAGE, ��_SColor);
   else
      if(����������������������� == 0)
         SSCL = false;
      
   if(BUYLIMIT_DELETE && SBLD && QOrders(OP_BUYLIMIT) > 0)
      SBLD = !ODELETE(OP_BUYLIMIT, ��_BColor);
   else
      if(QOrders(OP_BUYLIMIT) == 0)
         SBLD = false;
      
   if(BUYSTOP_DELETE && SBSD && QOrders(OP_BUYSTOP) > 0)
      SBSD = !ODELETE(OP_BUYSTOP, ��_BColor);
   else
      if(QOrders(OP_BUYSTOP) == 0)
         SBSD = false;  
      
   if(SELLLIMIT_DELETE && SSLD && QOrders(OP_SELLLIMIT) > 0)
      SSLD = !ODELETE(OP_SELLLIMIT, ��_SColor);
   else
      if(QOrders(OP_SELLLIMIT) == 0)
         SSLD = false;
      
   if(SELLSTOP_DELETE && SSSD && QOrders(OP_SELLSTOP) > 0)
      SSSD = !ODELETE(OP_SELLSTOP, ��_SColor);
      
   else
      if(QOrders(OP_SELLSTOP) == 0)
         SSSD = false;
      
      
   //------------------------------��������-------------------------------   
  
   //����������
   //----�������
   if(BUY && SB)
      SB = !OBUY(Lot, BuyStopLoss, BuyTakeProfit, MagicNumber, SLIPPAGE, ��_BColor);
 
   //----�������
   if(SELL && SS)
      SS= !OSELL(Lot, SellStopLoss, SellTakeProfit, MagicNumber, SLIPPAGE, ��_SColor);   
      
   //����������
   //----BUY_STOP
   if(BUY_STOP && SBS)
      SBS = !OBUYSTOP(Lot, BuyStopPrice, BuyStopLoss, BuyTakeProfit, MagicNumber, SLIPPAGE, ��_BColor);
      
   //----SELL_STOP
   if(SELL_STOP && SSS)      
      SSS = !OSELLSTOP(Lot, SellStopPrice, SellStopLoss, SellTakeProfit, MagicNumber, SLIPPAGE, ��_SColor);
      
   //----BUY_LIMIT
   if(BUY_LIMIT && SBL)
      SBL = !OBUYLIMIT(Lot, BuyLimitPrice, BuyStopLoss, BuyTakeProfit, MagicNumber, SLIPPAGE, ��_BColor);
      
   //----SELL_LIMIT
   if(SELL_LIMIT && SSL)
      SSL = !OSELLLIMIT(Lot, SellLimitPrice, SellStopLoss, SellTakeProfit, MagicNumber, SLIPPAGE, ��_SColor);
      
   //��������  
   //----����������� �������
   if(BUY_MODIFY && SBM)
      SBM = !MORDER(OP_BUY, 0, BuyStopLoss, BuyTakeProfit, SLIPPAGE, ��_BColor);
   else
      if(������������������������== 0 && QOrders(OP_BUYLIMIT)==0 && QOrders(OP_BUYSTOP)==0)
         SBM = false;
         
   //----����������� �������
   if(SELL_MODIFY && SSM)
      SSM = !MORDER(OP_SELL, 0, SellStopLoss, SellTakeProfit, SLIPPAGE, ��_SColor); 
   else
      if(�����������������������== 0 && QOrders(OP_SELLLIMIT)==0 && QOrders(OP_SELLSTOP)==0)
         SSM = false;
      
   //----����������� ���� BUY_STOP
   if(BUYSTOP_PRICE_MODIFY && SBSM)
      SBSM = !MORDER(OP_BUYSTOP, BuyStopPrice, BuyStopLoss, BuyTakeProfit, SLIPPAGE, ��_BColor);
   else
      if(QOrders(OP_BUYSTOP)==0)
         SBSM = false;
            
   //----����������� ���� SELL_STOP
   if(SELLSTOP_PRICE_MODIFY && SSSM)
      SSSM = !MORDER(OP_SELLSTOP, SellStopPrice, SellStopLoss, SellTakeProfit, SLIPPAGE, ��_SColor);
   else
      if(QOrders(OP_SELLSTOP)==0)
         SSSM = false;  
          
   //----����������� ���� BUY_LIMIT
   if(BUYLIMIT_PRICE_MODIFY && SBLM)
      SBLM = !MORDER(OP_BUYLIMIT, BuyLimitPrice, BuyStopLoss, BuyTakeProfit, SLIPPAGE, ��_BColor);
   else
      if(QOrders(OP_BUYLIMIT)==0)
         SBLM = false;
            
   //----����������� ���� SELL_LIMIT
   if(SELLLIMIT_PRICE_MODIFY && SSLM)
      SSLM = !MORDER(OP_SELLLIMIT, SellLimitPrice, SellStopLoss, SellTakeProfit, SLIPPAGE, ��_SColor); 
   else
      if(QOrders(OP_SELLLIMIT)==0)
         SSLM = false;   
         
   if(�����_��������� && ������_��������)
   {
      �������������������������();
   }
   ���������������();
   
   return(0);

  }

void ���������������(){
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
      
   ���� = DayOfYear();
}
//+------------------------------------------------------------------+
////////////////////////���������///////////////////////////////////
/////////////////////////�������/////////////////////////////////////
void ������������������������(int qObjects){
   int q = qObjects;
   double   Y0 = WindowPriceMin(),
            ������_������ = ����������()/2/15,
            ���Y = 1.5*������_������;
   Y1_BOX = Y0+������_������;
   Y2_BOX = Y0+(q)*���Y+������_������;
   double ���_����� = WindowBarsPerChart()/3/2;
   datetime X_0 = WindowFirstVisibleBar()-5,
            X_1 = X_0-���_�����,
            ������_����� = ���_�����-3,
            ��������_����� = ������_�����/2;
   int   X0_1 = Time[X_0],
         X0_2 = Time[X_0 - ������_�����],
         X0_T = Time[X_0 - ��������_�����],
         X1_1 = Time[X_1],
         X1_2 = Time[X_1 - ������_�����],
         X1_T = Time[X_1 - ��������_�����],
         
   X1_BOX = Time[X_0+3];
   X2_BOX = Time[X_1 - ������_�����-3];
   �������("BOX", X1_BOX, Y1_BOX, X2_BOX, Y2_BOX, STYLE_SOLID, 0, White );
   
   
   �����(object_name[0][0], X0_T, Y0+q*���Y, object_note[0][0], ������_������, "Times New Roman", ��_BColor);
   q = q-1;
   �����(object_name[1][0], X0_T, Y0+q*���Y, object_note[1][0], ������_������, "Times New Roman", ��_BColor);
   q = q-1;
   �����(object_name[2][0], X0_T, Y0+q*���Y, object_note[2][0], ������_������, "Times New Roman", ��_BColor);
   q = q-1;
   �����(object_name[3][0], X0_T, Y0+q*���Y, object_note[3][0], ������_������, "Times New Roman", ��_BColor);
   q = q-1;
   �������(object_name[4][0], X0_1, Y0+q*���Y, X0_2, Y0+q*���Y, false, STYLE_DASHDOTDOT, 0, ��_BTPColor);
   q = q-1;
   �������(object_name[5][0], X0_1, Y0+q*���Y, X0_2, Y0+q*���Y, false, STYLE_SOLID, 1, ��_BColor);
   q = q-1;
   �������(object_name[6][0], X0_1, Y0+q*���Y, X0_2, Y0+q*���Y, false, STYLE_SOLID, 3, ��_BColor);
   q = q-1;
   �������(object_name[7][0], X0_1, Y0+q*���Y, X0_2, Y0+q*���Y, false, STYLE_DASHDOT, 0, ��_BSLColor);
}
/////////////////////////�������/////////////////////////////////////
void ������������������������(int qObjects){
   int q = qObjects;
   double   Y0 = WindowPriceMin(),
            ������_������ = ����������()/2/15,
            ���Y = 1.5*������_������;
   Y1_BOX = Y0+������_������;
   Y2_BOX = Y0+(q)*���Y+������_������;
   double ���_����� = WindowBarsPerChart()/3/2;
   datetime X_0 = WindowFirstVisibleBar()-5,
            X_1 = X_0-���_�����,
            ������_����� = ���_�����-3,
            ��������_����� = ������_�����/2;
   int   X0_1 = Time[X_0],
         X0_2 = Time[X_0 - ������_�����],
         X0_T = Time[X_0 - ��������_�����],
         X1_1 = Time[X_1],
         X1_2 = Time[X_1 - ������_�����],
         X1_T = Time[X_1 - ��������_�����],
         
   X1_BOX = Time[X_0+3];
   X2_BOX = Time[X_1 - ������_�����-3];
   �������("BOX", X1_BOX, Y1_BOX, X2_BOX, Y2_BOX, STYLE_SOLID, 0, White );
   �����(object_name[0][1], X1_T, Y0+q*���Y, object_note[0][1], ������_������, "Times New Roman", ��_SColor);
   q = q-1;
   �����(object_name[1][1], X1_T, Y0+q*���Y, object_note[1][1], ������_������, "Times New Roman", ��_SColor);
   q = q-1;
   �����(object_name[2][1], X1_T, Y0+q*���Y, object_note[2][1], ������_������, "Times New Roman", ��_SColor);
   q = q-1;
   �����(object_name[3][1], X1_T, Y0+q*���Y, object_note[3][1], ������_������, "Times New Roman", ��_SColor);
   q = q-1;
   �������(object_name[4][1], X1_1, Y0+q*���Y, X1_2, Y0+q*���Y, false, STYLE_DASHDOT, 0, ��_SSLColor);
   q = q-1;
   �������(object_name[5][1], X1_1, Y0+q*���Y, X1_2, Y0+q*���Y, false, STYLE_SOLID, 3, ��_SColor);
   q = q-1;
   �������(object_name[6][1], X1_1, Y0+q*���Y, X1_2, Y0+q*���Y, false, STYLE_SOLID, 1, ��_SColor);
   q = q-1;
   �������(object_name[7][1], X1_1, Y0+q*���Y, X1_2, Y0+q*���Y, false, STYLE_DASHDOTDOT, 0, ��_STPColor);
}
////////////////////////��������///////////////////////////////////
/////////////////////////�������/////////////////////////////////////

void �����������������������(){
   sBUY = ���������������(object_name[0][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sMBUY = ���������������(object_name[1][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sCLBUY = ���������������(object_name[2][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sDPBUY = ���������������(object_name[3][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sBTP = ���������������(object_name[4][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sBSP = ���������������(object_name[5][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sBLP = ���������������(object_name[6][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sBSL = ���������������(object_name[7][0], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
}
/////////////////////////�������/////////////////////////////////////
void �����������������������(){
   sSELL = ���������������(object_name[0][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sMSELL = ���������������(object_name[1][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sCLSELL = ���������������(object_name[2][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sDPSELL = ���������������(object_name[3][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sSTP = ���������������(object_name[7][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sSSP = ���������������(object_name[6][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sSLP = ���������������(object_name[5][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
   sSSL = ���������������(object_name[4][1], X1_BOX, Y1_BOX, X2_BOX, Y2_BOX);
}
///////////////////////�����������////////////////////////////////////
/////////////////////////�������/////////////////////////////////////

void ��������������������������(){
if(!sBUY&&!sMBUY&&!sCLBUY&&!sDPBUY&&!sBTP&&!sBSP&&!sBLP&&!sBSL){
      ������������������������(qObjects);
   }
}
/////////////////////////�������/////////////////////////////////////
void ��������������������������(){
if(!sSELL&&!sMSELL&&!sCLSELL&&!sDPSELL&&!sSTP&&!sSSP&&!sSLP&&!sSSL){
      ������������������������(qObjects);
   }
}
////////////////////////������ ���///////////////////////////////////
/////////////////////////�������/////////////////////////////////////

void ����������������(){
   //������ � ������������ �������� �� �������   
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
/////////////////////////�������/////////////////////////////////////
void ����������������(){
   //������ � ������������ �������� �� �������
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
////////////////////////��������/////////////////////////////////////
/////////////////////////�������/////////////////////////////////////

void ��������������(){
   
   if(sBUY){
      //�������
      
      if(!sBSP && !sBLP)
         BUY = true;
      
      //���������� ����� �������   
      if(sBSP)
         BUY_STOP = true;
      //���������� ���� �������   
      if(sBLP)
         BUY_LIMIT = true;
   }
}
/////////////////////////�������/////////////////////////////////////
void ��������������(){
   
   if(sSELL){
      //�������
      if(!sSSP && !sSLP)
         SELL = true;
      
      //���������� ���� �������   
      if(sSSP)
         SELL_STOP = true;
         
      //���������� ����� �������   
      if(sSLP)
         SELL_LIMIT = true;
   }
}
////////////////////////��������////////////////////////////////////
/////////////////////////�������/////////////////////////////////////

void ��������������(){
   //�������� �������
   if(sCLBUY)
      BUY_CLOSE = true;
}
/////////////////////////�������/////////////////////////////////////
void ��������������(){
     //�������� �������
   if(sCLSELL)
      SELL_CLOSE = true;
}
////////////////////////��������/////////////////////////////////////
/////////////////////////�������/////////////////////////////////////

void ��������������(){
   //�������� ���������� �������
   if(sDPBUY){
      if(!sBSP && !sBLP)
         ������������������������(qObjects);
      if(sBSP)
         BUYSTOP_DELETE = true;
       
      //�������� ���������� ���� �������   
      if(sBLP)
         BUYLIMIT_DELETE = true;
   }   
}
/////////////////////////�������/////////////////////////////////////
void ��������������(){
   //�������� ���������� �������
   if(sDPSELL){
      if(!sSSP && !sSLP)
         ������������������������(qObjects);
      
      if(sSSP)
         SELLSTOP_DELETE = true;
      //�������� ���������� ���� �������   
      if(sSLP)
         SELLLIMIT_DELETE = true;
   }   
}
////////////////////////���������////////////////////////////////////
/////////////////////////�������/////////////////////////////////////

void ���������������(){
   //����������� �������
   
   if(sMBUY){
      if(!sBTP&&!sBSL&&!sBLP&&!sBSP){
         ������������������������(qObjects);   
      }
      if(sBTP || sBSL)
         BUY_MODIFY = true; 
    
      if(sBLP)
         BUYLIMIT_PRICE_MODIFY = true;
      if(sBSP)
         BUYSTOP_PRICE_MODIFY = true;  
   }  
}
/////////////////////////�������/////////////////////////////////////
void ���������������(){
   if(sMSELL){
      if(!sSTP&&!sSSL&&!sSLP&&!sSSP){
         ������������������������(qObjects);
      }
      
      if(sSTP || sSSL)
         SELL_MODIFY = true; 
      
      if(sSLP)
         SELLLIMIT_PRICE_MODIFY = true;
      
      if(sSSP)
         SELLSTOP_PRICE_MODIFY = true;  
   }  
}
      
void �������������������������(){
   if(BUY && !SB)
      ������������������������(qObjects);
   
   if(BUY_STOP && !SBS)
      ������������������������(qObjects);
   
   if(BUY_LIMIT && !SBL)
      ������������������������(qObjects);
   
   if(BUY_CLOSE && !SBCL && ������������������������ == 0)
      ������������������������(qObjects);
    
   if(BUYLIMIT_DELETE && !SBLD && QOrders(OP_BUYLIMIT) == 0)
      ������������������������(qObjects);
      
   if(BUYSTOP_DELETE && !SBSD && QOrders(OP_BUYSTOP) == 0)
      ������������������������(qObjects);
   
   if(SELL && !SS)
      ������������������������(qObjects);
   
   if(SELL_STOP && !SSS)
      ������������������������(qObjects);
   
   if(SELL_LIMIT && !SSL)
      ������������������������(qObjects);
   
   if(SELL_CLOSE && !SSCL && ����������������������� == 0)
      ������������������������(qObjects);
      
   if(SELLLIMIT_DELETE && !SSLD && QOrders(OP_SELLLIMIT) == 0)
      ������������������������(qObjects);
      
   if(SELLSTOP_DELETE && !SSSD && QOrders(OP_SELLSTOP) == 0)
      ������������������������(qObjects);
      
   if(BUY_MODIFY && !SBM)
      ������������������������(qObjects);
      
   if(BUYSTOP_PRICE_MODIFY && !SBSM)
      ������������������������(qObjects);
      
   if(BUYLIMIT_PRICE_MODIFY && !SBLM)
      ������������������������(qObjects);
            
   if(SELL_MODIFY && !SSM)
      ������������������������(qObjects);
      
   if(SELLSTOP_PRICE_MODIFY && !SSSM)
      ������������������������(qObjects);
   
   if(SELLLIMIT_PRICE_MODIFY && !SSLM)
      ������������������������(qObjects);
  
}
    
    

   

