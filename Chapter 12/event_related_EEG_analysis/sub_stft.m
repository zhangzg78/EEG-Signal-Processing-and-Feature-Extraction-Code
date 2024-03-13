function [S, P, F, U] = sub_stft(x, xtimes, t, f, Fs, winsize, wintype, detrend_opt, padvalue, algm_opt)
% This sub-function is used to estimate time-varying complex spectrum using
% short-time Fourier transform (STFT)
% Note that it is only used for multi-channel EEG data.

% /Input/
% x: the original data samples (Time Points x Trials)
% xtimes: the time axis of the original data
% t: evaluated time points in STFT
% f: evaluated frequency bins in STFT
% Fs: sampling rate
% winsize: window size (NOTE: the unit is sec)
% wintype: window type (default: hanning window)
% detrend_opt: detrend or not ('1' for detrend is default, '0' for not)
% padvalue: the pad value used for padding data (default: '0'; See matlab function 'padarray')
% algm_opt: choose 'fft' algorithm (normal and default) or 'goertzel' algorithm (fast)

% /Output/
% S: complex time-frequency value
% U: a constant to normalize the power
% P: squared magnitude without phase
% F: phase information


fprintf('\nShort-time Fourier Transform: ')

%% Parameters
if nargin<7;  wintype = 'hann'; end;    % default window type is 'hann'
if nargin<8;  detrend_opt = 1; end      % detrend (1, default) the data or not (0)
if nargin<9;  padvalue = 0; end;        % default padding value is 0
if nargin<10; algm_opt = 'fft'; end;    % default option for algorithm is 'fft' (for varying window)

if size(x,1)==1; x = x.'; end; % transpose data if the 1st dimension (time) is 1
N_Trials = size(x,2); % number of trials
N_T = length(t);
N_F = length(f);
fprintf('%d Time Points x %d Frequency Bins x %d Trials\n',N_T,N_F,N_Trials);
S = single(zeros(N_F,N_T,N_Trials));
fprintf('Processing...     ')

if length(winsize)==1
    L = round(winsize*Fs/2); % half of window size (points)
    h = L*2+1; %  window size (points)
    win = window(wintype,h); % window (one trial)
    if ismember(0,win); win = window(wintype,h+2); win = win(find(win~=0)); end % remove zeros points in the window
    W = repmat(win,1,N_Trials); % window (all trials)
    U = win'*win;  % compensates for the power of the window

    % index of time points in time-frequency domain
    dt = t(2)-t(1); % time interval (uniform step)
    [junk,t_idx_min] = min(abs(xtimes-t(1)));
    [junk,t_idx_max] = min(abs(xtimes-t(end)));
    t_idx = t_idx_min:round(dt*Fs):t_idx_max;

    % index of time points in time-frequency domain
    df = f(2)-f(1); % frequency step (uniform step)
    nfft = round(Fs/df) * max(1,2^(nextpow2(h/round(Fs/df)))); % points of FFT
    f_full = Fs/2*linspace(0,1,round(nfft/2)+1);
    [junk,f_idx_min] = min(abs(f_full-f(1)));
    [junk,f_idx_max] = min(abs(f_full-f(end)));
    f_idx = f_idx_min:max(1,2^(nextpow2(h/round(Fs/df)))):f_idx_max;
    if numel(f_idx)>numel(f); f_idx = f_idx(1:end-1); end

    % Pad x (default mode is "zero")
    if detrend_opt; x = detrend(x); end; % Remove linear trends
    X = padarray(x, L, padvalue);        % padding data
    if detrend_opt; X = detrend(X); end; % Remove linear trends

    % STFT
    for n=1:N_T
        fprintf('\b\b\b\b%3.0f%%',n/N_T*100)
        X_n = X(t_idx(n)+[0:h-1],:);
        if detrend_opt; X_n = detrend(X_n); end; % Remove linear trends
        S_n = fft(X_n.*W,nfft,1);
        S(:,n,:) = S_n(f_idx,:) / sqrt(U);
    end
    S2 = S.*conj(S);
    P = S2/Fs;
    F = S./sqrt(S2);
    fprintf('  Done!\n')
    %% //////////////////////////////////////////////////// %%
else % winsize is a vector
    winsize(find(winsize*Fs<1)) = 10/Fs; % minimum points is 11
    winsize(find(winsize<10/Fs)) = 10/Fs; % minimum points is 11
    fprintf('\n')

    for fi=1:length(f)
        fprintf('Frequency Bins (%03g): %04.1f >>     ',length(f),f(fi))
        L = round(winsize(fi)*Fs/2); % half of window size (points)
        h = L*2+1; %  window size (points)
        win = window(wintype,h); % window (one trial)
        if ismember(0,win); win = window(wintype,h+2); win = win(find(win~=0)); end % remove zeros points in the window
        W = repmat(win,1,N_Trials); % window (all trials)
        U(fi,1) = win'*win;  % compensates for the power of the window

        % index of time points in time-frequency domain
        dt = t(2)-t(1); % time interval (uniform step)
        [junk,t_idx_min] = min(abs(xtimes-t(1)));
        [junk,t_idx_max] = min(abs(xtimes-t(end)));
        t_idx = t_idx_min:round(dt*Fs):t_idx_max;

        % index of time points in time-frequency domain
        df = f(2)-f(1); % frequency step (uniform step)
        nfft = round(Fs/df) * max(1,2^(nextpow2(h/round(Fs/df)))); % points of FFT
        f_full = Fs/2*linspace(0,1,round(nfft/2)+1);
        [junk,f_idx_min] = min(abs(f_full-f(1)));
        [junk,f_idx_max] = min(abs(f_full-f(end)));
        f_idx = f_idx_min:max(1,2^(nextpow2(h/round(Fs/df)))):f_idx_max;
        if numel(f_idx)>numel(f); f_idx = f_idx(1:end-1); end

        % Pad x (default mode is "zero")
        if detrend_opt; x = detrend(x); end; % Remove linear trends
        X = padarray(x, L, padvalue);        % padding data
        if detrend_opt; X = detrend(X); end; % Remove linear trends

        % STFT
        for n=1:N_T
            fprintf('\b\b\b\b%3.0f%%',n/N_T*100)
            X_n = X(t_idx(n)+[0:h-1],:);
            if detrend_opt; X_n = detrend(X_n); end; % Remove linear trends
            if strcmp(algm_opt,'fft') % fft
                S_n = fft(X_n.*W,nfft,1);
                S(fi,n,:) = S_n(f_idx(fi),:) / sqrt(U(fi));
            elseif strcmp(algm_opt,'dtft') % DTFT
                S(fi,n,:) = sub_dtft(X_n,f(fi),Fs) / sqrt(U(fi));
            elseif strcmp(algm_opt,'goertzel') % goertzel
            	k = round(f(fi)/Fs*h);
                S(fi,n,:) = goertzel(X_n,k+1) / sqrt(U(fi));
            end
        end % n
        fprintf('\n')
    end % fi
end
S2 = S.*conj(S);
P = S2/Fs;
F = S./sqrt(S2);
fprintf('Done!\n')
end

