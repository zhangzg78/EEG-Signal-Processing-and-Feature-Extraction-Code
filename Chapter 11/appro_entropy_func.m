function  resultapen=appro_entropy_func(input_signal,input_m,input_r)
%求近似熵函数
%input_signal为要求近似熵的序列，input_m为给定的模式的维数，input_r为相似容限

resultapen = calfai(input_signal,input_m,input_r) - ...
                calfai(input_signal,input_m+1,input_r);

function fai=calfai(x,m,r) 

N            = length(x);%信号的点数
rownum       = N-m+1;%构造的m维矢量的行数
signalmatrix = zeros(rownum,m);%构造信号矩阵
for i=1:1:rownum
    signalmatrix(i,:)=x(i:i+m-1);
end

fai         = 0;
dmatrix     = zeros(rownum,rownum);
thetamatrix = zeros(rownum,rownum);
C           = zeros(1,rownum);
for ii=1:1:rownum
    sgmatrix_temp     = ones(rownum,1)* signalmatrix(ii,:);
    dmatrix(:,ii)     = max(abs(sgmatrix_temp-signalmatrix),[],2); %第ii行向量与其他所有行的距离最大值矩阵
    thetamatrix(:,ii) = (r>dmatrix(:,ii));
    C(1,ii)           = sum(thetamatrix(:,ii))/rownum;
    fai               = fai+log(C(1,ii))/rownum;
end


