function [ logS ] = PowerLawLog( x , f )
%POWERLAWLOG Summary of this function goes here
%   Detailed explanation goes here

% S(f)=alpha*f^(-beta)
% log(S(f))=log(alpha)-beta*log(f)
% S=x(1)*f.^(-x(2));   %%其中x(1)=alpha，x(2)=beta
logS=log(x(1))-x(2)*log(f);

%S=x(1)+x(2)*exp(-0.02*x(3)*f); %其中x(1)=a，x(2)=b，x(3)=k

end
