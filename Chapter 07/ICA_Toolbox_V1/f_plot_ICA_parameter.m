function f_plot_ICA_parameter(latent,Comp,pth,MaxIteration)
% file = dir([pth 'Iq\*.mat']);
% maxComp = length(file)+19;
maxComp = max(Comp);
tmp = load([pth filesep 'step' filesep int2str(Comp(1)) '.mat']);
tmp = tmp.step;
runs = length(tmp);
for comp = Comp
    load([pth filesep 'Iq' filesep int2str(comp) '.mat']);
    tmp = load([pth filesep 'step' filesep int2str(comp) '.mat']);
    tmp = tmp.step;
    Patameter(comp,1) = nanmean(iq);
    Patameter(comp,2) = nanstd(iq);
    Patameter(comp,3) = nanmean(tmp(tmp<MaxIteration));
    Patameter(comp,4) = nanstd(tmp(tmp<MaxIteration));
    Patameter(comp,5) = size(tmp(tmp<MaxIteration),2);
    Patameter(comp,6) = sum(latent(1:comp))/sum(latent);
end
Patameter(1,6) = sum(latent(1:1))/sum(latent);
%%
figure
set(gcf,'outerposition',get(0,'screensize'))
subplot(221)
plot(Patameter(1:maxComp,3),'xg','linewidth',2);hold on
plot(Patameter(1:maxComp,4),'or','linewidth',2);hold off
set(gca,'fontsize',14);
ylabel('Number of steps')
xlabel('(a) Number of extracted components');
ylim([-10 140]);
set(gca,'fontsize',14);
legend(['Mean of numbers of used steps to converge among' int2str(runs) 'runs'],...
    ['SD of numbers of used steps to converge among' int2str(runs) 'runs','location','best']);
grid on
subplot(223)
plot(Patameter(1:maxComp,1),'+m','linewidth',2);hold on
plot(Patameter(1:maxComp,2),'*r','linewidth',2);hold off
ylim([-0.1 1.1]);
set(gca,'fontsize',14);
xlabel('(c) Number of extracted components');
ylabel('Magnitude of Iq')
set(gca,'fontsize',14);
legend('Mean of Iqs of extracted components','SD of Iqs of extracted components','Location','Best');
grid on
subplot(222)
plot(Patameter(1:maxComp,5),'v','linewidth',2);
ylim([-5 runs+5]);
set(gca,'fontsize',14);
xlabel('(b) Number of extracted components');
set(gca,'fontsize',14);
ylabel('Number of convergenced runs');
grid on
subplot(224)
plot(Patameter(1:maxComp,6)*100,'ok','linewidth',2);
set(gca,'fontsize',14);
xlabel('(d) Number of extracted components');
set(gca,'fontsize',14);
ylabel('Explained variance (%)');
grid on
ylim([-10 110]);
%%
end
