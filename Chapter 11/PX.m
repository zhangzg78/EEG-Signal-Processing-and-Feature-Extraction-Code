function OPi = PX(S,ord,t)

ly = length(S);
permlist = perms(1:ord);                    %列出1到ord的所有可能的排序
c(1:length(permlist))=0;
    
OPi=zeros(1,ly-t*(ord-1));                  

 for j=1:ly-t*(ord-1)
     [a,iv]=sort(S(j:t:j+t*(ord-1)));       %对S中的ord个数升序排列返回iv是a中各个数据排列的标号
     for jj=1:length(permlist)
         if (abs(permlist(jj,:)-iv))==0     %比较排序模式得到数据的排序模式
             OPi(j)=jj;                     %OPi中是数据对应的排序模式
         end
     end
 end 