% This code is used for running ICA
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
prompt = {'Number Of Selected Independent Components:','Number of Running Times:',...
    'ICA Algorithms (1.FastICA & 2.InfomaxICA):'};
dlg_title = 'Input Parameters';
num_lines = 1;
def = {'15','5','1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
Comp = str2num(answer{1});
Runs = str2num(answer{2});
Method_Flag = str2num(answer{3});
MethodString = {'FastICA','InfomaxICA1'};
Method = MethodString{Method_Flag} ;
Result_file = [pathname 'Result_' Method filesep] ;
[Patameter comp] = ChooseComp(EEG.data',Runs,Comp,Result_file,Method)
%%
toc