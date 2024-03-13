clear all
clc
close all

load anesthesia
fs=100;
x=double(awake');
xx=double(deep');
lengt=length(x);
epoch=5*fs;
overlap=2*fs;
N=floor((lengt-epoch)/(epoch-overlap))+1;
 
for p=1:N
    d=x((p-1)*(epoch-overlap)+1:(p-1)*(epoch-overlap)+epoch);  
    AE(1,p)=appro_entropy_func(d,2,0.15*std(d));
    PE(1,p)=perm(d,3,1);
    SamE(1,p)=Sample_en(d,2,0.15*std(d));
    shanne(1,p)=shannon_entropy(d,20);
    
    d=xx((p-1)*(epoch-overlap)+1:(p-1)*(epoch-overlap)+epoch);  
    AE(2,p)=appro_entropy_func(d,2,0.15*std(d));
    PE(2,p)=perm(d,3,1);
    SamE(2,p)=Sample_en(d,2,0.15*std(d));
    shanne(2,p)=shannon_entropy(d);
       
end

save result_entropy AE PE SamE shanne

figure
subplot(4,1,1)
plot([1:N],shanne(1,:));
hold on
plot([N:2*N],[shanne(1,end),shanne(2,:)],'r');
title('shanne');
subplot(4,1,2)
plot([1:N],AE(1,:));
hold on
plot([N:2*N],[AE(1,end),AE(2,:)],'r');
title('AE');
subplot(4,1,3)
plot([1:N],SamE(1,:));
hold on
plot([N:2*N],[SamE(1,end),SamE(2,:)],'r');
title('SamE');
subplot(4,1,4)
plot([1:N],PE(1,:));
hold on
plot([N:2*N],[PE(1,end),PE(2,:)],'r');
title('PE');


