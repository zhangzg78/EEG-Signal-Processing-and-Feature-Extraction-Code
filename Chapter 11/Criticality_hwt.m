function [ alpha , beta , r , H , Power,spectrum] = Criticality_hwt( data,srate, start_frequency , step_frequency , stepnumber )
%CRITICALITY_HWT Summary of this function goes here
%   Detailed explanation goes here
% data=rand(1,1000);
% srate=100;
% scales=1/(1:0.5:45);

data=zscore(data);

w=zeros(stepnumber,length(data));
for i=1:stepnumber
    [x_hwt,W]=hwt(data,start_frequency+(i-1)*step_frequency,start_frequency+(i)*step_frequency,srate);
    w(i,:)=x_hwt;
    f(i)=start_frequency+(i-.5)*step_frequency;
end

S=sum(abs(w).^2,2)';
spectrum=abs(w).^2;
% LogS=log(S+0.000001);
LogS=log(S);
% Power=sum(S);
Power=S;

x0=[50,2];
x=lsqcurvefit(@PowerLaw,x0,f,S);
% x=lsqcurvefit(@PowerLawLog,x0,f,LogS);

alpha = x(1);
beta = x(2);
H = (beta - 1) /2;

newS=x(1)*f.^(-x(2));

% plot(f,log(S+0.000001));
% hold on
% plot(f,log(newS),'r')
% hold off;
% a=input('');

a=zscore(S);
b=zscore(newS);
r=sum(a.*b)/length(a);

end

