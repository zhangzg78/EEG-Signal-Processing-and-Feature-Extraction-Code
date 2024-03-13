function [I,A] = MVG(adj,NN) 
 
    ll=size(adj);
    A = zeros( ll(2),  ll(2),  ll(1)); %初始化为全0矩阵
    for M=1:ll(1)
    A(:,:,M)= CLPVG(adj(M,:),NN); %每层构建网络，CLPVG为（有限）穿越可视图；LPHVG为水平（有限）穿越可视图
    end
%求出每一层网络的节点度
for i = 1 :  ll(1)
deg(i,:) = sum( A(:,:,i) );
end
I = zeros( ll(1), ll(1));
%对每两层的节点度进行遍历
for i = 1 :  ll(1)
for j = 1 :  ll(1)
if i == j
I(i,j) = 0;
else
alpha = deg(i,:);
beta = deg(j,:);
%对于某两种节点度组合
for k = 1 :  ll(2)
%计算组合出现次数
num_alpha_beta = 0;
for l = 1 :  ll(2)
if (alpha(l) == alpha(k)) && (beta(l) == beta(k))
num_alpha_beta = num_alpha_beta +1;
end
end
%计算组合概率
P_alpha_beta = num_alpha_beta /  ll(2);
%计算组合中单个度的概率
P_alpha = sum(alpha == alpha(k)) /  ll(2);
P_beta = sum(beta == beta(k)) /  ll(2);
%计算公式
I(i,j) = I(i,j) + ( P_alpha_beta * log(P_alpha_beta / (P_alpha*P_beta)) )/num_alpha_beta;%度分布互信息相关矩阵
end
end
end
end
end

