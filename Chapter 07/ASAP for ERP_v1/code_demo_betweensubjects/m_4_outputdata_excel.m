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
%% program start
%%  setting parameters
prompt = {'The name of the first factor =:','The name of the second factor =:',...
    'The name of the third factor =:','The level number of the first factor =:',...
    'The level number of the second factor =:','The level number of the third factor =:',...
    'Filter (1.Wavelet filter & 2.FFT filter & 3.None)','PCA (1.Yes & 2. No)',...
    'Measure method (1.Mean value & 2.Peak value)','ERPStart=:','ERPEnd=:'};
dlg_title = 'Input Parameters';
num_lines = 1;
def = {'Factor1','Factor2','Factor3','1','1','1','3','2','1','0','0'};
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
        dataFileName = ['D_',filterName]  ;
        load(dataFileName);
    end
else
    prompt = {'The number of reserved components=:','The number of interest component(s)=:'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'1','1'};
    answer = inputdlg(prompt,dlg_title,num_lines,def) ;
    R = str2num(answer{1});
    K = str2num(answer{2});
    if filterFlag == 3
        PCA_Data_fileName = ['D_PCA_rotation_R_',num2str(R),'_K_',num2str(K)];
    else
        PCA_Data_fileName = ['D_',filterName,'_PCA_rotation_R_',num2str(R),'_K_',num2str(K)];
    end
    load(PCA_Data_fileName);
