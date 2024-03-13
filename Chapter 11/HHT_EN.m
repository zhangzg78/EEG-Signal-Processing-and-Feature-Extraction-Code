function [En, P, HHTP] = HHT_EN(X,f_bin,fs,df)

% compute Hilbert_Huang entropy
% signal decomposition via EMD and time-frequency analysis
% output:  En - entropy
%          P -  marginal spectrum
% input:   X - time series
%          f_bin - frequend band [f_low, f_high]
%          fs - sampling frequency
%          df - frequency resolution df = 0.5

if(nargin==1)
    f_bin = [0.05, 0.5];
    fs = 1;
    df = 0.001;
end
if(nargin==2)
    fs = 2 * f_bin(2);
    df = fs/1000;
end
if(nargin==3)
    df = fs/1000;
end

X = [X X X];

N=length(X);

[imf,ort,nbits] = emd(X);

k = size(imf);
rx=zeros(1,N);

%  imf = imf(1:end-1,:);

%%%% Hilbert spectrum
[A,f,tt] = hhspectrum(imf);

[im,t]=toimage(A,f,tt,fs/2/df);
% show Hilbert spectrum
% disp_hhs(im,t);

im = im(:,N/3:2*N/3-1);

HHTP = flipud(im);
% marginal spectrum
P=sum(flipud(im),2)/N;

Pf = P(fix(f_bin(1)/df)+1:fix(f_bin(2)/df));
En = en_log(Pf);

function en = en_log(P)

P=P/sum(P);
P = P(find(P~=0));
en = 0;
for i = 1:length(P)
    en = en - P(i)*log(P(i));
end

