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
%%  setting parameters
prompt = {'The name of the first factor =:','The name of the second factor =:',...
    'The name of the third factor =:','The level of the first factor =:',...
    'The level of the second factor =:','The level of the third factor =:',...
    'Filter (1.Wavelet filter & 2.FFT filter & 3.None)','PCA (1.Yes & 2. No)',...
    'Measure method (1.Mean value & 2.Peak value):','ERPStart =:','ERPEnd =:'};
dlg_title = 'Input Parameters';
num_lines = 1;
def = {'Factor1','Factor2','Factor3','1','1','0','3','2','1','0','0'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
levelName_first = cellstr(answer{1});
levelName_second = cellstr(answer{2});
levelName_third = cellstr(answer{3});
levelNum_first = str2num(answer{4});
levelNum_second = str2num(answer{5});
levelNum_third = str2num(answer{6});
PCA_Flag = str2num(answer{8});
filterFlag = str2num(answer{7});
measureFlag = str2num(answer{9});

filterString = {'Wavelet filter','FFT filter','Conventional'};
measureString = {'MeanValue','PeakValue'};

filterName = filterString{filterFlag};
measureName = measureString{measureFlag};
ERPStart = str2num(answer{10});
ERPEnd = str2num(answer{11});
%%
if levelNum_third > 0
    TF_R = strcmp('Region',levelName_third);
    if TF_R == 1
        RegionNum = levelNum_third;
    end
elseif levelNum_second > 0 & levelNum_third == 0
    TF_R = strcmp('Region',levelName_second);
    if TF_R == 1
        RegionNum = levelNum_second;
    end
else
    TF_R = 0;
end
%%  load  ERP or  EEGdata
if   PCA_Flag == 2
    if filterFlag == 3
        load ('D');
    else
        dataFileName = ['D_',filterName];
        load(dataFileName);
    end
    route = strcat(num2str(filterFlag),'_',filterName,'\');
    mkdir(route);
else
    prompt = {'The number of reserved components =:','The number of interest component(s) =:'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'20','1'};
    answer = inputdlg(prompt,dlg_title,num_lines,def) ;
    R = str2num(answer{1});
    K = str2num(answer{2});
    if filterFlag == 3
        PCA_Data_fileName = ['D_PCA_rotation_R_',num2str(R),'_K_',num2str(K)];
    else
        PCA_Data_fileName = ['D_',filterName,'_PCA_rotation_R_',num2str(R),'_K_',num2str(K)];
    end
    load(PCA_Data_fileName);
    route = strcat(num2str(filterFlag),'_',filterName,'\PCA\Reserved compoents',num2str(R),'\interest component(s)','_',num2str(K),'\');
    mkdir(route);
end
NumGroups = max(Group_Idx);

if NumGroups == 2
    prompt = {'The name of the first group:','The name of the second group'};
    dlg_title = 'Input Parameters';
    num_lines = 1;
    def = {'group 1','group 2'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    for iss = 1:length(def)
        GroupNames{iss} = char(cellstr(answer{iss}));
    end
elseif NumGroups == 3
    prompt = {'The name of the first group:','The name of the second group',...
        'The name of the third group:'};
    dlg_title = 'Input Parameters';
    num_lines = 1;
    def = {'group 1','group 2','group 3'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    for iss = 1:length(def)
        GroupNames{iss} = char(cellstr(answer{iss}));
    end
end
%%
if NumGroups == 1
    if levelNum_first > 0 & levelNum_second== 0 & levelNum_third == 0
        for Numoffirst = 1:levelNum_first
            Sti_names{Numoffirst} = char(strcat(levelName_first,num2str(Numoffirst)));
        end
    elseif  levelNum_first > 0 & levelNum_second > 0 & levelNum_third == 0
        if  TF_R == 1
            for Numoffirst = 1:levelNum_first
                Sti_names{Numoffirst} = char(strcat(levelName_first,num2str(Numoffirst)));
            end
        else
            count = 0;
            for Numoffirst = 1:levelNum_first
                for Numofsecond = 1:levelNum_second
                    count = count +1;
                    Sti_names{count} = char(strcat(levelName_first,num2str(Numoffirst),'-',levelName_second,num2str(Numofsecond)));
                end
            end
        end
        %%%
    elseif  levelNum_third > 0
        if  TF_R == 1
            count = 0;
            for Numoffirst = 1:levelNum_first
                for Numofsecond = 1:levelNum_second
                    count = count +1;
                    Sti_names{count} = char(strcat(levelName_first,num2str(Numoffirst),'-',levelName_second,num2str(Numofsecond)));
                end
            end
        else
            count = 0;
            for Numoffirst = 1:levelNum_first
                for Numofsecond = 1:levelNum_second
                    for Numofthird = 1:levelNum_third
                        count = count +1;
                        Sti_names{count} = char(strcat(levelName_first,num2str(Numoffirst),'-',levelName_second,num2str(Numofsecond),'-',levelName_third,num2str(Numofthird)));
                    end
                end
            end
        end
    end
    %%%
else NumGroups > 1
    %%%
    if  levelNum_first > 0 & levelNum_second > 0 & levelNum_third == 0
        if  TF_R == 0
            for Numofsecond = 1:levelNum_second
                Sti_names{Numofsecond} = char(strcat(levelName_second,num2str(Numofsecond)));
            end
        end
        %%%
    elseif  levelNum_third > 0
        if  TF_R == 1
            for Numofsecond = 1:levelNum_second
                Sti_names{Numofsecond} = char(strcat(levelName_second,num2str(Numofsecond)));
            end
        else
            count = 0;
            for Numofsecond = 1:levelNum_second
                for Numofthird = 1:levelNum_third
                    count = count +1;
                    Sti_names{count} = char(strcat(levelName_second,num2str(Numofsecond),'-',levelName_third,num2str(Numofthird)));
                end
            end
        end
    end
    %%%
end
%%
D = double(D);
ERPSampointStart = ceil((ERPStart - timeStart)/(1000/fs)) + 1 ;
ERPSampointEnd = ceil((ERPEnd - timeStart)/(1000/fs)) + 1 ;
[NumChans,NumSamps,NumSti,NumSubs] = size(D);
tIndex = linspace(timeStart,timeEnd,NumSamps);
%%
for is = 1:1000
    ChansOfInterestNumbers =[];
    ChansOfInterestNames =[];
    prompt = {'The first name of interest electrodes=:','The second name of interest electrodes=:',...
        'The third name of interest electrodes=:', 'The fourth name of interest electrodes=:',...
        'The fifth name of interest electrodes=:','The sixth name of interest electrodes=:',...
        'The seventh name of interest electrodes=:' , 'The eighth name of interest electrodes=:',...
        'The ninth name of interest electrodes=:'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'0','0','0','0','0','0','0','0','0'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    count1 = 0;
    count2 = 0;
    for Numofinputchannel = 1:length(def)
        code = strcmp('0',cellstr(answer{Numofinputchannel}));
        if code== 1
            count1  = count1+1;
        else
            count2  = count2+1;
            ChansOfInterestNames{count2} = answer{Numofinputchannel};
        end
    end
    %% find the number(s) and name(s) of interested electrodes
    if count1 < 9
        count = 0;
        for chanSelected = 1:length(ChansOfInterestNames)
            for chan = 1:NumChans
                code = strcmp(chanlocs(chan).labels,ChansOfInterestNames{chanSelected});
                if code == 1
                    count =  count +1;
                    ChansOfInterestNumbers(count) = chan;
                end
            end
        end
        if length(ChansOfInterestNames) > length(ChansOfInterestNumbers)
            ChansOfInterestNumbers(length(ChansOfInterestNumbers)+1:length(ChansOfInterestNames))=0;
        end
        min_Num = min(ChansOfInterestNumbers(:));
    elseif count1 == 9
        min_Num = 0;
    end
    
    if min_Num == 0
        uiwait(msgbox('Input incorrect electrode(s) name'));
    else
        break;
    end
end
if  length(ChansOfInterestNames) > 1
    filechanName = char(ChansOfInterestNames{1});
    for Numofchannel = 1:length(ChansOfInterestNames) - 1
        filechanName = char(strcat(filechanName,'-',ChansOfInterestNames{Numofchannel+1}));
    end
else
    filechanName = char(ChansOfInterestNames);
end
%%
%% MEASUREMENT METHOD:mean value/peak value
if measureFlag == 1
    TOPO = squeeze(mean(D(:,ERPSampointStart:ERPSampointEnd,:,:),2));
else
    for subNum = 1:NumSubs
        for stimulusNumFactorOne = 1:NumSti
            for chanNum = 1:NumChans
                temp = squeeze(D(chanNum,ERPSampointStart:ERPSampointEnd,stimulusNumFactorOne,subNum))';
                [mV  Idx] = max(abs(temp(:)));
                TOPO(chanNum,stimulusNumFactorOne,subNum)  = squeeze(D(chanNum,ERPSampointStart+Idx,stimulusNumFactorOne,subNum));
            end
        end
    end
end
%% calculating the topography of the data
for groupNum = 1:NumGroups
    idx1 = find(Group_Idx == groupNum);
    D_av(:,:,:,groupNum) = squeeze(mean(D(:,:,:,idx1),4));
    topo_GA(:,:,groupNum) = squeeze(mean(TOPO(:,:,idx1),3));
    for sti = 1:NumSti
        temp = corrcoef(squeeze(TOPO(:,sti,idx1)));
        topo_similarity{:,:,sti,groupNum} = temp;
    end
end
%% the Grand waveform(s) at interest electrode(s)
Hw_news =['Plot the grand average waveform at interest eletrodes..'];
Hw = waitbar(0,Hw_news);
if PCA_Flag  == 1
    method_name = char(strcat('PCA-',filterName));
else
    method_name = filterName;
end
mv_min = min(topo_GA(:));
mv_max = max(topo_GA(:));
temp = squeeze(D_av(ChansOfInterestNumbers,:,:,:));
y_MIN = 1.2*min(temp(:));
y_MAX = 1.2*max(temp(:));
y_max = 1.5*max(abs(temp(:)));
%%
if NumGroups== 1
    rowNum =1;
    columnNum =1;
elseif NumGroups== 2
    rowNum = 2;
    columnNum =1;
elseif NumGroups== 3
    rowNum = 3;
    columnNum =1;
end
countPlotfigu = 0;
for Numofintchannel = 1:length(ChansOfInterestNumbers)
    waitbar(Numofintchannel/length(ChansOfInterestNumbers),Hw);
    countPlotfigu = countPlotfigu +1;
    figure(countPlotfigu)
    set(gcf,'outerposition',get(0,'screensize'))
    for groupNum = 1:NumGroups
        subplot(rowNum,columnNum,groupNum);
        set(gca,'fontsize',16,'FontWeight','bold');
        for sti = 1:NumSti
            switch sti
                case 1
                    plot(tIndex, D_av(ChansOfInterestNumbers(Numofintchannel),:,sti,groupNum),'k','linewidth',2)
                    hold on;
                case 2
                    plot(tIndex, D_av(ChansOfInterestNumbers(Numofintchannel),:,sti,groupNum),'k--','linewidth',2)
                    hold on;
                case 3
                    plot(tIndex, D_av(ChansOfInterestNumbers(Numofintchannel),:,sti,groupNum),'r','linewidth',4)
                    hold on;
                case 4
                    plot(tIndex, D_av(ChansOfInterestNumbers(Numofintchannel),:,sti,groupNum),'r--','linewidth',4)
                    hold on;
                case 5
                    plot(tIndex, D_av(ChansOfInterestNumbers(Numofintchannel),:,sti,groupNum),'b-.','linewidth',2)
                    hold on;
                case 6
                    plot(tIndex, D_av(ChansOfInterestNumbers(Numofintchannel),:,sti,groupNum),'b:','linewidth',2)
                    hold on;
                case 7
                    plot(tIndex, D_av(ChansOfInterestNumbers(Numofintchannel),:,sti,groupNum),'b-.','linewidth',4)
                    hold on;
                case 8
                    plot(tIndex, D_av(ChansOfInterestNumbers(Numofintchannel),:,sti,groupNum),'b:','linewidth',4)
                    hold on;
                case 9
                    plot(tIndex, D_av(ChansOfInterestNumbers(Numofintchannel),:,sti,groupNum),'r-.','linewidth',4)
                    hold on;
            end
            set(gca,'ydir','reverse','FontWeight','bold');
            xlim([timeStart,timeEnd]);
            ylim([-y_max,y_max]);
            grid on;
            hold on;
        end
        if NumGroups == 1
            if groupNum == 1
                xlabel(['Time/ms'],'fontsize',14);
                ylabel(['Amplitude/\muV'],'fontsize',14);
                legend(Sti_names,'location','best')
                tN = strcat(method_name,'-Grand Average Waveform-',ChansOfInterestNames{Numofintchannel});
            end
        else
            if groupNum == 1
                xlabel(['Time/ms'],'fontsize',16);
                ylabel(['Amplitude/\muV'],'fontsize',16);
                legend(Sti_names,'location','best')
                tN = strcat(method_name,'-Grand Average Waveform-',GroupNames{groupNum},'-',ChansOfInterestNames{Numofintchannel});
            else
                tN = strcat(GroupNames{groupNum});
            end
        end
        title(tN,'fontsize',16);
    end
    figureName = char(strcat(num2str(Numofintchannel),'_GA_waveform_',filechanName));
    set(figure(countPlotfigu),'paperunits','inches','paperposition',[0,0,16,9]);
    saveas(figure(countPlotfigu),[route figureName],'png');
    saveas(figure(countPlotfigu),[route figureName],'fig');
    
end
close(Hw);
%%  the topography
Hw_news =['Plot grand average topography..'];
Hw = waitbar(0,Hw_news);
rowNum = 2;
columnNum = ceil(NumGroups*NumSti/rowNum);
countPlotfigu = countPlotfigu +1;
figure(countPlotfigu);
set(gcf,'outerposition',get(0,'screensize'))
count = 0;
if columnNum > 3
    suptitle([method_name,'-','Grand average topography']);
    hold on;
end
for groupNum = 1:NumGroups
    waitbar(groupNum/NumGroups,Hw);
    for sti = 1:NumSti
        count = count +1;
        subplot(rowNum,columnNum,count,'align');
        set(gca,'fontsize',16,'FontWeight','bold')
        topoplot(squeeze(topo_GA(:,sti,groupNum)),chanlocs,'maplimits',[mv_min mv_max]);
        hold on;
        if sti == 1
            if NumGroups == 1
                if columnNum > 3
                    tN = strcat(Sti_names{sti});
                else
                    tN = strcat(method_name,'-','Grand average topography-',Sti_names{sti});
                end
            else
                if  columnNum > 3
                    tN = strcat(GroupNames{groupNum},'-',Sti_names{sti});
                else
                    if groupNum == 1
                        tN = strcat(method_name,'-','Grand average topography-',GroupNames{groupNum},'-',Sti_names{sti});
                    else
                        tN = strcat(GroupNames{groupNum},'-',Sti_names{sti});
                    end
                    
                end
                
            end
        else
            tN = [Sti_names{sti}];
        end
        title(tN,'fontsize',14);
        hold on;
        if count == NumSti*NumGroups
            last_subplot = subplot(rowNum,columnNum,count,'align');
            last_subplot_position = get(last_subplot,'position');
            colorbar_h = colorbar('peer',gca,'eastoutside','fontsize',10);
            set(last_subplot,'pos',last_subplot_position);
        end
    end
end
close(Hw)
figureName = char(strcat('GA_topo_',num2str(ERPStart),'_',num2str(ERPEnd)));
set(figure(countPlotfigu),'paperunits','inches','paperposition',[0,0,16,9]);
saveas(figure(countPlotfigu),[route figureName],'png');
saveas(figure(countPlotfigu),[route figureName],'fig');
%%  the correlation coefficient of topography between subjects
Hw_news =['Plot Correlation Coefficient between topographies...'];
Hw = waitbar(0,Hw_news);
countPlotfigu = countPlotfigu +1;
figure(countPlotfigu)
set(gcf,'outerposition',get(0,'screensize'))
count  = 0;
for groupNum = 1:NumGroups
    waitbar(groupNum/NumGroups,Hw)
    for sti = 1:NumSti
        count = count +1;
        subplot(rowNum,columnNum,count,'align')
        set(gca,'fontsize',16,'FontWeight','bold')
        imagesc(squeeze(topo_similarity{:,:,sti,groupNum}))
        set(gca,'clim',[-1 1]);
        if count == 1
            xlabel('Subject #')
            ylabel('Subject #')
        elseif count == NumSti*NumGroups
            last_subplot = subplot(rowNum,columnNum,count,'align');
            last_subplot_position = get(last_subplot,'position');
            colorbar_h = colorbar('peer',gca,'eastoutside','fontsize',14);
            set(last_subplot,'pos',last_subplot_position);
        end
        if sti == 1
            if NumGroups == 1
                tN = strcat(Sti_names{sti});
            else
                tN = strcat(GroupNames{groupNum},'-',Sti_names{sti});
            end
        else
            tN = [Sti_names{sti}];
        end
        title(tN,'fontsize',16);
        hold on;
        colormap('jet');
    end
end
suptitle([method_name,'-','Correlation Coefficient between topographies']);
close(Hw)
figureName = char(strcat('GA_corr_',num2str(ERPStart),'_',num2str(ERPEnd)));
set(figure(countPlotfigu),'paperunits','inches','paperposition',[0,0,16,9]);
saveas(figure(countPlotfigu),[route figureName],'png');
saveas(figure(countPlotfigu),[route figureName],'fig');
%%
%% time frequency analysis
prompt = {'low frequency:','high frequency:'};
dlg_title = 'Input';
dlg_lines = 1;
def = {'1','1'} ;
answer = inputdlg(prompt,dlg_title,dlg_lines,def) ;
fb = 1;
Fc = 1;
fl = str2num(answer{1});
fh = str2num(answer{2});
fIndex = fl:fb:fh;
scale = fs*Fc./fIndex;
wname = ['cmor',num2str(fb),'-',num2str(Fc)];
baselinePstart = 1;
baselinePend = (0-timeStart)/(1/(fs/1000)) +1;

for Numofchannel = 1:length(ChansOfInterestNumbers)
    for Numofsti  = 1:NumSti
        for Numofsub = 1:NumSubs
            COEFS = cwt(squeeze(D(ChansOfInterestNumbers(Numofchannel),:,Numofsti,Numofsub)),scale,wname);
            TFR = abs(COEFS).^2;
            tfr = TFR-repmat(mean(TFR(:,baselinePstart:baselinePend),2),1,size(TFR,2));
            D_TF(:,:,Numofchannel,Numofsti,Numofsub) = tfr;
        end
    end
end

if NumGroups == 1
    rowNum =2;
    columnNum = ceil(NumGroups*NumSti/rowNum);
else
    rowNum = NumGroups;
    columnNum = NumSti;
end
for groupNum = 1:NumGroups
    idx1 = find(Group_Idx == groupNum);
    D_TF_AV(:,:,:,:,groupNum) = mean(D_TF(:,:,:,:,idx1),5);
end

for Numofintchannel = 1:length(ChansOfInterestNumbers);
    countPlotfigu = countPlotfigu + 1;
    figure(countPlotfigu)
    set(gcf,'outerposition',get(0,'screensize'))
    temp = squeeze(D_TF_AV(:,:,Numofintchannel,:,:));
    Min_v = min(temp(:));
    Max_v = max(temp(:));
    countplot = 0;
    for groupNum = 1:NumGroups
        for sti = 1:NumSti
            countplot = countplot +1 ;
            subplot(rowNum,columnNum,countplot,'align');
            set(gca,'fontsize',16,'FontWeight','bold');
            pcolor(tIndex,fIndex,squeeze(D_TF_AV(:,:,Numofintchannel,sti,groupNum)));
            shading('interp');
            caxis([Min_v,Max_v]);
            if countplot  == 1
                xlabel('Times/ms','fontsize',14);
                ylabel('Frequcency/Hz','fontsize',14);
            end
            if sti == 1
                if NumGroups == 1
                    tN = strcat(method_name,'-TFR at #',ChansOfInterestNames(Numofintchannel),'-',Sti_names{sti});
                else
                    if groupNum == 1
                        tN = strcat(method_name,'-','TFR at #',ChansOfInterestNames(Numofintchannel),'-',GroupNames{groupNum},'-',Sti_names{sti});
                    else
                        tN = strcat(GroupNames{groupNum},'-',Sti_names{sti});
                    end
                end
            else
                tN = [Sti_names{sti}];
            end
            
            title(tN,'fontsize',16);
        end
    end
    if countplot == NumSti*NumGroups
        last_subplot = subplot(rowNum,columnNum,countplot,'align');
        last_subplot_position = get(last_subplot,'position');
        colorbar_h = colorbar('peer',gca,'eastoutside','fontsize',10);
        set(last_subplot,'pos',last_subplot_position);
    end
    figureName = strcat(num2str(Numofintchannel),'_GA_tfr_',filechanName);
    set(figure(countPlotfigu),'paperunits','inches','paperposition',[0,0,16,9]);
    saveas(figure(countPlotfigu),[route figureName],'png');
    saveas(figure(countPlotfigu),[route figureName],'fig');
end
%%  N-Way anova
%% differnt region
if TF_R == 1
    %% input the interest channel name of interest region
    for Numofregion = 1: RegionNum
        switch Numofregion
            %% first region
            case 1
                for is = 1:1000
                    ChansOfInterestNumbers_FR =[];
                    ChansOfInterestNames_FR =[];
                    prompt = {'The first channel name of the first Region=:','The second channel name of the first Region=:',...
                        'The third channel name of the first Region=:', 'The fourth channel name of the first Region=:',...
                        'The fifth channel name of the first Region=:','The sixth channel name of the first Region=:',...
                        'The seventh channel name of the first Region=:' , 'The eighth channel name of the first Region=:',...
                        'The ninth channel name of the first Region=:'};
                    dlg_title = 'Input';
                    num_lines = 1;
                    def_first = {'0','0','0','0','0','0','0','0','0'};
                    answer = inputdlg(prompt,dlg_title,num_lines,def_first);
                    count1 = 0;
                    count2 = 0;
                    for Numofinputchannel = 1:length(def_first)
                        code = strcmp('0',cellstr(answer{Numofinputchannel}));
                        if code== 1
                            count1  = count1+1;
                        else
                            count2  = count2+1;
                            ChansOfInterestNames_FR{count2} = answer{Numofinputchannel};
                        end
                    end
                    %% find the number(s) and name(s) of interested electrodes
                    if count1 < 9
                        count = 0;
                        for chanSelected = 1:length(ChansOfInterestNames_FR)
                            for chan = 1:NumChans
                                code = strcmp(chanlocs(chan).labels,ChansOfInterestNames_FR{chanSelected});
                                if code == 1
                                    count =  count +1;
                                    ChansOfInterestNumbers_FR(count) = chan;
                                end
                            end
                        end
                        if length(ChansOfInterestNames_FR) > length(ChansOfInterestNumbers_FR)
                            ChansOfInterestNumbers_FR(length(ChansOfInterestNumbers_FR)+1:length(ChansOfInterestNames_FR)) = 0;
                        end
                        min_Num = min(ChansOfInterestNumbers_FR(:));
                    elseif count1 == 9
                        min_Num = 0;
                    end
                    
                    if min_Num == 0
                        uiwait(msgbox('Input incorrect electrode(s) name'));
                    else
                        break;
                    end
                end
                topo_box_FR = squeeze(mean(TOPO(ChansOfInterestNumbers_FR,:,:),1));
                %% second region
            case 2
                for is = 1:1000
                    ChansOfInterestNumbers_SR =[];
                    ChansOfInterestNames_SR =[];
                    prompt = {'The first channel name of the second Region=:','The second channel name of the second Region=:',...
                        'The third channel name of the second Region=:', 'The fourth channel name of the second Region=:',...
                        'The fifth channel name of the second Region=:','The sixth channel name of the second Region=:',...
                        'The seventh channel name of the second Region=:' , 'The eighth channel name of the second Region=:',...
                        'The ninth channel name of the second Region=:'};
                    dlg_title = 'Input';
                    num_lines = 1;
                    def_second = {'0','0','0','0','0','0','0','0','0'};
                    answer = inputdlg(prompt,dlg_title,num_lines,def_second);
                    count1 = 0;
                    count2 = 0;
                    for Numofinputchannel = 1:length(def_second)
                        code = strcmp('0',cellstr(answer{Numofinputchannel}));
                        if code== 1
                            count1  = count1+1;
                        else
                            count2  = count2+1;
                            ChansOfInterestNames_SR{count2} = answer{Numofinputchannel};
                        end
                    end
                    %% find the number(s) and name(s) of interested electrodes
                    if count1 < 9
                        count = 0;
                        for chanSelected = 1:length(ChansOfInterestNames_SR)
                            for chan = 1:NumChans
                                code = strcmp(chanlocs(chan).labels,ChansOfInterestNames_SR{chanSelected});
                                if code == 1
                                    count =  count +1;
                                    ChansOfInterestNumbers_SR(count) = chan;
                                end
                            end
                        end
                        if length(ChansOfInterestNames_SR) > length(ChansOfInterestNumbers_SR)
                            ChansOfInterestNumbers_SR(length(ChansOfInterestNumbers_SR)+1:length(ChansOfInterestNames_SR)) = 0;
                        end
                        min_Num = min(ChansOfInterestNumbers_SR(:));
                    elseif count1 == 9
                        min_Num = 0;
                    end
                    
                    if min_Num == 0
                        uiwait(msgbox('Input incorrect electrode(s) name'));
                    else
                        break;
                    end
                end
                topo_box_SR = squeeze(mean(TOPO(ChansOfInterestNumbers_SR,:,:),1));
                %% third region
            case 3
                for is = 1:1000
                    ChansOfInterestNumbers_TR =[];
                    ChansOfInterestNames_TR =[];
                    prompt = {'The first channel name of the third Region=:','The second channel name of the third Region=:',...
                        'The third channel name of the third Region=:', 'The fourth channel name of the third Region=:',...
                        'The fifth channel name of the third Region=:','The sixth channel name of the third Region=:',...
                        'The seventh channel name of the third Region=:' , 'The eighth channel name of the third Region=:',...
                        'The ninth channel name of the third Region=:'};
                    dlg_title = 'Input';
                    num_lines = 1;
                    def_third = {'0','0','0','0','0','0','0','0','0'};
                    answer = inputdlg(prompt,dlg_title,num_lines,def_third);
                    count1 = 0;
                    count2 = 0;
                    for Numofinputchannel = 1:length(def_third)
                        code = strcmp('0',cellstr(answer{Numofinputchannel}));
                        if code== 1
                            count1  = count1+1;
                        else
                            count2  = count2+1;
                            ChansOfInterestNames_TR{count2} = answer{Numofinputchannel};
                        end
                    end
                    %% find the number(s) and name(s) of interested electrodes
                    if count1 < 9
                        count = 0;
                        for chanSelected = 1:length(ChansOfInterestNames_TR)
                            for chan = 1:NumChans
                                code = strcmp(chanlocs(chan).labels,ChansOfInterestNames_TR{chanSelected});
                                if code == 1
                                    count =  count +1;
                                    ChansOfInterestNumbers_TR(count) = chan;
                                end
                            end
                        end
                        if length(ChansOfInterestNames_TR) > length(ChansOfInterestNumbers_TR)
                            ChansOfInterestNumbers_TR(length(ChansOfInterestNumbers_TR)+1:length(ChansOfInterestNames_TR)) = 0;
                        end
                        min_Num = min(ChansOfInterestNumbers_TR(:));
                    elseif count1 == 9
                        min_Num = 0;
                    end
                    
                    if min_Num == 0
                        uiwait(msgbox('Input incorrect electrode(s) name'));
                    else
                        break;
                    end
                end
                topo_box_TR = squeeze(mean(TOPO(ChansOfInterestNumbers_TR,:,:),1));
                %% fourth region
            case 4
                for is = 1:1000
                    ChansOfInterestNumbers_FOR =[];
                    ChansOfInterestNames_FOR =[];
                    prompt = {'The first channel name of the fourth Region=:','The second channel name of the fourth Region=:',...
                        'The third channel name of the fourth Region=:', 'The fourth channel name of the fourth Region=:',...
                        'The fifth channel name of the fourth Region=:','The sixth channel name of the fourth Region=:',...
                        'The seventh channel name of the fourth Region=:' , 'The eighth channel name of the fourth Region=:',...
                        'The ninth channel name of the fourth Region=:'};
                    dlg_title = 'Input';
                    num_lines = 1;
                    def_fourth = {'0','0','0','0','0','0','0','0','0'};
                    answer = inputdlg(prompt,dlg_title,num_lines,def_fourth);
                    count1 = 0;
                    count2 = 0;
                    for Numofinputchannel = 1:length(def_fourth)
                        code = strcmp('0',cellstr(answer{Numofinputchannel}));
                        if code== 1
                            count1  = count1+1;
                        else
                            count2  = count2+1;
                            ChansOfInterestNames_FOR{count2} = answer{Numofinputchannel};
                        end
                    end
                    %% find the number(s) and name(s) of interested electrodes
                    if count1 < 9
                        count = 0;
                        for chanSelected = 1:length(ChansOfInterestNames_FOR)
                            for chan = 1:NumChans
                                code = strcmp(chanlocs(chan).labels,ChansOfInterestNames_FOR{chanSelected});
                                if code == 1
                                    count =  count +1;
                                    ChansOfInterestNumbers_FOR(count) = chan;
                                end
                            end
                        end
                        if length(ChansOfInterestNames_FOR) > length(ChansOfInterestNumbers_FOR)
                            ChansOfInterestNumbers_FOR(length(ChansOfInterestNumbers_FOR)+1:length(ChansOfInterestNames_FOR)) = 0;
                        end
                        min_Num = min(ChansOfInterestNumbers_FOR(:));
                    elseif count1 == 9
                        min_Num = 0;
                    end
                    
                    if min_Num == 0
                        uiwait(msgbox('Input incorrect electrode(s) name'));
                    else
                        break;
                    end
                end
                topo_box_FOR = squeeze(mean(TOPO(ChansOfInterestNumbers_FOR,:,:),1));
        end
    end
    
    switch  RegionNum
        case 2
            for stiNum = 1:NumSti
                TOPO_box1(RegionNum*stiNum-1,:)  = topo_box_FR(stiNum,:);
                TOPO_box1(RegionNum*stiNum,:)  = topo_box_SR(stiNum,:);
            end
            X = reshape(TOPO_box1',1,[]);
            prompt = {'The first region name =:','The second region name =:'};
            dlg_title = 'Regions Name';
            num_lines = 1;
            def = {'Region1','Region2'};
            answer = inputdlg(prompt,dlg_title,num_lines,def) ;
            for intchanNum = 1:RegionNum
                regionName{intchanNum}   = cellstr( answer{intchanNum});
            end
            topo_box(1,:,:) = topo_box_FR;
            topo_box(2,:,:) = topo_box_SR;
        case  3
            for stiNum = 1:NumSti
                TOPO_box1(RegionNum*stiNum-2,:)  = topo_box_FR(stiNum,:);
                TOPO_box1(RegionNum*stiNum-1,:)  = topo_box_SR(stiNum,:);
                TOPO_box1(RegionNum*stiNum,:)  = topo_box_TR(stiNum,:);
            end
            X = reshape(TOPO_box1',1,[]);
            prompt = {'The first region name =:','The second region name =:',...
                'The third region name =:'};
            dlg_title = 'Regions Name';
            num_lines = 1;
            def = {'Region1','Region2','Region3'};
            answer = inputdlg(prompt,dlg_title,num_lines,def) ;
            for intchanNum = 1:RegionNum
                regionName{intchanNum}   = cellstr( answer{intchanNum});
            end
            topo_box(1,:,:) = topo_box_FR;
            topo_box(2,:,:) = topo_box_SR;
            topo_box(3,:,:) = topo_box_TR;
        case 4
            for stiNum = 1:NumSti
                TOPO_box1(RegionNum*stiNum-3,:)  = topo_box_FR(stiNum,:);
                TOPO_box1(RegionNum*stiNum-2,:)  = topo_box_SR(stiNum,:);
                TOPO_box1(RegionNum*stiNum-1,:)  = topo_box_TR(stiNum,:);
                TOPO_box1(RegionNum*stiNum,:)  = topo_box_FOR(stiNum,:);
            end
            X = reshape(TOPO_box1',1,[]);
            prompt = {'The first region name =:','The second region name =:',...
                'The third region name =:','The fourth region name =:'};
            dlg_title = 'Regions Name';
            num_lines = 1;
            def = {'Region1','Region2','Region3','Region4'};
            answer = inputdlg(prompt,dlg_title,num_lines,def) ;
            for intchanNum = 1:RegionNum
                regionName{intchanNum}   = cellstr( answer{intchanNum});
            end
            topo_box(1,:,:) = topo_box_FR;
            topo_box(2,:,:) = topo_box_SR;
            topo_box(3,:,:) = topo_box_TR;
            topo_box(4,:,:) = topo_box_FOR;
    end
    y_min = 1.1*min(topo_box(:));
    y_max = 1.1*max(topo_box(:));
    if  length(regionName)>=3
        if NumGroups == 1
            rowNum = ceil(length(regionName)/2);
            columnNum = 2;
        else
            columnNum = length(regionName);
            rowNum = NumGroups;
        end
    else
        rowNum = length(regionName);
        columnNum = NumGroups;
    end
    countPlotfigu = countPlotfigu +1;
    figure(countPlotfigu);
    countplot = 0;
    set(gcf,'outerposition',get(0,'screensize'));
    for groupNum = 1:NumGroups
        for Numofrow = 1:length(regionName)
            countplot = countplot + 1;
            subplot(rowNum,columnNum,countplot,'align');
            set(gca,'fontsize',16,'FontWeight','bold');
            idx1 = find(Group_Idx == groupNum);
            topo_GA = squeeze(topo_box(Numofrow,:,idx1))';
            boxplot(topo_GA,Sti_names);
            text_h = findobj(gca,'Type','text');
            set(text_h,'FontSize', 14);
            ylim([y_min y_max])
            if countplot  == 1
                xlabel(['Stimulus']);
                ylabel(['Amplitude/\muV']);
                if NumGroups == 1
                    tN = strcat(regionName{Numofrow});
                else
                    tN = strcat(GroupNames{groupNum},'-',regionName{Numofrow});
                end
            elseif countplot == length(regionName) + 1
                if NumGroups == 1
                    tN = strcat(regionName{Numofrow});
                else
                    tN = strcat(GroupNames{groupNum},'-',regionName{Numofrow});
                end
            else
                tN = regionName{Numofrow};
            end
            title(tN,'fontsize',14);
            hold on;
        end
    end
    figureName = strcat(num2str(Numofintchannel),'_GA_toplotbox_',filechanName);
    set(figure(countPlotfigu),'paperunits','inches','paperposition',[0,0,16,9]);
    saveas(figure(countPlotfigu),[route figureName],'png');
    saveas(figure(countPlotfigu),[route figureName],'fig');
else
    topo_box = squeeze(mean(TOPO(ChansOfInterestNumbers,:,:),1))';
    y_min = 1.1*min(topo_box(:));
    y_max = 1.1*max(topo_box(:));
    rowNum = NumGroups;
    columnNum = 1;
    countPlotfigu = countPlotfigu +1;
    figure(countPlotfigu);
    set(gcf,'outerposition',get(0,'screensize'));
    for groupNum = 1:NumGroups
        subplot(rowNum,columnNum,groupNum,'align');
        set(gca,'fontsize',16,'FontWeight','bold');
        idx1 = find(Group_Idx == groupNum);
        topo_GA = squeeze(topo_box(idx1,:));
        boxplot(topo_GA,Sti_names)
        text_h = findobj(gca,'Type','text');
        set(text_h,'FontSize', 14);
        ylim([y_min y_max]);
        if groupNum  == 1
            xlabel(['Stimulus']);
            ylabel(['Amplitude/\muV']);
        end
        if NumGroups > 1
            tN = GroupNames{groupNum};
            title(tN);
        end
        
    end
    figureName = char(strcat(num2str(Numofintchannel),'_GA_toplotbox_',filechanName));
    set(figure(countPlotfigu),'paperunits','inches','paperposition',[0,0,16,9]);
    saveas(figure(countPlotfigu),[route figureName],'png');
    saveas(figure(countPlotfigu),[route figureName],'fig');
    X = reshape(topo_box,1,[]);
end
%% within-subjects analysis
if NumGroups == 1
    %%  one-way ANOVA
    if levelNum_first > 0 & levelNum_second == 0 & levelNum_third == 0
        staIDX = [];
        for sti = 1:NumSti
            idxStart = NumSubs*(sti-1) + 1;
            idxEnd = NumSubs*(sti);
            staIDX(idxStart:idxEnd,1) = sti;
        end
        fprintf('\n');
        [p,atab] = anovan(X,staIDX,'varnames',levelName_first);
        %%  two-way ANOVA
    elseif  levelNum_first > 0 & levelNum_second > 0 & levelNum_third == 0
        staIDX = [];
        count = 0;
        for Numoflevel_one = 1:levelNum_first
            idxStart = NumSubs*levelNum_second*(Numoflevel_one-1) + 1;
            idxEnd = NumSubs*levelNum_second*(Numoflevel_one);
            staIDX(idxStart:idxEnd,2) = Numoflevel_one;
            for sti = 1:levelNum_second
                count  = count +1;
                idxStart1 = NumSubs*(count-1) + 1;
                idxEnd1 = NumSubs*(count);
                staIDX(idxStart1:idxEnd1,1) = sti;
            end
        end
        varnames(1) = levelName_first;
        varnames(2) = levelName_second;
        fprintf('\n');
        [p,atab] = anovan(X,staIDX,'model','interaction' ,'varnames',varnames);
        %%  three-way ANOVA
    elseif  levelNum_first > 0 & levelNum_second > 0 & levelNum_third > 0
        staIDX = [];
        count = 0;
        count1 = 0;
        for Numoflevel_first = 1:levelNum_first
            idxStart = NumSubs*levelNum_second*levelNum_third*(Numoflevel_first-1) + 1;
            idxEnd = NumSubs*levelNum_second*levelNum_third*(Numoflevel_first);
            staIDX(idxStart:idxEnd,3) = Numoflevel_first;
            for Numoflevel_second = 1:levelNum_second
                count = count + 1;
                idxStart1 = NumSubs*levelNum_third*(count-1) + 1;
                idxEnd1 = NumSubs*levelNum_third*(count);
                staIDX(idxStart1:idxEnd1,2) = Numoflevel_second;
                for Numoflevel_third = 1:levelNum_third
                    count1  = count1 +1;
                    idxStart2 = NumSubs*(count1-1) + 1;
                    idxEnd2 = NumSubs*(count1);
                    staIDX(idxStart2:idxEnd2,1) = Numoflevel_third;
                end
            end
        end
        varnames(1) = levelName_first;
        varnames(2) = levelName_second;
        varnames(3) = levelName_third;
        fprintf('\n')
        [p,atab] = anovan(X,staIDX,'model',3 ,'varnames',varnames);
    end
    %% between subjects analysis
else
    %% two-way ANOVA
    if levelNum_first > 0 & levelNum_second > 0 & levelNum_third == 0
        staIDX = [];
        for sti = 1:NumSti
            idxStart = NumSubs*(sti-1) + 1;
            idxEnd = NumSubs*(sti);
            staIDX(idxStart:idxEnd,1) = Group_Idx;
            staIDX(idxStart:idxEnd,2) = sti;
        end
        fprintf('\n');
        varnames(1) = levelName_first;
        varnames(2) = levelName_second;
        [p,atab] = anovan(X,staIDX,'model','interaction' ,'varnames',varnames);
        %% three-way ANOVA
    elseif   levelNum_first > 0 & levelNum_second > 0 & levelNum_third > 0
        count = 0;
        count1 = 0;
        for Numoflevel_second = 1:levelNum_second
            idxStart = NumSubs*levelNum_third*(Numoflevel_second-1) + 1;
            idxEnd = NumSubs*levelNum_third*(Numoflevel_second);
            staIDX(idxStart:idxEnd,3) = Numoflevel_second;
            for Numoflevel_third = 1:levelNum_third
                count = count + 1;
                idxStart1 = NumSubs*(count-1) + 1;
                idxEnd1 = NumSubs*(count);
                staIDX(idxStart1:idxEnd1,2) = Numoflevel_third;
                count1  = count1 +1;
                idxStart2 = NumSubs*(count1-1) + 1;
                idxEnd2 = NumSubs*(count1);
                staIDX(idxStart2:idxEnd2,1) = Group_Idx;
            end
        end
        varnames(3) = levelName_first;
        varnames(1) = levelName_second;
        varnames(2) = levelName_third;
        fprintf('\n');
        [p,atab] = anovan(X,staIDX,'model',3 ,'varnames',varnames);
    end
end
uiwait(msgbox('The program end'));
%% program ends
toc