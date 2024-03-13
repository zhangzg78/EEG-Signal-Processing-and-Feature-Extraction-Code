clc
clear
close all

tic
%%
load('G:\DUT\1 ASAP\3 hu\3 ICA\inputmatrix.mat');

%%
runs = 10;
Comp = 2:10;
Result_file = 'Result/';
data_mean = repmat(mean(data,2),1,size(data,2));
data = data - data_mean ;
mean_data = mean(data,2);
%%
[Patameter comp]= ChooseComp(data,runs,Comp,Result_file,'FastICA');
PlotParameter(Patameter,comp,runs);
%%
toc

