clear all
clc
close all

load anesthesia
fs=100;
f_bin=[1 30];
x=double(awake');
xx=double(deep');
lengt=length(x);
epoch=5*fs;
overlap=2*fs;
N=floor((lengt-epoch)/(epoch-overlap))+1;
 
for p=1:N
    d=x((p-1)*(epoch-overlap)+1:(p-1)*(epoch-overlap)+epoch);  
    [RP,DD] = RPplot(d,3,1,0.5,0);
    [RR(1,p),DET(1,p),ENTR(1,p),L(1,p)] = Recu_RQA(RP,1);
    
    d=xx((p-1)*(epoch-overlap)+1:(p-1)*(epoch-overlap)+epoch);  
    [RP,DD] = RPplot(d,3,1,0.5,0);
    [RR(2,p),DET(2,p),ENTR(2,p),L(2,p)] = Recu_RQA(RP,1);    
end

save result_recurrence RR DET ENTR L



figure
subplot(3,1,1)
plot([1:N],RR(1,:));
hold on

plot([N:2*N],[RR(1,end),RR(2,:)],'r');
title('RR');
subplot(3,1,2)
plot([1:N],DET(1,:));
hold on
plot([N:2*N],[DET(1,end),DET(2,:)],'r');
title('DET');
subplot(3,1,3)
plot([1:N],ENTR(1,:));
hold on
plot([N:2*N],[ENTR(1,end),ENTR(2,:)],'r');
title('ENTR');
