clc;clear;close all;
x=linspace(-6,6,10001);
y1 = pdf('Normal',x,0,0.5);
y2 = pdf('Normal',x,0,1);
y3 = pdf('Normal',x,0,2);
y4 = pdf('Normal',x,-2,1);

fig=figure();
hold on;grid on;box on;
plot(x,y1,'linewidth',3)
plot(x,y2,'linewidth',3)
plot(x,y3,'linewidth',3)
plot(x,y4,'linewidth',3)
title('(a) normal distribution');
xlabel('x');
ylabel('P(x)');
legend('\mu=0,\sigma=0.5','\mu=0,\sigma=1','\mu=0,\sigma=2','\mu=-2,\sigma=1');
set(gca,'fontsize',18);
set(fig,'Position',[100 450 500 400]);
set(fig,'PaperPositionMode','auto');

%% t-distribution
clc;clear;%close all;
fig=figure();
x=linspace(-6,6,10001);
y1 = pdf('T',x,1);
y2 = pdf('T',x,2);
y3 = pdf('T',x,5);
y4 = pdf('normal',x,0,1);
hold on;grid on;box on;
plot(x,y1,'linewidth',3)
plot(x,y2,'linewidth',3)
plot(x,y3,'linewidth',3)
plot(x,y4,'linewidth',3)
title('(b) {\itt}-distribution');
xlabel('x');
ylabel('P(x)');
legend('\nu=1','\nu=2','\nu=5','\nu=+\infty');
set(gca,'fontsize',18);
set(fig,'Position',[600 450 500 400]);
set(fig,'PaperPositionMode','auto');

%% Chi-squared distribution
clc;clear;%close all;
fig=figure();
x=linspace(0,10,10001);
y1 = pdf('Chisquare',x,1);
y2 = pdf('Chisquare',x,2);
y3 = pdf('Chisquare',x,3);
y4 = pdf('Chisquare',x,4);
y5 = pdf('Chisquare',x,5);
y6 = pdf('Chisquare',x,6);
y7 = pdf('Chisquare',x,7);
hold on;grid on;box on;
plot(x,y1,'linewidth',3)
plot(x,y2,'linewidth',3)
plot(x,y3,'linewidth',3)
plot(x,y4,'linewidth',3)
plot(x,y5,'linewidth',3)
plot(x,y6,'linewidth',3)
plot(x,y7,'linewidth',3)
title('(c) chi-squared distribution');
ylim([0,0.5])
xlabel('x');
ylabel('P(x)');
legend('k=1','k=2','k=3','k=4','k=5','k=6','k=7');
set(gca,'fontsize',18);
set(fig,'Position',[100 50 500 400]);
set(fig,'PaperPositionMode','auto');

%% F-distribution
clc;clear;%close all;
fig=figure();
x=linspace(0,3,10001);
y1 = pdf('F',x,1,1);
y2 = pdf('F',x,5,1);
y3 = pdf('F',x,10,2);
y4 = pdf('F',x,10,10);
y5 = pdf('F',x,100,100);
hold on;grid on;box on;
plot(x,y1,'linewidth',3)
plot(x,y2,'linewidth',3)
plot(x,y3,'linewidth',3)
plot(x,y4,'linewidth',3)
plot(x,y5,'linewidth',3)
title('(d) {\itF}-distribution');
ylim([0,2.2])
xlabel('x');
ylabel('P(x)');
legend('d1=1, d2=1','d1=5, d2=1','d1=10, d2=2',...
    'd1=10, d2=10','d1=100, d2=100');
set(gca,'fontsize',18);
set(fig,'Position',[600 50 500 400]);
set(fig,'PaperPositionMode','auto');
