clc;clear;close all;
[num,txt,raw] = xlsread('Resting State.xlsx');
% 
% %% one-way ANOVA
% x=num(:,1);
% group=num(:,4);
% [p,tbl,stats] = anova1(x,group);
% 
%% repeated measures two-way ANOVA
t=table(num2str(num(:,4)),num(:,1),num(:,2),...
    'VariableNames',{'time','EO','EC'});
Meas = table([1 2]','VariableNames',{'eye'});
rm = fitrm(t,'EO, EC ~ time','WithinDesign',Meas);
ranovatbl = ranova(rm)
anovatbl = anova(rm)
