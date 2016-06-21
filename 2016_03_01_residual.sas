data MIT;
infile "J:\STAT 5250 Spring 2011\SAS code\mit.txt";
input ID Age AgeM time fat;
timespline=max(time,0);
timeclass=time;
run;

proc mixed;
class id timeclass;
model fat= time timespline /s outpm=scaledresid vciry;
random intercept time timespline/type=un subject=id g v;
repeated timeclass/type=simple subject=id r;
run;

proc print data=scaledresid;
var id time ScaledResid;
run;

proc univariate normal plot data=scaledresid;
var scaledresid;
run;

proc contents data=scaledresid;
run;

symbol1 color=black value=dot ;   
 proc gplot data=scaledresid; 
 plot resid*pred; 
 run;

 proc loess data=scaledresid; 
 model resid=pred/smooth=1 degree=2; 
 ods output OutputStatistics=Results; 
 run;

 proc print data=Results(obs=5);  
     id obs; 
 run;

proc contents data=results;
run;

symbol1 color=black value=dot;   
   symbol2 color=black interpol=join value=none; 
 
   /* macro used in subsequent examples */ 
   %let opts=vaxis=axis1 hm=3 vm=3 overlay; 
 
   axis1 label=(angle=90 rotate=0); 
 proc gplot data=Results;  
 title1 'residual versus predicted value'; 
 plot  DepVar*pred Pred2*pred/&opts; 
 run;

 






 proc loess data=scaledresid; 
      model resid=pred/smooth=0.1 0.2 0.3 0.4 residual; 
	  *model resid=pred/degree=1 2 3 4 residual; 
      ods output OutputStatistics=Results; 
   run;
    goptions  nodisplay; 
   proc gplot data=Results; 
      by SmoothingParameter; 
      plot DepVar*pred=1 Pred2*pred/ &opts name='fit'; 
   run; quit; 
 
   goptions display; 
   proc greplay nofs tc=sashelp.templt template=l2r2; 
       igout gseg; 
       treplay 1:fit 2:fit2 3:fit1 4:fit3; 
   run; quit;