end
NumGroups = max(Group_Idx);
%%
if NumGroups == 1
    if levelNum_first > 0 & levelNum_second == 0 & levelNum_third == 0
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
%% mean value/peak value
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
%% differnt region
if TF_R == 1
    %%
    for Numofregion = 1: RegionNum
        switch Numofregion
            %% first region
            case 1
                for is = 1:1000
                    ChansOfInterestNumbers_FR =[];
                    ChansOfInterestNames_FR =[];
                    prompt = {'The first channel name of the first region=:','The second channel name of the first region=:',...
                        'The third channel name of the first region=:', 'The fourth channel name of the first region=:',...
                        'The fifth channel name of the first region=:','The sixth channel name of the first region=:',...
                        'The seventh channel name of the first region=:' , 'The eighth channel name of the first region=:',...
                        'The ninth channel name of the first region=:'};
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
                            ChansOfInterestNumbers_FR(length(ChansOfInterestNumbers_FR)+1:length(ChansOfInterestNames_FR))=0;
                        end
                        min_Num = min(ChansOfInterestNumbers_FR(:));
                    elseif count1 == 9
                        min_Num = 0;
                    end
                    
                    if min_Num == 0
                        uiwait(msgbox('Input error electrode(s) name'));
                    else
                        break;
                    end
                end
                if  length(ChansOfInterestNames_FR) > 1
                    filechanName_FR = char(ChansOfInterestNames_FR{1});
                    for Numofchannel = 1:length(ChansOfInterestNames_FR) - 1
                        filechanName_FR = char(strcat(filechanName_FR,'-',ChansOfInterestNames_FR{Numofchannel+1}));
                    end
                else
                    filechanName_FR = char(ChansOfInterestNames_FR);
                end
                
                topo_box_FR = squeeze(mean(TOPO(ChansOfInterestNumbers_FR,:,:),1));
                %% second region
            case 2
                for is = 1:1000
                    ChansOfInterestNumbers_SR =[];
                    ChansOfInterestNames_SR =[];
                    prompt = {'The first channel name of the second region=:','The second channel name of the second region=:',...
                        'The third channel name of the second region=:', 'The fourth channel name of the second region=:',...
                        'The fifth channel name of the second region=:','The sixth channel name of the second region=:',...
                        'The seventh channel name of the second region=:' , 'The eighth channel name of the second region=:',...
                        'The ninth channel name of the second region =:'};
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
                            ChansOfInterestNumbers_SR(length( ChansOfInterestNumbers_SR)+1:length(ChansOfInterestNames_SR))=0;
                        end
                        min_Num = min(ChansOfInterestNumbers_SR(:));
                    elseif count1 == 9
                        min_Num = 0;
                    end
                    
                    if min_Num == 0
                        uiwait(msgbox('Input error electrode(s) name'));
                    else
                        break;
                    end
                end
                
                if  length(ChansOfInterestNames_SR) > 1
                    filechanName_SR = char(ChansOfInterestNames_SR{1});
                    for Numofchannel = 1:length(ChansOfInterestNames_SR) - 1
                        filechanName_SR = char(strcat(filechanName_SR,'-',ChansOfInterestNames_SR{Numofchannel+1}));
                    end
                else
                    filechanName_SR = char(ChansOfInterestNames_SR);
                end
                topo_box_SR = squeeze(mean(TOPO(ChansOfInterestNumbers_SR,:,:),1));
                %% third region
            case 3
                for is = 1:1000
                    ChansOfInterestNumbers_TR =[];
                    ChansOfInterestNames_TR =[];
                    prompt = {'The first channel name of the third region=:','The second channel name of the third region=:',...
                        'The third channel name of the third region=:', 'The fourth channel name of the third region=:',...
                        'The fifth channel name of the third region=:','The sixth channel name of the third region=:',...
                        'The seventh channel name of the third region=:' , 'The eighth channel name of the third region=:',...
                        'The ninth channel name of the third region=:'};
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
                            ChansOfInterestNumbers_TR(length(ChansOfInterestNumbers_TR)+1:length(ChansOfInterestNames_TR))=0;
                        end
                        min_Num = min(ChansOfInterestNumbers_TR(:));
                        
                    elseif count1 == 9
                        min_Num = 0;
                    end
                    
                    if min_Num == 0
                        uiwait(msgbox('Input error electrode(s) name'));
                    else
                        break;
                    end
                end
                if  length(ChansOfInterestNames_TR) > 1
                    filechanName_TR = char(ChansOfInterestNames_TR{1});
                    for Numofchannel = 1:length(ChansOfInterestNames_TR) - 1
                        filechanName_TR = char(strcat(filechanName_TR,'-',ChansOfInterestNames_TR{Numofchannel+1}));
                    end
                else
                    filechanName_TR = char(ChansOfInterestNames_TR);
                end
                topo_box_TR = squeeze(mean(TOPO(ChansOfInterestNumbers_TR,:,:),1));
                %% fourth region
            case 4
                for is = 1:1000
                    ChansOfInterestNumbers_FOR =[];
                    ChansOfInterestNames_FOR =[];
                    prompt = {'The first channel name of the fourth region=:','The second channel name of the fourth region=:',...
                        'The third channel name of the fourth region=:', 'The fourth channel name of the fourth region=:',...
                        'The fifth channel name of the fourth region=:','The sixth channel name of the fourth region=:',...
                        'The seventh channel name of the fourth region=:' , 'The eighth channel name of the fourth region=:',...
                        'The ninth channel name of the fourth region=:'};
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
                            ChansOfInterestNumbers_FOR(length(ChansOfInterestNumbers_FOR)+1:length(ChansOfInterestNames_FOR))=0;
                        end
                        min_Num = min(ChansOfInterestNumbers_FOR(:));
                    elseif count1 == 9
                        min_Num = 0;
                    end
                    
                    if min_Num == 0
                        uiwait(msgbox('Input error electrode(s) name'));
                    else
                        break;
                    end
                end
                if  length(ChansOfInterestNames_FOR) > 1
                    filechanName_FOR = char(ChansOfInterestNames_FOR{1});
                    for Numofchannel = 1:length(ChansOfInterestNames_FOR) - 1
                        filechanName_FOR = char(strcat(filechanName_FOR,'-',ChansOfInterestNames_FOR{Numofchannel+1}));
                    end
                else
                    filechanName_FOR = char(ChansOfInterestNames_FOR);
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
            data = TOPO_box1;
            filechanName = char(strcat('Region-',filechanName_FR,'-',filechanName_SR));
            prompt = {'The first region name =:','The second region name =:'};
            dlg_title = 'Regions Name';
            num_lines = 1;
            def = {'Region1','Region2'};
            answer = inputdlg(prompt,dlg_title,num_lines,def) ;
            for intchanNum = 1:RegionNum
                regionName{intchanNum}   = cellstr( answer{intchanNum});
            end
            count = 0;
            for Numofsti = 1:length(Sti_names)
                for Numofregion = 1:RegionNum
                    count = count +1;
                    Name = strcat(Sti_names{Numofsti},'-',regionName{Numofregion});
                    Names_sti{count} = Name{1,1};                          %% if error please replace Name{1,1} by Name;
                end
            end
        case  3
            for stiNum = 1:NumSti
                TOPO_box1(RegionNum*stiNum-2,:)  = topo_box_FR(stiNum,:);
                TOPO_box1(RegionNum*stiNum-1,:)  = topo_box_SR(stiNum,:);
                TOPO_box1(RegionNum*stiNum,:)  = topo_box_TR(stiNum,:);
            end
            data = TOPO_box1;
            filechanName = char(strcat('Region-',filechanName_FR,'-',filechanName_SR,'-',filechanName_TR));
            prompt = {'The first region name =:','The second region name =:',...
                'The third region name =:'};
            dlg_title = 'Regions Name';
            num_lines = 1;
            def = {'Region1','Region2','Region3'};
            answer = inputdlg(prompt,dlg_title,num_lines,def) ;
            for intchanNum = 1:RegionNum
                regionName{intchanNum}   = cellstr( answer{intchanNum});
            end
            count = 0;
            for Numofsti = 1:length(Sti_names)
                for Numofregion = 1:RegionNum
                    count = count +1;
                    Name = strcat(Sti_names{Numofsti},'-',regionName{Numofregion});
                    Names_sti{count} = Name{1,1};                          %% if error please replace Name{1,1} by Name;
                end
            end
            
        case 4
            for stiNum = 1:NumSti
                TOPO_box1(RegionNum*stiNum-3,:)  = topo_box_FR(stiNum,:);
                TOPO_box1(RegionNum*stiNum-2,:)  = topo_box_SR(stiNum,:);
                TOPO_box1(RegionNum*stiNum-1,:)  = topo_box_TR(stiNum,:);
                TOPO_box1(RegionNum*stiNum,:)  = topo_box_FOR(stiNum,:);
            end
            data = TOPO_box1;
            filechanName = char(strcat('Region-',filechanName_FR,'-',filechanName_SR,'-',filechanName_TR,'-',filechanName_FOR));
            prompt = {'The first region name =:','The second region name =:',...
                'The third region name =:','The fourth region name =:'};
            dlg_title = 'Regions Name';
            num_lines = 1;
            def = {'Region1','Region2','Region3','Region4'};
            answer = inputdlg(prompt,dlg_title,num_lines,def) ;
            for intchanNum = 1:RegionNum
                regionName{intchanNum}   = cellstr( answer{intchanNum});
            end
            count = 0;
            for Numofsti = 1:length(Sti_names)
                for Numofregion = 1:RegionNum
                    count = count +1;
                    Name = strcat(Sti_names{Numofsti},'-',regionName{Numofregion});
                    Names_sti{count} = Name{1,1};                          %% if error please replace Name{1,1} by Name;
                end
            end
    end
