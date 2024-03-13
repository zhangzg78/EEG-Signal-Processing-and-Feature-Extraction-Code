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
prompt = {'The name of the first factor =:','The name of the second factor =:',...
    'The name of the third factor =:','The level of the first factor =:',...
    'The level of the second factor =:','The level of the third factor =:',...
    'Filter (1.Waveletfilter & 2.FFTfilter & 3.None):'};
dlg_title = 'Input';
num_lines = 1;
def = {'Factor1','Factor2','Factor3','1','1','0','3'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
levelName_first = cellstr(answer{1});
levelName_second = cellstr(answer{2});
levelName_third = cellstr(answer{3});
levelNum_first = str2num(answer{4});
levelNum_second = str2num(answer{5});
levelNum_third = str2num(answer{6});
filterFlag = str2num(answer{7});
filterStrings = {'Wavelet filter','FFT filter','Conventional'};
methodName = filterStrings{filterFlag};


if filterFlag == 3
    fileName = ['D'];
else
    fileName = ['D_',methodName];
end
load(fileName);
[NumChans,NumSamps,NumSti,NumSubs] = size(D);
D = double(D);

NumGroups = max(Group_Idx);
if NumGroups == 2
    prompt = {'The name of the first group','The name of the second group'};
    dlg_title = 'Input Parameters';
    num_lines = 1;
    def = {'group 1','group 2'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    for iss = 1:length(def)
        legendNames{iss} = char(cellstr(answer{iss}));
    end
elseif NumGroups == 3
    prompt = {'The name of the first group','The name of the second group',...
        'The name of the third group'};
    dlg_title = 'Input Parameters';
    num_lines = 1;
    def = {'group 1','group 2','group 3'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    for iss = 1:length(def)
        legendNames{iss} = char(cellstr(answer{iss}));
    end
end
%%
%% grouping data into a matrix
temp = permute(D,[2 1 3 4]);
X= reshape(temp,NumSamps,NumChans*NumSti*NumSubs);
timeIndex = linspace(timeStart,timeEnd,NumSamps);

%%  PCA
[coef,score,lambda] = princomp(X');
ratio = f_explainedVariance(lambda);

threshold = [99 95 90];
for is = 1:length(threshold)
    [va idx] = find(ratio<threshold(is));
    thresholdcomponetsNum(is) = length(idx)+1;
end
%%
for is = 1:length(lambda)
    ratio_sigle(is) = 100*lambda(is)./sum(lambda);
end
%%
figure(100)
set(gcf,'outerposition',get(0,'screensize'))
subplot(2,2,1);
set(gca,'fontsize',14)
plot(lambda,'ko','linewidth',4)
xlim([0.5 NumSamps+0.5])
title('Magnitude of lambda')
xlabel('Lambda #')
ylim([-lambda(1) 1.5*lambda(1)])

subplot(2,2,2);
set(gca,'fontsize',14)
plot(ratio,'k-.','linewidth',4)
xlim([0.5 NumSamps+0.5])
title('Explained variance of accumulated lambda(%)')
xlabel('Accumulated lambda')
ylim([0 120])

subplot(2,2,3);
set(gca,'fontsize',14)
plot(lambda,'ko','linewidth',4)
xlim([0.5 70+0.5])
xlabel('Lambda #')
ylim([-lambda(1) 1.5*lambda(1)])

subplot(2,2,4);
set(gca,'fontsize',14)
plot(ratio,'k-.','linewidth',4)
xlim([0.5 100+0.5])
xlabel('Accumulated lambda')
ylim([0 120])
%%first components labmdaexp
x = 1;
y = ratio(1);
y = roundn(y,-2);
text(x+1,y-1,['(' num2str(x) ',' num2str(y) '%)'],'fontsize',16,'color','b');%%color  x,y label
text(x,y,'0','color','r','fontsize',10);
%%mark x y axis
hold on;
x1 = thresholdcomponetsNum(1);
y1 = threshold(1);
plot([x1 x1], [0 y1],'r','linewidth',1);%%mark x axis
plot([0 x1], [y1 y1],'r','linewidth',1);%%mark y axis
text(x1-5,y1+6,['(' num2str(x1) ',' num2str(y1) '%)'],'fontsize',16,'color','b');
hold on;
x2 = thresholdcomponetsNum(2);
y2 = threshold(2);
plot([x2 x2], [0 y2],'r','linewidth',1);%%mark x axis
plot([0 x2], [y2 y2],'r','linewidth',1);%%mark y axis
text(x2+1,y2-2,['(' num2str(x2) ',' num2str(y2) '%)'],'fontsize',16,'color','b');
hold on;
x3 = thresholdcomponetsNum(3);
y3 = threshold(3);
plot([x3 x3], [0 y3],'r','linewidth',1);%%mark x axis
plot([0 x3], [y3 y3],'r','linewidth',1);%%mark y axis
text(x3+1,y3-5,['(' num2str(x3) ',' num2str(y3) '%)'],'fontsize',16,'color','b');
%%
prompt = {'The number of reserved components=:'};
dlg_title = 'Input';
num_lines = 1;
def = {'1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
R = str2num(answer{1});

ratio_sigle_keep = ratio_sigle(1:R);

route = strcat(num2str(filterFlag),'_',methodName,'\PCA\Reserved compoents',num2str(R),'\');
mkdir(route);

%% rotation
V = coef(:,1:R);
Z = score(:,1:R);
%% rotation for blind source separation
[translated_V,W] = rotatefactors(V, 'Method','promax','power',3,'Maxit',500);
B = inv(W');
Y = Z*W; %%% spatial components
T = V*B;  %%% temporal components

[peakValue,peakTime] = max(abs(T));
timePstart = ceil((0-timeStart)/(1000/fs))+1;
for r = 1 :R
    temp = T(:,r);
    T (:,r) =  temp - mean(temp(1:timePstart));
    peak_T(r) = ceil((peakTime(r)-1)*(1000/fs)) + timeStart;
end
%%
topo = reshape(Y',R,NumChans,NumSti,NumSubs);
topo_similarity_AV =[];
for groupNum = 1:NumGroups
    idx1 = find(Group_Idx == groupNum);
    topo_av(:,:,:,groupNum) = mean(topo(:,:,:,idx1),4);
    for k = 1:R
        for sti = 1:NumSti
            temp = corr(squeeze(topo(k,:,sti,idx1)));
            topo_similarity{:,:,k,sti,groupNum} = temp;
            RHO(k,sti,groupNum) = mean(temp(:));
        end
    end
end
rho = mean(RHO,2);
[rho_ranked, idx] = sort(rho,'descend');
%% Explained variance of each component of keep componets and Correlation Coefficient between spatial components
if NumGroups == 1
    if levelNum_first > 0 & levelNum_second== 0 & levelNum_third == 0
        for Numoffirst = 1:levelNum_first
            Sti_names{Numoffirst} = char(strcat(levelName_first,num2str(Numoffirst)));
        end
    elseif  levelNum_first > 0 & levelNum_second > 0 & levelNum_third == 0
        count = 0;
        for Numoffirst = 1:levelNum_first
            for Numofsecond = 1:levelNum_second
                count = count +1;
                Sti_names{count} = char(strcat(levelName_first,num2str(Numoffirst),'-',levelName_second,num2str(Numofsecond)));
            end
        end
        %%%
    elseif  levelNum_third > 0
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
    %%%
else NumGroups > 1
    %%%
    if  levelNum_first > 0 & levelNum_second > 0 & levelNum_third == 0
        count = 0;
        for Numofsecond = 1:levelNum_second
            for Numoffirst = 1:levelNum_first
                count = count +1;
                Sti_names{count} = char(strcat(levelName_first,num2str(Numoffirst),'-',levelName_second,num2str(Numofsecond)));
            end
        end
        
        %%%
    elseif  levelNum_third > 0
        count = 0;
        for Numofsecond = 1:levelNum_second
            for Numofthird = 1:levelNum_third
                for Numoffirst = 1:levelNum_first
                    count = count +1;
                    Sti_names{count} = char(strcat(levelName_first,num2str(Numoffirst),'-',levelName_second,num2str(Numofsecond),'-',levelName_third,num2str(Numofthird)));
                end
            end
        end
    end
    %%%
end


rowNum = 2;
columnNum = 1;
figure(101);
set(gcf,'outerposition',get(0,'screensize'));
subplot(rowNum,columnNum,1);
set(gca,'fontsize',16,'FontWeight','bold');
bar(ratio_sigle_keep);
xlim([0 R+1]);
ylim([0 ratio(1)+10]);
xlabel('Component#','fontsize',16)
ylabel(['Explained variance(%)'],'fontsize',16);
title([methodName,'-PCA-','Explained variance of each component in the keep componets '],'fontsize',16);
hold on;
subplot(rowNum,columnNum,2,'align');
set(gcf,'outerposition',get(0,'screensize'));
set(gca,'fontsize',16,'FontWeight','bold');
count = 0;
for groupNum = 1:NumGroups
    for sti = 1:NumSti
        count = count +1;
        switch count
            case 1
                plot([1:R],squeeze(RHO(:,sti,groupNum)),'k-O','linewidth',2);
                hold on;
                grid on;
            case 2
                plot([1:R],squeeze(RHO(:,sti,groupNum)),'k-*','linewidth',2);
                hold on;
                grid on;
            case 3
                plot([1:R],squeeze(RHO(:,sti,groupNum)),'r-o','linewidth',2);
                hold on;
                grid on;
            case 4
                plot([1:R],squeeze(RHO(:,sti,groupNum)),'r-*','linewidth',2);
                hold on;
                grid on;
            case 5
                 plot([1:R],squeeze(RHO(:,sti,groupNum)),'k-+','linewidth',2);
                hold on;
                grid on;
            case 6
                plot([1:R],squeeze(RHO(:,sti,groupNum)),'r-+','linewidth',2);
                hold on;
                grid on;
            case 7
              plot([1:R],squeeze(RHO(:,sti,groupNum)),'b-o','linewidth',2);
                hold on;
                grid on;
            case 8
              plot([1:R],squeeze(RHO(:,sti,groupNum)),'b-*','linewidth',2);
                hold on;
                grid on;
             case 9
              plot([1:R],squeeze(RHO(:,sti,groupNum)),'b-+','linewidth',2);
                hold on;
                grid on;
        end
    end
    hold on;
    ylim([min(RHO(:))-0.05,max(RHO(:))+0.05]);
    xlim([0.5,R+0.5]);
end
legend(Sti_names,'location','best');
ylabel(['MVCC'],'fontsize',16);
xlabel(['Component #'],'fontsize',16); 
title(['Mean Value of Correlation Coefficient(MVCC)between topographies of each component'],'fontsize',16);
figureName = char(['MVCC_ratio']);
set(figure(101),'paperunits','inches','paperposition',[0,0,16,9]);
saveas(figure(101),[route figureName],'png');
saveas(figure(101),[route figureName],'fig');
%%  plot results of temporal components and spatial components
if NumGroups == 1
    if levelNum_first > 0 & levelNum_second== 0 & levelNum_third == 0
        for Numoffirst = 1:levelNum_first
            Sti_names{Numoffirst} = char(strcat(levelName_first,num2str(Numoffirst)));
        end
    elseif  levelNum_first > 0 & levelNum_second > 0 & levelNum_third == 0
        count = 0;
        for Numoffirst = 1:levelNum_first
            for Numofsecond = 1:levelNum_second
                count = count +1;
                Sti_names{count} = char(strcat(levelName_first,num2str(Numoffirst),'-',levelName_second,num2str(Numofsecond)));
            end
        end
        %%%
    elseif  levelNum_third > 0
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
    %%%
else NumGroups > 1
    %%%
    if  levelNum_first > 0 & levelNum_second > 0 & levelNum_third == 0
        for Numofsecond = 1:levelNum_second
            Sti_names{Numofsecond} = char(strcat(levelName_second,num2str(Numofsecond)));
        end
        %%%
    elseif  levelNum_third > 0
        count = 0;
        for Numofsecond = 1:levelNum_second
            for Numofthird = 1:levelNum_third
                count = count +1;
                Sti_names{count} = char(strcat(levelName_second,num2str(Numofsecond),'-',levelName_third,num2str(Numofthird)));
            end
        end
    end
    %%%
end

if NumSti*NumGroups <= 6
    rowNum = 3;
    columnNum = NumSti*NumGroups;
else
    rowNum = 5;
    columnNum = ceil(NumSti*NumGroups/2);
end
count_rr = ceil(rowNum/2)*columnNum+ 1;
for kk = 1:R
    k = idx(kk);
    topo_k = squeeze(topo_av(k,:,:,:));
    mV = max(abs(topo_k(:)));
    figure(kk)
    set(gcf,'outerposition',get(0,'screensize'))
    subplot(rowNum,columnNum,[1:columnNum],'align')
    set(gca,'fontsize',14)
    plot(timeIndex,T(:,k),'k','linewidth',3)
    xlim([timeStart timeEnd])
    grid on
    xlabel('Time/ms')
    ylabel('Magnitude')
    title(['Comp #',int2str(k),'(Explained variance =',num2str(roundn(ratio_sigle_keep(k),-2)),'%, Peak Time = ',num2str(peak_T(k)),'ms)']);
    set(gca,'ydir','reverse');
    count = 0;
    for groupNum = 1:NumGroups
        for sti = 1:NumSti
            count = count +1;
            subplot(rowNum,columnNum,columnNum + count,'align')
            set(gca,'fontsize',14)
            topoplot(squeeze(topo_av(k,:,sti,groupNum)),chanlocs,'maplimits',[-mV,mV]);
            colorbar;
            if sti == 1
                if  NumGroups == 1
                    tN = Sti_names{sti};
                else
                    tN = strcat(legendNames{groupNum},'-',Sti_names{sti});
                end
            else
                tN = Sti_names{sti};
            end
            title(tN,'fontsize',14);
            set(gca,'clim',[-mV mV])
            subplot(rowNum,columnNum,ceil(rowNum/2)*columnNum+count,'align')
            set(gca,'fontsize',14)
            imagesc(squeeze(topo_similarity{:,:,k,sti,groupNum}))
            set(gca,'clim',[-1 1])
            colorbar;
            if sti == 1
                if  NumGroups == 1
                    tN = [Sti_names{sti}];
                else
                    tN = strcat(legendNames{groupNum},'-',Sti_names{sti});
                end
            else
                tN = [Sti_names{sti}];
            end
            title(tN,'fontsize',14);
            if ceil(rowNum/2)*columnNum +count == count_rr
                xlabel('Subject #')
                ylabel('Subject #')
            end
        end
    end
    
    figureName = char(strcat('Component_',num2str(kk)));
    set(figure(kk),'paperunits','inches','paperposition',[0,0,16,9]);
    saveas(figure(kk),[route figureName],'png');
    saveas(figure(kk),[route figureName],'fig');
end
%%
msgbox('If you want to select interest component(s),Please press any key!!!')
pause;
for is  = 1:100
    prompt = {'The component(s) number of interest = :'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'0'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    selectedComponentNumbers = str2num(answer{1});
    min_Num = min(selectedComponentNumbers);
    if min_Num == 0
        uiwait(msgbox('Input incorrect number'));
    else
        break;
    end
end
E = T(:,selectedComponentNumbers)*Y(:,selectedComponentNumbers)';
temp = reshape(E,NumSamps,NumChans,NumSti,NumSubs);
D = permute(temp,[2 1 3 4]);
fileNameNew = [fileName,'_PCA_rotation_R_',num2str(R),'_K_',num2str(selectedComponentNumbers)];
save(fileNameNew,'D','chanlocs','Group_Idx','timeStart','timeEnd','fs')
uiwait(msgbox('The program end'));
%% program end
toc