clc
clear
close all

tic
%%
load megdata;
%%
runs = 10;
Comp = 2:10;
Result_file = 'Result/';
[Patameter comp]= ChooseComp(megdata',runs,Comp,Result_file,'FastICA');

pth = [pwd '/Result']
load([pth '/PCA.mat'])
MaxIteration = 100 ;
 f_plot_ICA_parameter(latent,Comp,pth,MaxIteration)
%%
toc

