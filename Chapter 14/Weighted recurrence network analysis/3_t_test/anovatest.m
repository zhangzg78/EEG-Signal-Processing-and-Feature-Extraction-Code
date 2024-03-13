%对每个被试分别进行t检验，每个被试的结果保存于anova开头的文件中

wc=xlsread('sub1_c_w.xlsx');  %读取被试1闭眼状态下的两个指标值
wo=xlsread('sub1_o_w.xlsx');  %读取被试1睁眼状态下的两个指标值

n1=length(wc);
n2=length(wo);

t1=ones(n1,1);
t2=ones(n2,1)+ones(n2,1);
xx=zeros(1,1);

    for jj=1:2
    X=[wc(:,jj);wo(:,jj)];
    group=[t1;t2];
    xx(jj,1)=anova1(X,group);     %保存每个指标下求得的p值
    clear X
    end

xlswrite('anova_sub1_w.xlsx',xx);    %将两个指标值的p值保存于该文档
