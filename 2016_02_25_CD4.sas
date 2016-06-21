data cd4;
     infile 'J:\2016 Spring STAT 6250\SAS code\cd4.txt';
     input id group age sex week logcd4;

****************************************************************;
*   Create new variable combining groups 1, 2, and 3   *;
****************************************************************;

trt=0;
if (group=4) then trt=1;

week_16=max(week - 16, 0);
w16=week_16 - week;
run;


title1 Mixed Effects Model for log CD4;
title2 AIDS Clinical Trial Group (ACTG) 193A Study;

proc mixed method=reml noclprint=10 covtest;
     class id;
     model logcd4 = week week_16 trt trt*week trt*week_16 / s chisq covb;
     random intercept week week_16  / subject=id type=un g gcorr;
run;

 

title1 Mixed Effects Model for log CD4 adjusting for Age and Gender;
title2 AIDS Clinical Trial Group (ACTG) 193A Study;

ods output solutionr=bluptable;

proc mixed method=reml noclprint=10 covtest;
     class id;
     model logcd4 = age sex week week_16 trt*w16 / s chisq outpred=yhat;
     random intercept week week_16  / subject=id type=un g gcorr solution;
run;
 

* Linear Mixed Effects Model (Random Intercept and Slopes): Predicted Means

******************************************;

*   Print first 60 observations only   *;

******************************************;

proc print data=yhat (obs=60);
     var id trt week logcd4 pred;
run;


*Linear Mixed Effects Model (Random Intercept and Slopes): Empirical BLUPs

 

 

******************************************;

*   Print first 60 observations only   *;

******************************************;

proc print data=bluptable (obs=60);
run;
