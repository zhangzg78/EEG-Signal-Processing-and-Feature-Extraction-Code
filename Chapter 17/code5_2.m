clc;clear;close all;						
[num,txt,raw] = xlsread('Resting State.xlsx');		
x=num(:,3);								
n=size(x,1);							
tval=mean(x)./(std(x)/sqrt(n));				
									
%% permutation							
N=1000;								
y=x*ones(1,N).*((randn(n,N)>0)*2-1);			
t_permute = mean(y,1)./(std(y,1)/sqrt(n));		
p=sum(abs(tval)<abs(t_permute))/N;				
disp(p);


fig=figure();
hold on;grid on; box on;
histogram(t_permute,100,'Normalization','pdf');
[f,xi] = ksdensity(t_permute);
plot(xi,f,'linewidth',3);
xlim([-4,4])
xlabel('t');

set(gca,'fontsize',18)
