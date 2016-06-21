data respiratory;
infile "J:\2016 Spring STAT 625\SAS code\respiratory.txt";
input center ID treatment$ genter$ age visit0 visit1 visit2 visit3 visit4;
y=visit0; time=0; output;
y=visit1; time=1; output;
y=visit2; time=2; output;
y=visit3; time=3; output;
y=visit4; time=4; output;
drop visit0 visit1 visit2 visit3 visit4;
run; 

proc genmod descending;
class id treatment time;
model y=treatment time treatment*time/dist=binomial link=logit wald type3;
repeated subject=id/withinsubject=time logor=fullclust covb corrb;
run;


data epileptic;
infile "J:\2016 Spring STAT 625\SAS code\epileptic.txt";
input ID treatment age count0 count1 count2 count3 count4;
y=count0; logT=log(8); time=0; output;
y=count1; logT=log(2); time=1; output;
y=count2; logT=log(2); time=2; output;
y=count3; logT=log(2); time=3; output;
y=count4; logT=log(2); time=4; output;
drop count0 count1 count2 count3 count4;
run;

proc genmod;
class id treatment time;
model y=treatment time treatment*time/dist=poisson link=log offset=logT type3 wald;
repeated subject=id/withinsubject=time type=un covb corrb corrw;
run;



/* repeated the example */
data leprosy;
     infile "J:\2016 Spring STAT 625\SAS code\leprosy.txt";
     input drug $ y1 y2;
id+1;
A=0;
B=0;
Antibiotic=0;

if drug='A' then A=1;
if drug='B' then B=1;
Antibiotic=A+B;
run;

data leprosy;
     set leprosy;
     y=y1; time=0; output;
     y=y2; time=1; output;
run;

proc genmod;
     class id;
     model y= time A*time B*time / d=poisson link=log type3 wald;
     contrast 'Drug x Time Interaction' A*time 1, B*time 1 / wald;
     repeated subject=id / modelse type=un corrw;
run;

proc genmod;
     class id;
     model y= time A*time B*time / d=poisson link=log type3 wald;
     contrast 'Drug x Time Interaction' A*time 1, B*time 1 / wald;
     repeated subject=id / modelse type=un corrw;
run;
