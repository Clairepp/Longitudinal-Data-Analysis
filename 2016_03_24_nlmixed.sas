data amenorrhea;
infile "J:\2016 Spring STAT 625\SAS code\amenorrhea1.txt";
input ID trt y1 y2 y3 y4;
y=y1; time=1; ctime=1; time2=1; output;
y=y2; time=2; ctime=2; time2=4; output;
y=y3; time=3; ctime=3; time2=9; output;
y=y4; time=4; ctime=4; time2=16; output;
drop y1-y4;
run;

/*proc sort;
by id;
run;
*/ 

proc genmod  descending;
    class id ctime;
    model y = time  time2 trt*time trt*time2  / d=binomial link=logit;
    repeated  subject=id / withinsubject=ctime logor=fullclust;
run;

proc nlmixed qpoints=50;
     parms b0=-2.2461 b1=0.7030 b2=-0.0323 b3=.3380 b4=-.0683  g11=0 to 8 by 1;
     lp = b0 + b1*time +b2*time2 + b3*trt*time +b4*trt*time2 + u;
     p=(exp(lp))/(1+exp(lp));
     model y ~ binary(p);
     random u~normal(0, g11)  subject=id;
     contrast 'Trt X Time Interaction' 1*b3, 1*b4;
run;

data epileptic;
infile "J:\2016 Spring STAT 625\SAS code\epileptic.txt";
input ID Trt age Y0 Y1 Y2 Y3 Y4;
y=y0; visit=0; output;
y=y1; visit=1; output;
y=y2; visit=2; output;
y=y3; visit=3; output;
y=y4; visit=4; output;
drop y0-y4;
run;

proc sort;
by id visit;

data epileptic;
     set epileptic;
     if visit=0 then do;
          time=0;
          ltime=log(8);
     end;
     else do;
          time=1;
          ltime=log(2);
     end;
run;

proc genmod;
     class id;
     model y=time trt time*trt / d=poisson offset=ltime ;
     repeated  subject=id / modelse corrw type=un;
run;

/*proc sort;
by id;
run;
*/

proc nlmixed qpoints=50;
     parms beta1=1.1213  beta2=0.1244  beta3=0.0718 beta4=-.1150
     g11=0 to 1 by 0.2 g22=0 to 1 by 0.2 g12=0.0;
     eta = ltime + beta1 + beta2*time + beta3*trt + beta4*time*trt + u1 + u2*time;
     mu=exp(eta);
     model y ~ poisson(mu);
     random u1 u2 ~ normal([0,0], [g11,g12,g22]) subject=id;
	 predict beta1+u1 out=tryagain;
run;

data epileptic1;
     set epileptic;
     if (id ne 49);
run;

proc nlmixed qpoints=50;
     parms beta1=1.1213  beta2=0.1244  beta3=0.0718 beta4=-.1150
     s2u1=0 to 1 by 0.2 s2u2=0 to 1 by 0.2 cu12=0.0;
     eta = ltime + beta1 + beta2*time + beta3*trt + beta4*time*trt + u1 + u2*time;
     mu=exp(eta);
     model y ~ poisson(mu);
     random u1 u2 ~ normal([0,0], [s2u1,cu12,s2u2]) subject=id;
run;



data infection; 
      input clinic t x n; 
      datalines; 
   1 1 11 36 
   1 0 10 37 
   2 1 16 20  
   2 0 22 32 
   3 1 14 19 
   3 0  7 19 
   4 1  2 16 
   4 0  1 17 
   5 1  6 17 
   5 0  0 12 
   6 1  1 11 
   6 0  0 10 
   7 1  1  5 
   7 0  1  9 
   8 1  4  6 
   8 0  6  7 
   run;

   proc nlmixed data=infection; 
      parms beta0=-1 beta1=1 s2u=2; 
      eta = beta0 + beta1*t + u; 
      expeta = exp(eta); 
      p = expeta/(1+expeta); 
      model x ~ binomial(n,p); 
      random u ~ normal(0,s2u) subject=clinic; 
      predict u out=Uexample; 
      estimate '1/beta1' 1/beta1; 
   run;
