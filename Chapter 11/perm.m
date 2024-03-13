function PE=perm(S,ord,t)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  version by Yang Bai 2018 06 21                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ly = length(S);
ks=ly-t*(ord-1);
m=ord;
Mm=[];
for i=1:m
    Mm=[Mm m^(m-i)];
end

for j=1:ks
    P=S(j:t:j+t*(ord-1))';
    [Ps,I]=sort(P);
    I=I-1;
    Ii(j)=Mm*I;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L=zeros(1,ks);
L(1)=1;

for j=2:ks
    In=0;
    for i=1:j-1
        if Ii(j)==Ii(i)
            L(i)=L(i)+1;
            In=1;
            break
        end
    end
    if In==0
        L(j)=L(j)+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%
    
L=L(find(L~=0));
p = L/sum(L);
PE = -sum(p .* log(p));

x_jie=factorial(ord);
PE=PE/log(x_jie);

