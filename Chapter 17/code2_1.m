clc;clear;close all;
rng(0);             %make the output of randn repeatable
n=10;               %sample size n=10				
x=randn(1,n)+0.8;   %generate the normal distribution	
disp(x);            %display the value of the samples
%[~,p1]=ttest(x);

%% calculate the t-value
x_bar=mean(x);
s=std(x);
t=x_bar/(s/sqrt(n));

%% calculate the p-value
p = 2 * tcdf(-abs(t), n-1);

%% figure
fig=figure();
x=linspace(-4,4,10001);
y = pdf('T',x,9);
hold on;grid on;box on;
idx=find(x<=-2.261,1,'last');
fill([-4,x(idx),x(idx:-1:1),-4],[0,0,y((idx:-1:1)),0],'c');
idx=find(x>=2.261,1);
fill([4,x(idx),x(idx:end),4],[0,0,y((idx:end)),0],'c');
plot(x,y,'k','linewidth',3);
plot([t,t],[0.05,0.005],'k','linewidth',3);
plot([t+0.05,t],[0.015,0.005],'k','linewidth',3);
plot([t-0.05,t],[0.015,0.005],'k','linewidth',3);
text(t-0.5,0.07,['t=',num2str(t,'%0.2f')],'fontsize',18);
title('t-distribution with df = 9');
xlabel('T');
ylabel('Pr(T)');
legend({['Reject region' char(10) ' with p<0.05']})
set(gca,'Ytick',0:0.1:0.4);
set(gca,'fontsize',18);
set(fig,'Position',[500 200 600 400]);
set(fig,'PaperPositionMode','auto');
print('-dpsc2',fig,'fig2_1.eps');