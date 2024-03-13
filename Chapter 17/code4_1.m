clc;clear;close all;
[num,txt,raw] = xlsread('Resting State.xlsx');
x=num(:,1);
y=num(:,2);
[r_corr,p_corr]=corr(x,y);
[b_reg,~,~,~,stats_reg] = regress(y,[x,ones(93,1)]);

fig=figure();
try
    ax=axes('XAxisLocation','origin','YAxisLocation','origin');
    hold on;
catch
    hold on;grid on;box on;
end
plot(x,y,'k*');
plot([min(x),max(x)],[min(x),max(x)]*b_reg(1)+b_reg(2),'k','linewidth',2);
xlabel('x','fontsize',18)
ylabel('y','fontsize',18)
text(-26,23,['y=',num2str(b_reg(1),'%0.2f'),'x+',num2str(b_reg(2),'%0.2f')],'fontsize',18)
text(-26,19,['R^2=',num2str(stats_reg(1),'%0.3f')],'fontsize',18);

set(fig,'Position',[500 200 600 400]);
set(fig,'PaperPositionMode','auto');


