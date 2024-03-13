%对data_615中每个被试的每咯状态的所有片段建立加权递归网络，将每个网络保存于ss开头的文件中

 clear
 clc
 tic
% name='sub1';
 file_name='data_615/sub1/o/sub1_o_*.xlsx';   %读取被试1睁眼状态下的数据
 
 
 files=dir('data_615/sub1/o/sub1_o_*.xlsx'); %打开所有带有该文件名的文件
 
loop_n=size(files,1);
for iii=1:loop_n   %遍历所有的文件
display(iii); 
file_name=files(iii).name;
dt1=xlsread(file_name);  %读取其中一个文件
dt=dt1';
[n,m]=size(dt);   %读取数据
ep=zeros(m);
SS=zeros(m,m);   %同步矩阵保存于SS
for i=1:m     
data1=dt(:,i); 
display(i)
RB(:,:,i)=crp(data1,3,4,0.1,'rr');   %求取每个子信号的递归图，控制递归率为0.1，嵌入维数为4，延迟时间为3
clear data1;
end
for i=1:m 
   for j=(i+1):m;
    RX=RB(:,:,i).*RB(:,:,j);  %求取同步递归
    tt=size(RX);
    RX=RX-uint8(eye(tt));  %使对角线值为0
    JRR=mean(RX(:));  %计算同步递归率
    SS(i,j)=JRR/0.1;  %计算同步指标
    SS(j,i)=SS(i,j);  
   end
end

xx=['ss_',file_name];%将同步矩阵保存出来到ss开头的xlsx文件中

xlswrite(xx,SS);


clear SS RB dt1 dt;
end
t=toc;
t=t/60;
disp(['计算耗时',num2str(t),'分']) 