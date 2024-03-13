clc
clear
close all
tic
%%
hs = (msgbox('Please Select Data file by this format:  ""Channel x Sample"" !  ',...
    'Selecting'));
ht = findobj(hs, 'Type', 'text');
set(ht, 'FontSize', 8, 'Unit', 'normal');
uiwait(hs)
[filename,pathname]= uigetfile({'*.set','All Files'},...
    'Select Data File 1');
EEG = pop_loadset([pathname,filename]);
timeIndex = linspace(0,size(EEG.data,2)/EEG.srate,size(EEG.data,2)) ;
figure
set(gcf,'outerposition',get(0,'screensize'))
plot(timeIndex,EEG.data')
xlim([0 max(timeIndex)])
axis tight
set(gca,'fontsize',18)
xlabel(['Time/Sec'])
ylabel(['Amplitude/','\muV'])
title(['Raw data'])
%%
prompt = {'Number Of Selected Independent Components:'...
    'ICA Algorithms (1.FastICA & 2.InfomaxICA):','Showing figure of each Component(1.No & 2.Yes):'};
dlg_title = 'Input Parameters';
num_lines = 1;
def = {'20','1','1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
Comp = str2num(answer{1});
Method_Flag = str2num(answer{2});
MethodString = {'FastICA','InfomaxICA'};
Method = MethodString{Method_Flag} ;
Figure_Flag = str2num(answer{3});
%%
if Method_Flag == 1
    MaxIteration = 100 ;
elseif Method_Flag == 2
    MaxIteration = 512 ;
end
%%
chanlocs = EEG.chanlocs ;
fs = EEG.srate  ;
Result_file = [pathname 'Result_' Method] ;
load([Result_file '\PCA.mat'])
load([Result_file '\S\' num2str(Comp) '.mat'])
load([Result_file '\W\' num2str(Comp) '.mat'])
ICA_file = [Result_file '\ICA_Comp'];
f_plot_ICA_parameter(latent,Comp,Result_file,MaxIteration)
mkdir(ICA_file)
B = inv(W) ;
A = coeff(:,1:Comp)*B ;
%% E = A*S ;
for isComp = 1:Comp
    E{isComp} = A(:,isComp)*S(isComp,:) ;
    PowerOfComp(isComp) = mean(std(E{isComp}')) ;
end
[sort_PowerOfComp_single_ratio sort_PowerOfComp_multiple_ratio sort_PowerOfComp Idx ]=f_contribution(PowerOfComp) ;
figure
set(gcf,'outerposition',get(0,'screensize'))
subplot(121)
set(gca,'fontsize',16)
% plot(sort_PowerOfComp,'k-o','linewidth',3)
bar(sort_PowerOfComp)
xlim([0.5 length(sort_PowerOfComp) + 0.5])
xlabel('Number of Components')
ylabel('Magnitude of each Components')
grid on
subplot(122)
set(gca,'fontsize',16)
plot(sort_PowerOfComp_multiple_ratio,'r-<','linewidth',3)
xlabel('Number of Components')
ylabel('Ratio of Component %')
grid on
fprintf('\n')
ylim([0 120])
%%
window = 3*fs ;
noverlap = 2*fs ;
nfft = 5*fs ;
timeIndex = linspace(0,size(S,2)/fs,size(S,2)) ;
fontsize = 15 ;
if Figure_Flag == 2
    for isOrder = 1:Comp
        isComp = Idx(isOrder) ;
        figure('visible','on')
        %             figure
        set(gcf,'outerposition',get(0,'screensize'))
        subplot(241)
        set(gca,'fontsize',fontsize)
        topoplot(A(:,isComp),chanlocs)
        colorbar
        title(['Topography of Comp#' num2str(isComp)])
        subplot(242)
        hist(A(:,isComp))
        set(gca,'fontsize',fontsize)
        xlabel(['Magnitude'])
        ylabel(['Number of channels'])
        title(['Distribution of Topography'])
        subplot(243)
        f_psd(double(S(isComp,:)),fs)
        set(gca,'fontsize',fontsize)
        title(['Power Spectrum Density'])
        subplot(244)
        spectrogram(double(S(isComp,:)),window,noverlap,nfft,fs)
        xlim([0 60])
        set(gca,'fontsize',fontsize)
        xlabel(['Frequency/Hz'])
        ylabel(['Time/Sec'])
        title(['Time-Frequency Graph'])
        colorbar
        subplot(2,4,[5:8])
        plot(timeIndex,S(isComp,:))
        %         axis tight
        xlim([0 max(timeIndex)])
        ylim([-3*max(S(isComp,:)) 3*max(S(isComp,:))])
        set(gca,'fontsize',fontsize)
        xlabel('Time/Sec')
        ylabel(['Magnitude'])
        title(['Waveform'])
        text(min(xlim) ,max(ylim)*1.1,['Contribution = ' num2str(sort_PowerOfComp_single_ratio(isOrder)) '%'],'fontsize',14)
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 8])
        saveas(gcf,[ICA_file filesep 'Comp# ' num2str(isComp)],'png')
    end
else
end
%%
toc