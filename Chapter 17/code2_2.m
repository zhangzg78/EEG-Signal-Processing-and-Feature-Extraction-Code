clc;clear;close all;
[num,txt,raw] = xlsread('Resting State.xlsx');

% %% one sample ttest
% x=num(:,3);
% [h1,p1,ci1,stats1]=ttest(x,'Tail','left');
% disp(['t = ',num2str(stats1.tstat,'%0.2f')]);	  
% disp(['p = ',num2str(p1,'%0.2e')]);	
% 
% %% paired-sample ttest		
% X_EO=num(:,1);
% X_EC=num(:,2);
% [h2,p2,ci2,stats2]=ttest(x_EO,x_EC);
% disp(['t = ',num2str(stats2.tstat,'%0.2f')]);
% disp(['p = ',num2str(p2,'%0.2e')]);

%% indenpendent two sample ttest
idx=num(:,5);
x=num(:,1);
x_M=x(idx==1);
x_F=x(idx==0);
[p3,stats3] = vartestn(x,idx,...
    'TestType','LeveneAbsolute','Display','off');
disp('Independent t-test with Eyes open:');
disp(['Levene¡¯s test: p = ',num2str(p3,'%0.2f')]);
if p3<0.05
    disp('Equal variances not assumed')
    [h4,p4,ci4,stats4]=ttest2(x_M,x_F,...
        'Vartype','unequal');								  
else
    disp('Equal variances assumed');
    [h4,p4,ci4,stats4]=ttest2(x_M,x_F);
end
disp(['t = ',num2str(stats4.tstat,'%0.2f')]);
disp(['df = ',num2str(stats4.df,'%0.2f')]);
disp(['p = ',num2str(p4,'%0.2f')]);
disp(' ');


