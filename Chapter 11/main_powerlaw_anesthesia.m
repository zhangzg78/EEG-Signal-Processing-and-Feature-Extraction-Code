clear all
clc
close all

load anesthesia
fs=100;

x=double(awake');
xx=double(deep');
lengt=length(x);
epoch=16*fs;
overlap=0.75*epoch;
N=floor((lengt-epoch)/(epoch-overlap))+1;


for p=1:N
    d=x((p-1)*(epoch-overlap)+1:(p-1)*(epoch-overlap)+epoch);
    [A(1,p),B(1,p),r(1,p),H(1,p),Power,spectrum] = Criticality_hwt(d,fs,1,2.5,30);
    
    d=xx((p-1)*(epoch-overlap)+1:(p-1)*(epoch-overlap)+epoch);  
    [A(2,p),B(2,p),r(2,p),H(2,p),Power,spectrum] = Criticality_hwt(d,fs,1,2.5,30);
end

save result A B r H

figure
subplot(2,1,1)
plot([1:N],H(1,:));
hold on
plot([N:2*N],[H(1,end),H(2,:)],'r');
title('H');
subplot(2,1,2)
plot([1:N],r(1,:));
hold on
plot([N:2*N],[r(1,end),r(2,:)],'r');
title('r');