else
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
        %% find the number(s) and name(s) of interest electrodes
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
            uiwait(msgbox('Input error electrode(s) name'));
        else
            break;
        end
    end
    data = squeeze(mean(TOPO(ChansOfInterestNumbers,:,:),1));
    if  length(ChansOfInterestNames) > 1
        filechanName = ChansOfInterestNames{1};
        for Numofchannel = 1:length(ChansOfInterestNames) - 1
            filechanName = char(strcat(filechanName,'-',ChansOfInterestNames{Numofchannel+1}));
        end
    else
        filechanName = char(ChansOfInterestNames);
    end
    Names_sti = Sti_names;
end
%%
excelEnd_1   = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q',...
    'R','S','T','U','V','W','X','Y','Z'};
count = 0;
for iss = 1:5
    for is  = 1:length(excelEnd_1)
        count = count +1;
        excelEnd_2{count} = [excelEnd_1{iss},excelEnd_1{is}];
    end
end
excelEnd = [excelEnd_1,excelEnd_2];
data = permute(data,[2 1]);
if NumGroups == 1
    x = data;
    rangeName = Names_sti;
else
    x = [Group_Idx,data];
    rangeName = ['Group', Names_sti];
end

[rowNum,columnNum] = size(x);

if PCA_Flag == 2
    route = char(strcat('Output_excel\',filterName,'\',num2str(ERPStart),'-',num2str(ERPEnd),'ms-',filechanName,'\'));
else
    route = char(strcat('Output_excel\',filterName,'\PCA\R_',num2str(R),'_K_',num2str(K),'\',num2str(ERPStart),'-',num2str(ERPEnd),'ms-',filechanName,'\'));
end
mkdir(route);
excelName = measureName;
heandrang = strcat('A1:',excelEnd{columnNum},int2str(1));
datarang = strcat('A2:',excelEnd{columnNum},int2str(rowNum+1));
xlswrite([route excelName],rangeName,heandrang);
xlswrite([route excelName],x,datarang);%% if cann't output data ,please replace excelName{1,1} by excelName
uiwait(msgbox('The program end'));
%% program ends
toc