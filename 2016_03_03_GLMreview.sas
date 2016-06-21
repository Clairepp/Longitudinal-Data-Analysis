data BPD;
infile "J:\2016 Spring STAT 625\SAS code\BPD.txt";
input BPD weight age toxemia;
weight=weight/100;
run;

proc genmod descending;
model BPD=weight/dist=bin link=logit lrci waldCI covb;
run;


data CHD;
infile J:\2016 Spring STAT 625\SAS code\CHD.txt";
input smoke BP type CHD T;
logT=log(T);
run;

proc genmod data=CHD;
model CHD=smoke BP type/dist=poisson link=log offset=logT scale=deviance covb;
run;
