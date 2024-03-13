function PlotParameter(Patameter,maxComp,runs,filepath)
%%
mkdir([filepath filesep 'ICA_Parameters'])
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
    ['SD of numbers of used steps to converge among' int2str(runs) 'runs']);
grid on
subplot(223)
plot(Patameter(1:maxComp,1),'+m','linewidth',2);hold on
plot(Patameter(1:maxComp,2),'*r','linewidth',2);hold off
ylim([-0.1 1.1]);
set(gca,'fontsize',14);
xlabel('(c) Number of extracted components');
ylabel('Magnitude of Iq')
set(gca,'fontsize',14);
legend('Mean of Iqs of extracted components','SD of Iqs of extracted components');
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

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 8])
myFileName=[filepath filesep 'ICA_Parameters' filesep 'ICA_Parameters(Separated)'] ;
saveas(gcf,[myFileName],'png')
close 
%%
figure
set(gcf,'outerposition',get(0,'screensize'))
plot(Patameter(1:maxComp,4)/max(Patameter(:,4)),'or','linewidth',2);hold on
plot(Patameter(1:maxComp,3)/max(Patameter(:,3)),'xg','linewidth',2);hold on
plot(Patameter(1:maxComp,5)/max(Patameter(:,5)),'v','linewidth',3);hold on
plot(Patameter(1:maxComp,1),'+m','linewidth',2);hold on
plot(Patameter(1:maxComp,2),'*r','linewidth',2);hold on
plot(Patameter(1:maxComp,6),'ok','linewidth',2);hold off
ylim([-0.1 1.1]);
grid on
set(gca,'fontsize',14);
xlabel('Number of extracted components');
ylabel('Magnitude');
legend(['SD of numbers of used steps to converge among' int2str(runs) 'runs(Normalized)']...
    ,['Mean of numbers of used steps to converge among' int2str(runs) 'runs(Normalized)']...
    ,'Number of convergenced runs(Normalized)','Mean of Iqs of extracted components'...
    ,'SD of Iqs of extracted components','Explained variance');

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 8])
myFileName=[filepath filesep 'ICA_Parameters' filesep  'ICA_Parameters(Together)'] ;
saveas(gcf,[myFileName],'png')
close 
%%
end