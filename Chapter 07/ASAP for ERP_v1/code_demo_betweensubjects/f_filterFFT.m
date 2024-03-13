function y=f_filterFFT(x,M,fs,freqLowCut,freqHighCut)

freqBin = fs/M;%% frequency represented by one frequency bin 

%% parameters for FFT-filter
binLowCut = ceil(freqLowCut/freqBin)+1;%% the frequency bin corresponds to the low frequency 
binHighCut = ceil(freqHighCut/freqBin)+1; %% the frequency bin corresponds to the high frequency
binLowCut2 = (M/2+1)+(M/2+1-binLowCut);%% the frequency bin corresponds to the low frequency 
binHighCut2 = (M/2+1)+(M/2+1-binHighCut); %% the frequency bin corresponds to the high frequency
%% FFT-filter 
%% M-point DFT
%%%%% signal is length - N
X = fft(x,M);
Z = zeros(size(X));
Z(binLowCut:binHighCut,:) = X(binLowCut:binHighCut,:);
Z(binHighCut2:binLowCut2,:) = X(binHighCut2:binLowCut2,:);
z = ifft(Z,M);
y = z(1:size(x,1),:);