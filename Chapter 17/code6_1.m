LW_init();

%% average
option=struct('filename','P300 Nontarget.lw6');
lwdata= FLW_load.get_lwdata(option);
option=struct('operation','average','suffix','avg','is_save',1);
lwdata= FLW_average_epochs.get_lwdata(lwdata,option);

option=struct('filename','P300 Target.lw6');
lwdata= FLW_load.get_lwdata(option);
option=struct('operation','average','suffix','avg','is_save',1);
lwdata= FLW_average_epochs.get_lwdata(lwdata,option);

%% cluster-based permutation test
option=struct('filename',{{'P300 Nontarget.lw6','P300 Target.lw6'}});
lwdataset= FLW_load.get_lwdataset(option);
option=struct('test_type','paired sample','tails','both','ref_dataset',1,'alpha',0.05,'permutation',1,'cluster_threshold',0.05,'num_permutations',2000,'show_progress',1,'suffix','ttest','is_save',1);
lwdataset= FLW_ttest.get_lwdataset(lwdataset,option);

%% figure 
clc;clear;close all;						
data=load('avg P300 Nontarget.mat');
P300_nontarget=squeeze(data.data);						
data=load('avg P300 Target.mat');
P300_target=squeeze(data.data);					
data=load('ttest P300 Target.mat');
p_idx=bwlabel(squeeze(data.data(:,:,1,:,:,:))<0.05);
p1_idx=bwlabel(squeeze(data.data(:,:,1,:,:,:))<0.05/2500);
p2_idx=bwlabel(squeeze(data.data(:,:,3,:,:,:))<0.05);
t_val=squeeze(data.data(:,:,2,:,:,:));
t=(1:2500)/1000-0.5;

fig=figure('Renderer','Painters');
subplot(3,1,1)
hold on;
plot(t,P300_nontarget,'linewidth',3);
plot(t,P300_target,'linewidth',3);
xlabel('t [sec]');
ylabel('amplitude [\muV]');
ylim([-3 7])
set(gca,'Xaxislocation','origin');
set(gca,'fontsize',12);
legend('nontarget','target');

subplot(3,1,2)
hold on;
plot(t,t_val,'k','linewidth',3);
plot(t([1,end]),2.131*[1,1],'k--','linewidth',1);
plot(t([1,end]),6.109*[1,1],'k:','linewidth',1);
for k=4
    idx=find(p_idx==k);
    fill([t(idx(1)),t(idx),t(idx(end))],[0,t_val(idx)',0],0.8*[1,1,1]);
end
plot(t,t_val,'k','linewidth',3);
plot(t([1,end]),2.131*[1,1],'k--','linewidth',1);
plot(t([1,end]),6.109*[1,1],'k:','linewidth',1);
plot(t([1,end]),-6.109*[1,1],'k:','linewidth',1);
plot(t([1,end]),-2.131*[1,1],'k--','linewidth',1);
ylabel('t-statistic');
ylim([-15,15])
legend('t-statistic','uncorrected critical value','Bonferroni-corrected critical value','location','southeast');
set(gca,'Xaxislocation','origin');
set(gca,'fontsize',12);


subplot(3,1,3)
hold on;
plot(t([1,1]),[0.5,3.5],'k','linewidth',1);
plot(t([1,end]),1*[1,1],'k','linewidth',1);
plot(t([1,end]),2*[1,1],'k','linewidth',1);
plot(t([1,end]),3*[1,1],'k','linewidth',1);
for k=1:max(p_idx)
    idx=find(p_idx==k);
    fill([t(idx(1)),t(idx(end)),t(idx(end)),t(idx(1)),t(idx(1))],[-1,-1,1,1,-1]*0.2+3,0.8*[1,1,1]);
end
for k=1:max(p1_idx)
    idx=find(p1_idx==k);
    fill([t(idx(1)),t(idx(end)),t(idx(end)),t(idx(1)),t(idx(1))],[-1,-1,1,1,-1]*0.2+2,0.8*[1,1,1]);
end
for k=1:max(p2_idx)
    idx=find(p2_idx==k);
    fill([t(idx(1)),t(idx(end)),t(idx(end)),t(idx(1)),t(idx(1))],[-1,-1,1,1,-1]*0.2+1,0.8*[1,1,1]);
end
text(1.3,3.23,'Uncorrected','Fontsize',12);
text(1.3,2.23,'Bonferroni','Fontsize',12);
text(1.3,1.23,'Cluster Based','Fontsize',12);
axis off;
set(gca,'fontsize',12);
set(fig,'Position',[500 200 400 600]);




