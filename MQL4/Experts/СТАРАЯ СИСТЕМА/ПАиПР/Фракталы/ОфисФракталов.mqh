//+------------------------------------------------------------------+
//|                                                �������������.mqh |
//|                                �������������� ������ ������ ���� |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "�������������� ������ ������ ����"
#property link      ""
#property version   "1.00"
#property strict
#include "����������������.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class �������������
  {
private:
   ���������������� *Office[];
   int               ����������������;
   bool              �����������; //1 - ������� ���� (���������), 0 - ������ ���� (��������)
   void              ��������������(int �������);
public:
   ���������������� *��������������(int _���,��� &_���); //�������� ����� ������� � �����
   ���������������� *����������������(int _���,��� &_���); //���������� �������� � �������
   void              ����������������������();
   void              ���������������������(int _���);
   string            ��������������������();
                     �������������();
                    ~�������������();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
�������������::�������������()
  {
   ����������������=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
�������������::~�������������()
  {
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| ������� ����� ������� � ����� (����� ������� �������)            |
//+------------------------------------------------------------------+
���������������� *�������������::��������������(int _���,��� &_���)
  {
   if(_���==1)
     {
      if(ArraySize(Office)<=0)
         �����������=_���.�������������������();

      if(����������������>0)
         for(int ������������=0; ������������<����������������; ������������++)
           {
            if(Office[������������].�����������������(1) && 
               !Office[������������].�����������������(2))
              {
               ������� fractal = new �������(Office[������������].��������������(1,1));
               if((!����������� && fractal.����<_���.����)||
                  (����������� && fractal.����>_���.����))
                 {
                  ��������������(������������);//������� ������� � ������� �����
                 }
              }
           }

      ����������������++;
      ArrayResize(Office,����������������);
      Office[����������������-1]=new ����������������();
      Office[����������������-1].���������������(_���,_���);

     }
   return(Office[����������������-1]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
���������������� *�������������::����������������(int _���,��� &_���)
  {
   bool ������=false;
   ���������������� *�������=new ����������������();
   if(����������������>0)
      for(int ������������=����������������-1; ������������>=0; ������������--)
        {
         if(_���==2 && Office[������������].�����������������(1))
           {
            ������� fractal1=new �������(Office[������������].��������������(1,1));
            if(fractal1.�����<_���.����� && 
               ((fractal1.����>_���.���� && !�����������) || 
               (fractal1.����<_���.���� && �����������))) //***********
              {
               if(!Office[������������].�����������������(2))
                 {
                  Office[������������].���������������(_���,_���);
                  �������=Office[������������];
                 }

               else
                 {
                  ������� fractal2=new �������(Office[������������].��������������(2,1));
                  if(fractal2.�����<_���.����� && 
                   ((fractal2.����>_���.���� && !�����������) || 
                     (fractal2.����<_���.���� && �����������)))//********************
                    {
                     ��������������(������������);
                    }
                 }
              }
           }
         if(_���==3 && Office[������������].�����������������(2) && !Office[������������].�����������������(3))
           {
            ������� fractal21=new �������(Office[������������].��������������(2,1));
            if(fractal21.�����<_���.����� && 
               ((fractal21.����<_���.���� && !�����������) || 
               (fractal21.����>_���.���� && �����������)))
              {
               Office[������������].���������������(_���,_���);
               �������=Office[������������];
              }

           }
        }

   return(�������);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void �������������::��������������(int �������)
  {
   for(int i=�������; i<ArraySize(Office)-1; i++)
      Office[i]=Office[i+1];
   ����������������--;
   ArrayResize(Office,����������������);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string �������������::��������������������()
  {
   string ������="";
   for(int ������������=0; ������������<����������������; ������������++)
      ������=������+IntegerToString(������������)+"\n"+Office[������������].����������������������()+"\n";
   return(������);
  }
//+------------------------------------------------------------------+

void �������������::����������������������()
  {
   for(int ������������=����������������-1; ������������>=0; ������������--)
     {
      if(Office[������������].�����������������(3))
        {
         ��������������(������������);
        }

     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| ������� ������� � ������� ���������� ������ ���                                                                  |
//+------------------------------------------------------------------+

void �������������::���������������������(int _���)
  {
   int ������������������������=����������������-1;
  // Print("������ ��������");
   while((������������������������)>=1)
      if(Office[������������������������].�����������������(_���))
        {
    //    Print("����� �������� ������������ �������", ������������������������);
         for(int ������������=������������������������-1; ������������>=0; ������������--)
           {
      //      Print("����� ������� - ", ������������);
            if(Office[������������].�����������������(_���))
              {
               ������� fractalA = new �������(Office[������������].��������������(_���,1));
               ������� fractalB = new �������(Office[������������������������].��������������(_���,1));
        //       Print("� ������� �", ������������, " ���� ��� � ����� ", _���);
               if(fractalA.�����==fractalB.����� && fractalA.����==fractalB.����)
                 {
          //        Print("������� �������. ������� ������� �", ������������);
                  this.��������������(������������);
                  ������������������������--;
                 }
              }
            else
            {
        //       Print("� ������� �", ������������, " ��� ���� � ����� �", _��� );
               continue;
               }
           }
         ������������������������--;
        }
   else
     {
      ������������������������--;
      //Print("���������� ��������� ������� ", ������������������������);
      continue;
     }
  }
//+------------------------------------------------------------------+
