

NN=1;   %定义有限穿越视距                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
xx0=['E:\MATLAB\opencloseeyes\data_615\sub8\c']; %读取闭眼脑电数据
files=dir(xx0);
loop_n=size(files,1);
for i=1:loop_n
     disp(i)
    file_name=files(i).name;
    dt1=xlsread(file_name);
    [I] = MVG(dt1,NN); %构建闭眼有限穿越可视图脑网络
    sub8c(i,1)=TR(I); %计算闭眼网络指标传递性
 end

xx0=['E:\MATLAB\opencloseeyes\data_615\sub8\o'];%读取睁眼脑电数据
files=dir(xx0);
loop_n=size(files,1);
for i=1:loop_n
     disp(i)
    file_name=files(i).name;
    dt1=xlsread(file_name);
    [I] = MVG(dt1,NN);  %构建睁眼有限穿越可视图脑网络
    sub8o(i,1)=MDDD(I); %计算睁眼网络指标传递性
end

[h,p] = ttest(sub8c,sub8o); %计算睁闭眼网络指标pvalue值
