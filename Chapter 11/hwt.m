% harmonic wavelet of rectangular shape in frequency domain
function [x_hwt,W]=hwt(x,f1,f2,fs,N)
% extract desired frequency band component of signal
% x is the signal to be decomposed,size of N*1
% fs is the sampling frequency
% f1,f2: low- and high-est frequency
% x_hwt contains the wavelet coefficients,every line correspond to a
% subband
% N:number of FFT points, if absent,will be defined in code.

% prepare the signal
xsize=size(x);
if xsize(2)==1
    x=x';
end
L=length(x);

df=fs/L;
if nargin<5
    
    bf=f2-f1;% bandwidth
    if bf<1
        df=min(bf/10,df);    
    end
    N=ceil(fs/df);% Nfft     
end

X=fft(x,N); % N points FFT of the signal
df1=floor(f1/df)+1; % convert the analogue frequency to digital form
df2=floor(f2/df)+1;
W=zeros(1,N);
XW=zeros(1,N);

for i=df1:df2 
    W(i)=1;% wavelet function in frequency domain, only the desired band nonzero    
end
XW=X.*conj(W);% multiplication in frequency domain
x_hwt=ifft(XW,L);

% % plot wavelet
% figure,subplot(211),plot([0:df:fs/2-df],W([1:floor(fs/2/df)])),
% xlabel('frequency(Hz)'),title('Harmonic wavelet');
% t=[-4+1/fs:1/fs:4];
% Lt=length(t);
% w=ifft(W,Lt);% time signal
% w2=[conj(w(4*fs:-1:1)),w(1:4*fs)];
% subplot(212),plot(t,real(w2),'r'),hold on,plot(t,imag(w2)),
% xlabel('time(s)');
