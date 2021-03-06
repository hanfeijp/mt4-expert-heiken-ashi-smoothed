//+------------------------------------------------------------------+
//|                                         Heiken Ashi Smoothed.mq4 |
//|                                                                  |
//|                                                      mod by Raff |
//+------------------------------------------------------------------+
#property copyright "Copyright 2006, Forex-TSD.com "
#property link      "http://www.forex-tsd.com/"
#property strict
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Lime
#property indicator_color3 Red
#property indicator_color4 Lime
//---- parameters
input int MaMetod =2;
input int MaPeriod=6;
input int MaMetod2 =3;
input int MaPeriod2=2;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int OnInit()
  {
//---- indicators
   IndicatorBuffers(8);
   SetIndexStyle(0,DRAW_HISTOGRAM,0,1,Red);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,1,Lime);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,3,Red);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,3,Lime);
   SetIndexBuffer(3,ExtMapBuffer4);
//----
   SetIndexDrawBegin(0,5);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexBuffer(6,ExtMapBuffer7);
   SetIndexBuffer(7,ExtMapBuffer8);
//---- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate (const int rates_total,
                 const int prev_calculated,
                 const datetime& time[],
                 const double& open[],
                 const double& high[],
                 const double& low[],
                 const double& close[],
                 const long& tick_volume[],
                 const long& volume[],
                 const int& spread[])
  {
   double maOpen,maClose,maLow,maHigh;
   double haOpen,haHigh,haLow,haClose;
   if(rates_total<=10) return(rates_total);

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(rates_total);
   if(counted_bars>0) counted_bars--;
   int limit=rates_total-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(1,MathMax(MaPeriod,MaPeriod2));

   int pos=limit;
   while(pos>=0)
     {
      maOpen=iMA(NULL,0,MaPeriod,0,MaMetod,PRICE_OPEN,pos);
      maClose=iMA(NULL,0,MaPeriod,0,MaMetod,PRICE_CLOSE,pos);
      maLow=iMA(NULL,0,MaPeriod,0,MaMetod,PRICE_LOW,pos);
      maHigh=iMA(NULL,0,MaPeriod,0,MaMetod,PRICE_HIGH,pos);
      //----
      haOpen=(ExtMapBuffer5[pos+1]+ExtMapBuffer6[pos+1])/2;
      haClose=(maOpen+maHigh+maLow+maClose)/4;
      haHigh=MathMax(maHigh,MathMax(haOpen,haClose));
      haLow=MathMin(maLow,MathMin(haOpen,haClose));
      if(haOpen<haClose)
        {
         ExtMapBuffer7[pos]=haLow;
         ExtMapBuffer8[pos]=haHigh;
        }
      else
        {
         ExtMapBuffer7[pos]=haHigh;
         ExtMapBuffer8[pos]=haLow;
        }
      ExtMapBuffer5[pos]=haOpen;
      ExtMapBuffer6[pos]=haClose;
      pos--;
     }

   for(int i=0; i<limit; i++) {
      ExtMapBuffer1[i]=iMAOnArray(ExtMapBuffer7,0,MaPeriod2,0,MaMetod2,i);
      ExtMapBuffer2[i]=iMAOnArray(ExtMapBuffer8,0,MaPeriod2,0,MaMetod2,i);
      ExtMapBuffer3[i]=iMAOnArray(ExtMapBuffer5,0,MaPeriod2,0,MaMetod2,i);
      ExtMapBuffer4[i]=iMAOnArray(ExtMapBuffer6,0,MaPeriod2,0,MaMetod2,i);
   }

   return(rates_total);
  }
//+------------------------------------------------------------------+
