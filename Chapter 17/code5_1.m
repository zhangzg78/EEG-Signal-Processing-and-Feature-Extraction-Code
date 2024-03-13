clc;clear;close all;
[num,txt,raw] = xlsread('Resting State.xlsx');
x=num(:,3);
[p,h,stats] = signrank(x);