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
%%
tic
uiwait(msgbox('Please Select Data file by this format: ""Channel x Sample x Stimulus x Subject"" !  ',...
    'Selecting'));
[fData,filepath]= uigetfile({'*.*','All Files'},...
    'Select Data File 1');
D = importdata([filepath,fData]);

uiwait(msgbox('Please Select channel file by this format:'));
[fData1,filepath1]=uigetfile({'*.*','All Files'},...
    'Select Channel File 1');
chanlocs = importdata([filepath1,fData1]);

prompt = {'Sampling rate(Hz):','Epoch start(millisecond):',...
    'Epoch end(millisecond):','Group number:'};
dlg_title = 'Input Parameters';
num_lines = 1;
def = {'500','-200','1000','1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
fs = str2num(answer{1});
timeStart = str2num(answer{2});
timeEnd = str2num(answer{3});
GroupNum = str2num(answer{4});

if GroupNum == 1
prompt = {'The number subjects:'};
dlg_title = 'Input';
num_lines = 1;
def = {'20'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
Numofsub_first = str2num(answer{1});
Group_Idx = ones(Numofsub_first,1);
elseif GroupNum == 2
    
  prompt = {'The number subjects of the first group:',...
      'The number subjects of the second group:'};
dlg_title = 'Input Parameters';
num_lines = 1;
def = {'15','15'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
Numofsub_first = str2num(answer{1});  
Numofsub_second = str2num(answer{2});  
Group_Idx = [ones(Numofsub_first,1);2*ones(Numofsub_second,1)];


elseif GroupNum == 3
  prompt = {'The number subjects of the first group:',...
      'The number subjects of the second group:',...
      'The number subjects of the third group:'};
dlg_title = 'Input Parameters';
num_lines = 1;
def = {'20','20','20'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
Numofsub_first = str2num(answer{1});  
Numofsub_second = str2num(answer{2}); 
Numofsub_third = str2num(answer{3});
Group_Idx = [ones(Numofsub_first,1);2*ones(Numofsub_second,1);3*ones(Numofsub_third,1)];
end
save('D','D','chanlocs','Group_Idx','timeStart','timeEnd','fs','-V7.3');
uiwait(msgbox('The program end'));
%%
toc