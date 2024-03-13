function wentropy = wavelet_entropy_func( x,Fs )
%WAVELET_ENTROPY Summary of this function goes here
%   Detailed explanation goes here
  
N_ceng=round(log2(Fs))-3; 
wentropy=0;
E=waveletdecom_cwq(x,N_ceng,'db4');
P=E/sum(E);
P = P(find(P~=0));
for j=1:size(P,2)
    wentropy=wentropy-P(1,j).*log(P(1,j));    %Ð¡²¨ìØSwt=-sum(Pj*logPj)
end

end