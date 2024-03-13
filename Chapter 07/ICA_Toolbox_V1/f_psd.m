function f_psd(data,fs)
window = 5*fs ;
noverlap = 2*fs ;
nfft = 5*fs ;
[S,F,T,P] = spectrogram(data,window,noverlap,nfft,fs) ;
psd = 10*log10(mean(P,2)) ;
freqReso = fs/nfft ;
freqLow = freqReso ;
freqHigh = fs/2 ;
binLow = ceil(freqLow/freqReso) + 1 ;
binHigh = ceil(freqHigh/freqReso) + 1;
freqIndex = linspace(0,freqHigh,binHigh ) ;

% if strcmp(isShow,'off')
%     figure('visible','off')
% else
%     figure
% end
%         figure('visible','off')
%         figure
plot(freqIndex,psd,'color','r','linewidth',2.5)
xlim([freqLow 60])
set(gca,'fontsize',15)
xlabel('Frequency/Hz')
ylabel('Magnitude')
title('Power Spectral Density')
end

%%