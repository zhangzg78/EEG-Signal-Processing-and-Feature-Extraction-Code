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
lzc_mean=zeros(1,N);
lzc_median=zeros(1,N);
lzc_midp=zeros(1,N);
lzc_kmeans=zeros(1,N);
plzc=zeros(1,N);

for p=1:N
    d=x((p-1)*(epoch-overlap)+1:(p-1)*(epoch-overlap)+epoch);  
    lzc_mean(1,p)=lemperziv_mean(d');
    lzc_median(1,p)=lemperziv_median(d');
    lzc_midp(1,p)=lemperziv_midp(d');
    lzc_kmeans(1,p)=lemperziv_kmeans(d');
    datap=PX(d,4,1);
    plzc(1,p)=ComplexityCompute(datap,24);
    
    d=xx((p-1)*(epoch-overlap)+1:(p-1)*(epoch-overlap)+epoch);  
    lzc_mean(2,p)=lemperziv_mean(d');
    lzc_median(2,p)=lemperziv_median(d');
    lzc_midp(2,p)=lemperziv_midp(d');
    lzc_kmeans(2,p)=lemperziv_kmeans(d');
    datap=PX(d,4,1);
    plzc(2,p)=ComplexityCompute(datap,24);   
end

save result lzc_mean lzc_median lzc_midp lzc_kmeans plzc


figure
subplot(5,1,1)
plot([1:N],lzc_mean(1,:));
hold on
plot([N:2*N],[lzc_mean(1,end),lzc_mean(2,:)],'r');
title('lzc_mean');
ylim([0 1]);
subplot(5,1,2)
plot([1:N],lzc_median(1,:));
hold on
plot([N:2*N],[lzc_median(1,end),lzc_median(2,:)],'r');
title('lzc_median');
ylim([0 1]);
subplot(5,1,3)
plot([1:N],lzc_midp(1,:));
hold on
plot([N:2*N],[lzc_midp(1,end),lzc_midp(2,:)],'r');
title('lzc_midp');
ylim([0 1]);
ylim([0 1]);
subplot(5,1,4)
plot([1:N],lzc_kmeans(1,:));
hold on
plot([N:2*N],[lzc_kmeans(1,end),lzc_kmeans(2,:)],'r');
title('lzc_kmeans');
ylim([0 1]);
subplot(5,1,5)
plot([1:N],plzc(1,:));
hold on
plot([N:2*N],[plzc(1,end),plzc(2,:)],'r');
title('plzc');
ylim([0 1]);

