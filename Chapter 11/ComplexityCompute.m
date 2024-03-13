function [lzc]=ComplexityCompute(x,m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             计算一维信号的复杂度
%             x:          the signal is vector
%             lzc:         the complexity of the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = 1;                                                                   %模式初始值
S = x(1);Q = [];SQ = [];                                      %S Q SQ初始化
for i=2:length(x)
    Q = strcat(Q,x(i));
    SQ = strcat(S,Q);
    SQv = SQ(1:length(SQ)-1);
    if isempty(findstr(SQv,Q))                           %如果Q不是SQv中的子串，说明Q是新出现的模式，执行c 加1操作      
        S = SQ;
        Q = [];
        c = c+1;    
    end
end
b = length(x)*log(m)/log(length(x));
lzc = c/b;
return;