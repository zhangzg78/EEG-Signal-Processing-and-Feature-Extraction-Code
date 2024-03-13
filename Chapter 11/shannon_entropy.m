
function Enn = shannon_entropy(d,b)

%     X=d;
%     Xmin = min(X);
%     Xmax = max(X);
%     
%     Xb = b*(X-Xmin)/(Xmax-Xmin);
% 
%     Bi = ceil(Xb);
% 
%     Bi(find(Bi<1))=1;
%     Bi(find(Bi>b))=b;
%     
%     N=length(Bi);
%     P=zeros(1,b);
%     for ii=1:N
%         P(Bi(ii))=P(Bi(ii))+1;
%     end   
%     P = P(find(P~=0));
%     pp=P./sum(P);
%     en=0;
%     en = -sum(pp .* log(pp));
%     Enn = en/log(b);


    X=round(d-min(d))+1;
    Xmax = max(X);
 
%     Xb = b*(X-Xmin)/(Xmax-Xmin);
% 
%     Bi = ceil(Xb);
% 
%     Bi(find(Bi<1))=1;
%     Bi(find(Bi>b))=b;
%     
    N=length(X);
    P=zeros(1,Xmax);
    for ii=1:N
        P(X(ii))=P(X(ii))+1;
    end   
    P = P(find(P~=0));
    pp=P./sum(P);
    en=0;
    en = -sum(pp .* log(pp));
    Enn = en/log(Xmax);
    
    
    