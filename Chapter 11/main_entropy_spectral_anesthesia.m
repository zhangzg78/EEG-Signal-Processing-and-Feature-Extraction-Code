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
    WE(1,p)=wavelet_entropy_func(d,fs); 
    HilEn(1,p) = HHT_EN(d,f_bin,fs);

    
    d=xx((p-1)*(epoch-overlap)+1:(p-1)*(epoch-overlap)+epoch);  
    WE(2,p)=wavelet_entropy_func(d,fs);
    HilEn(2,p) = HHT_EN(d,f_bin,fs);    
end

save result_spectral WE HilEn

figure
subplot(2,1,1)
plot([1:N],WE(1,:));
hold on
plot([N:2*N],[WE(1,end),WE(2,:)],'r');
title('WE');
subplot(2,1,2)
plot([1:N],HilEn(1,:));
hold on
plot([N:2*N],[HilEn(1,end),HilEn(2,:)],'r');
title('HilEn');

