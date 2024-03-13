%对所有生成的网络求取指标值
clear
 clc
 tic
file_name='recur615\open\sub1\ss_*.xlsx';  %读取open状态下被试sub1的网络矩阵
files=dir('recur615\open\sub1\ss_*.xlsx');
loop_n=size(files,1);
Inte_CM=zeros(loop_n,2);   %5表示的计算的参数的个数
for jj=1:loop_n      %jj表示片段编号
display(jj) 
file_name=files(jj).name; 
Matrix=xlsread(file_name); 
Spar = 0.1:0.01:0.35;  %设置边密度为10%-35%,步长为1%
N_Spar = length(Spar);
roi=61;%通道数目
    EL_62 = zeros(1,N_Spar);% 加权局部效率
    GE_62= zeros(1,N_Spar);  % 加权全局效率
      for n = 1:N_Spar
       Mat_spar = threshold_proportional(Matrix,Spar(n)); %保留不同边密度下的网络矩阵      
        El_62(1,n) = sum(efficiency_wei(Mat_spar,1))/61; %计算每个边密度下的局部效率
        GE_62(1,n)=efficiency_wei(Mat_spar,0); %计算每个边密度下的全局效率
      end
  
    Inte_CM(jj,1) = trapz(Spar,El_62(1,:));  %计算边密度和局部效率的面积作为最终的局部效率

    Inte_CM(jj,2) = trapz(Spar,GE_62(1,:)); %计算边密度和全局效率的面积作为最终的全局效率
end
kk=('sub1_o_w.xlsx');  %结果保存在该文件夹
xlswrite(kk,Inte_CM);