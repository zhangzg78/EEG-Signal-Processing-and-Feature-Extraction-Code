%%% This code was written for processing and analyzing ERP/EEG data 
%%% In order to run this code, please install EEGLAB toolboxes. It can be downloaded from http://sccn.ucsd.edu/eeglab/
%%% This code was written by GuangHui Zhang in November 2017, DUT-ASAP group
%%% Department of Biomedical Engineering, Dalian University of Technology
%%% Address: No.2 Linggong Road, Ganjingzi District, Dalian City, Liaoning Province, P.R.C., 116024
%%% E-mails: zhang.guanghui@foxmail.com

%%% My acknowledgements to Prof. Peng Li, Dr.Guoliang Chen for providing ERP data and Prof. Fengyu Cong giving guidance opinions.
%%% Meanwhile, express my thanks to Xiaoshuang Wang, Jianrong Li, XiaoyuWang, Jianning Du and et al for helping me to improve this code.

%%% While using this code, please cite the following articles:
%%% 1. Fengyu Cong, Yixiang Huang, Igor Kalyakin, Hong Li, Tiina Huttunen-Scott, Heikki Lyytinen, Tapani Ristaniemi, 
%%% Frequency Response based Wavelet Decomposition to Extract Children's Mismatch Negativity Elicited by Uninterrupted Sound, 
%%% Journal of Medical and Biological Engineering, 2012, 32(3): 205-214, DOI: 10.5405/jmbe.908 
%%% 2. Chen, G., et al., Event-related brain potential correlates of prospective memory in symptomatically remitted male patients with schizophrenia 
%%% Frontiers in Behavioral Neuroscience, 2015. 9: p.262.
%%% 3. Wang, J., et al., P300, not feedback error-related negativity, manifests the waiting cost of receiving reward information
%%% Neuroreport, 2014. 25(13): p. 1044-8.


clear
clc
close all
tic
%%
fileName = ['D.mat'];
load( fileName);
D = double(D);
[NumChans,NumSamps,NumSti,NumSubs] = size(D);
%%
%% FFT filter
M = 10*fs;  %% number of points for FFT
freqLow = 0.5;  %%% please change it as you want
freqHigh = 30;
%% wavelet filter
wname = ['rbio6.8'];%%% name of the wavelet
kp = [2 3 4 5 6];
if fs <= 1024 & fs > 512
    lv = 10;
elseif fs <= 512 & fs > 256
    lv = 9;
elseif 128 < fs & fs <= 256
    lv = 8;
end
timePstart = ceil((0-timeStart)/(1000/fs))+1;
%%Frequency responses of DFT filter and wavelet filter
Len=NumSamps;
Dura = NumSamps;
FFTLen=fs*10;
freqRs=fs/FFTLen;

freLow=fs/FFTLen;
freHigh = 35;

binLow=freLow/freqRs;
binHigh=freHigh/freqRs;

timeIndex=(1:(2*Len-1))*1000/fs;
fIndex=freLow:freqRs:freHigh;

sig=[zeros(Len-1,1);1; zeros(Len-1,1)];
tIndex = linspace(-Dura,Dura,length(sig));
%% 
%%%%%%%%%%%%%%%%%%%%%%%  Digital filter
ODFfreqLow= 0.5;
ODFfreqHigh=30;
DFsig=f_filterFFT(sig,FFTLen,fs,ODFfreqLow,ODFfreqHigh);
DFsigFFT=fft(DFsig,FFTLen);
spec=abs(DFsigFFT(binLow:binHigh,:));
DFfreqResp =20*log10(spec/max(spec));
DFphase = 2*pi* phase(DFsigFFT(binLow:binHigh));%% phase
%%
%%%%%%%%%%%%%%%%%%%%%%% Wavelet filter
WLDsig=f_filterWavelet(sig,lv,wname,kp);
WLDsigFFT=fft(WLDsig,FFTLen);
spec=abs(WLDsigFFT(binLow:binHigh,:));
WaveletfreqResp=20*log10(spec/max(spec));
Waveletphase = 2*pi*phase(WLDsigFFT(binLow:binHigh));

figure(100);
set(gcf,'outerposition',get(0,'screensize'));
subplot(2,1,1);
set(gca,'fontsize',20);
plot(fIndex,DFfreqResp,'k--','linewidth',3);
hold on;
plot(fIndex,WaveletfreqResp,'k','linewidth',3);
xlim([freLow,freHigh]);
ylim([-100 20]);
tN = ['Magnitude of frequency responses for different filters'];
title(tN,'fontsize',16);
xlabel('Frequency/Hz','fontsize',16);
ylabel('Attenuation/dB','fontsize',16);
legend('DFT Filter',' Wavelet filter','location','Southwest')

subplot(2,1,2);
set(gca,'fontsize',20);
plot(fIndex,DFphase,'k--','linewidth',3);
hold on;
plot(fIndex,Waveletphase,'k','linewidth',3);
xlim([freLow,freHigh]);
tN = ['Phase of frequency responses for different filters'];
title(tN,'fontsize',16);
xlabel('Frequency/Hz','fontsize',16);
ylabel('Angle/degree','fontsize',16);
%%
Hw_news =['Filtering ERP data..'];
Hw = waitbar(0,Hw_news);
for sub = 1:NumSubs
    waitbar(sub/NumSubs,Hw);
    for chan = 1:NumChans
        for sti = 1:NumSti
            temp = squeeze(D(chan,:,sti,sub))' ;
            
            temp1 = f_filterWavelet(temp,lv,wname,kp);
            temp1 = temp1 - mean(temp1(1:timePstart));
            
            temp3=  f_filterFFT(temp,M,fs,freqLow,freqHigh);
            temp3 = temp3 - mean(temp3(1:timePstart));
            d1 (chan,:,sti,sub) = temp1;
            d3 (chan,:,sti,sub) = temp3;
        end
    end
end
close(Hw);
%%
D = d3;
fileName = ['D_FFT filter.mat'];
save(fileName,'D','chanlocs','Group_Idx','timeStart','timeEnd','fs');
D = d1;
fileName = ['D_Wavelet filter.mat'];
save(fileName,'D','chanlocs','Group_Idx','timeStart','timeEnd','fs');
uiwait(msgbox('The program end'));
%% program ends
toc