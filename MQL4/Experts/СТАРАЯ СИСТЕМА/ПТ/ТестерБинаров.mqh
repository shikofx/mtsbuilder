//+------------------------------------------------------------------+
//|                                                �������������.mqh |
//|                                �������������� ������ ������ ���� |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "�������������� ������ ������ ����"
#property link      ""
#property version   "1.00"
#property strict
#include  "../����������/���������.mqh"
#include  "������������������.mqh"
#include  "����������������������.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class �������������
  {
private:
   double            ���������;
   double            ������[];
   double            ����������������[];
   double            ���������[];
   double            �������������[];
   double            ������[];
   double            ������������[];
   int               �����_������;
   string            ��������;

public:
   ������������������ *box_parameters;
   ���������������������� *test_result;
                     �������������(������������������ *_parameters, ���������������������� *_result);
                    ~�������������();
   void              ������������������();
   void              �����������();
   void              ��������������������();
   void              �������������();
   void              �����();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
�������������::�������������(������������������ *_parameters, ���������������������� *_result)
  {
   box_parameters= _parameters;
   ��������="������_"+EnumToString(box_parameters.���_��������)+"_"+EnumToString(box_parameters.�������_��������)+"_"+Symbol()+"_"+EnumToString(box_parameters.���������_���������)+"_.csv";
   �����_������=OrdersHistoryTotal();
   test_result = _result;
   if(�����_������>0)
     {
      ArrayResize(�������������,�����_������);
      ArrayResize(������������,�����_������);
      ArrayResize(������,�����_������);
      ArrayResize(������,�����_������);
      for(int i=0; i<�����_������; i++)
        {
         �������������[i]=0;
         ������������[i]=0;
         ������[i]=0;
         ������[i]=0;

        }
     }

   ���������=box_parameters.�������_����������/100;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
�������������::~�������������()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void �������������::������������������()
  {
   if(�����_������>0)
      for(int i=0; i<�����_������; i++)
        {

         bool choice=OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
         �������������[i]=OrderProfit();

         if(OrderProfit()<=0)
           {
            ������[i]=-1;
            test_result.����������_�������++;
           }
         else
           {
            ������[i]=���������;
            test_result.����������_��������++;
           }
        }

   int �����_�������=1;
   double ������=1;
   if(�����_������>0)
      ������������[0]=������[0];
   if(�����_������>1)
      for(int i=1; i<�����_������; i++)
        {
         if(������[i-1]<0)
           {
            �����_�������++;
            if(�����_�������<(box_parameters.�����_��������+2))
              {
               ������=������*box_parameters.������_�������[�����_�������-2];
               ������������[i]=������[i]*������;
              }
            else
              {
               ������������[i]=������[i];
               �����_�������=1;
               ������=1;
              }
           }
         else
           {
            ������������[i]=������[i];

            �����_�������=1;
            ������=1;
           }

        }

  }
//+------------------------------------------------------------------+

void �������������::�����������()
  {
   if(�����_������>0)
      ������[0]=������������[0];
   if(�����_������>1)
      for(int i=1; i<�����_������; i++)
        {
         ������[i]=������[i-1]+������������[i];
        }
  }
//+------------------------------------------------------------------+

void �������������::��������������������()
  {
   double max = 0;
   double min = 0;
   double ��������=0;
   double maxPr=0,Pr=0;
   if(�����_������>0)
      max=������[0];
   if(�����_������>1)
      for(int i=1; i<�����_������; i++)
        {
         if(max<������[i])
           {
            max=������[i];
            min=0;
            ��������=0;
           }
         else
           {
            min=������[i];
            ��������=max-min;
            if(��������!=0 && test_result.������������_��������<��������)
               test_result.������������_��������=��������;
           }
        }
  }
//+------------------------------------------------------------------+
void �������������::�������������()
  {
   this.������������������();
   this.�����������();
   this.��������������������();
   if(�����_������>0)
      test_result.������_�������=������[�����_������-1];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void �������������::�����()
  {
   string strBinar="\n������ ������� = "+DoubleToStr(test_result.������_�������)+"\n������������ �������� = "+DoubleToStr(test_result.������������_��������)+"\n";
   if(�����_������>0)
      for(int i=0; i<�����_������; i++)
        {
         strBinar=strBinar+"\n"+DoubleToString(�������������[i])+";"+DoubleToString(������[i])+";"+DoubleToString(������������[i])+";"+DoubleToString(������[i]);
        }

   int handle = FileOpen(��������,FILE_WRITE|FILE_CSV);
   FileWriteString(handle, strBinar);
  }
//+------------------------------------------------------------------+
