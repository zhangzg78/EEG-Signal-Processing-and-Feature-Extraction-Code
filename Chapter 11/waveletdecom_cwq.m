function [ E ] = waveletdecom_cwq( x,n,wpname )
[C,L]=wavedec(x,n,wpname);        %对数据进行小波包分解
for k=1:n
      %wpcoef(wpt1,[n,i-1])是求第n层第i个节点的系数
%       disp('每个节点的能量E(i)');
      SRC(k,:)=wrcoef('a',C,L,'db4',k);%尺度
      SRD(k,:)=wrcoef('d',C,L,'db4',k);%细节系数

  E(1,k)=norm(SRD(k,:))*norm(SRD(k,:));
      %求第i个节点的范数平方，其实也就是平方和
end
E(1,n+1)=norm(SRC(n,:))*norm(SRC(n,:));
%  disp('小波包分解总能量E_total');
E_total=sum(E);  %求总能量
y=E_total;
% disp('以下是每个节点的概率P');
% for i=1:n+1
%    p(i)= E(1,i)/E_total    %求每个节点的概率
% end


end

