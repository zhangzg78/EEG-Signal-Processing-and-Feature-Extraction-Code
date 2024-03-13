%% A
clc;clear all; close all;
DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\csd\A\';
DirData = dir(fullfile(DataDir,'*.set'));  
filename = {DirData.name};

for iii = 1: length(filename)
    iii
    EEG = pop_loadset('filename',filename{1, iii},'filepath',DataDir);
    EEG = eeg_checkset( EEG );
    % STFT
    Fs = EEG.srate;
    xtimes = EEG.times/1000;
    t = EEG.times/1000;
    f = 1:30;
    winsize = 0.4;
    for nch = 1:EEG.nbchan
       [S, P, F, U] = sub_stft(squeeze(EEG.data(nch,:,:)), xtimes, t, f, Fs, winsize);    
       S_subject(:,:,:,nch) = S;
       clear P S F U
    end 
    %%%%% compute the PLV and PLI
    angle_subject = angle(S_subject);    
    for ii = 1:EEG.nbchan
        for jj = 1:EEG.nbchan
            if ii >= jj
                % PLV & PLI 
                temp1 = squeeze(angle_subject(:,:,:,ii));
                temp2 = squeeze(angle_subject(:,:,:,jj));
                relative_phase = temp1 - temp2;
                plv(:,:,ii,jj) = abs(sum(exp(1i*relative_phase),3)/size(relative_phase,3));
                pli(:,:,ii,jj) = abs(mean(sign((abs(relative_phase)- pi).*relative_phase),3));
                % WPLI               
                temp3 = squeeze(S_subject(:,:,:,ii));
                temp4 = squeeze(S_subject(:,:,:,jj));
                crossspec = temp3.* conj(temp4);
                crossspec_imag = imag(crossspec);
                wpli(:,:,ii,jj) = abs(mean(crossspec_imag,3))./mean(abs(crossspec_imag),3);
           end
        end
    end
    wpli(isnan(wpli)) = 0;
    clear angle_subject temp1 temp2 temp3 temp4 relative_phase S_subject crossspec crossspec_imag
    waitbar(iii/length(filename))
    %%%%%%%
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\PLV\A\',filename{1, iii}(1,1:end-4),'_plv.mat'),'plv');
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\PLI\A\',filename{1, iii}(1,1:end-4),'_pli.mat'),'pli');
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\WPLI\A\',filename{1, iii}(1,1:end-4),'_wpli.mat'),'wpli');
    clear plv pli wpli
end
%% L
clc;clear all; close all;
DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\csd\L\';
DirData = dir(fullfile(DataDir,'*.set'));  
filename = {DirData.name};

for iii = 1: length(filename)
    iii
    EEG = pop_loadset('filename',filename{1, iii},'filepath',DataDir);
    EEG = eeg_checkset( EEG );
    % STFT
    Fs = EEG.srate;
    xtimes = EEG.times/1000;
    t = EEG.times/1000;
    f = 1:30;
    winsize = 0.4;
    for nch = 1:EEG.nbchan
       [S, P, F, U] = sub_stft(squeeze(EEG.data(nch,:,:)), xtimes, t, f, Fs, winsize);    
       S_subject(:,:,:,nch) = S;
       clear P S F U
    end 
    %%%%% compute the PLV and PLI
    angle_subject = angle(S_subject);    
    for ii = 1:EEG.nbchan
        for jj = 1:EEG.nbchan
            if ii >= jj
                % PLV & PLI 
                temp1 = squeeze(angle_subject(:,:,:,ii));
                temp2 = squeeze(angle_subject(:,:,:,jj));
                relative_phase = temp1 - temp2;
                plv(:,:,ii,jj) = abs(sum(exp(1i*relative_phase),3)/size(relative_phase,3));
                pli(:,:,ii,jj) = abs(mean(sign((abs(relative_phase)- pi).*relative_phase),3));
                % WPLI               
                temp3 = squeeze(S_subject(:,:,:,ii));
                temp4 = squeeze(S_subject(:,:,:,jj));
                crossspec = temp3.* conj(temp4);
                crossspec_imag = imag(crossspec);
                wpli(:,:,ii,jj) = abs(mean(crossspec_imag,3))./mean(abs(crossspec_imag),3);
           end
        end
    end
    wpli(isnan(wpli)) = 0;
    clear angle_subject temp1 temp2 temp3 temp4 relative_phase S_subject crossspec crossspec_imag
    waitbar(iii/length(filename))
    %%%%%%%
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\PLV\L\',filename{1, iii}(1,1:end-4),'_plv.mat'),'plv');
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\PLI\L\',filename{1, iii}(1,1:end-4),'_pli.mat'),'pli');
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\WPLI\L\',filename{1, iii}(1,1:end-4),'_wpli.mat'),'wpli');
    clear plv pli wpli
end
%% S
clc;clear all; close all;
DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\csd\S\';
DirData = dir(fullfile(DataDir,'*.set'));  
filename = {DirData.name};

for iii = 1: length(filename)
    iii
    EEG = pop_loadset('filename',filename{1, iii},'filepath',DataDir);
    EEG = eeg_checkset( EEG );
    % STFT
    Fs = EEG.srate;
    xtimes = EEG.times/1000;
    t = EEG.times/1000;
    f = 1:30;
    winsize = 0.4;
    for nch = 1:EEG.nbchan
       [S, P, F, U] = sub_stft(squeeze(EEG.data(nch,:,:)), xtimes, t, f, Fs, winsize);    
       S_subject(:,:,:,nch) = S;
       clear P S F U
    end 
    %%%%% compute the PLV and PLI
    angle_subject = angle(S_subject);    
    for ii = 1:EEG.nbchan
        for jj = 1:EEG.nbchan
            if ii >= jj
                % PLV & PLI 
                temp1 = squeeze(angle_subject(:,:,:,ii));
                temp2 = squeeze(angle_subject(:,:,:,jj));
                relative_phase = temp1 - temp2;
                plv(:,:,ii,jj) = abs(sum(exp(1i*relative_phase),3)/size(relative_phase,3));
                pli(:,:,ii,jj) = abs(mean(sign((abs(relative_phase)- pi).*relative_phase),3));
                % WPLI               
                temp3 = squeeze(S_subject(:,:,:,ii));
                temp4 = squeeze(S_subject(:,:,:,jj));
                crossspec = temp3.* conj(temp4);
                crossspec_imag = imag(crossspec);
                wpli(:,:,ii,jj) = abs(mean(crossspec_imag,3))./mean(abs(crossspec_imag),3);
           end
        end
    end
    wpli(isnan(wpli)) = 0;
    clear angle_subject temp1 temp2 temp3 temp4 relative_phase S_subject crossspec crossspec_imag
    waitbar(iii/length(filename))
    %%%%%%%
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\PLV\S\',filename{1, iii}(1,1:end-4),'_plv.mat'),'plv');
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\PLI\S\',filename{1, iii}(1,1:end-4),'_pli.mat'),'pli');
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\WPLI\S\',filename{1, iii}(1,1:end-4),'_wpli.mat'),'wpli');
    clear plv pli wpli
end
%% V
clc;clear all; close all;
DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\csd\V\';
DirData = dir(fullfile(DataDir,'*.set'));  
filename = {DirData.name};

for iii = 1: length(filename)
    iii
    EEG = pop_loadset('filename',filename{1, iii},'filepath',DataDir);
    EEG = eeg_checkset( EEG );
    % STFT
    Fs = EEG.srate;
    xtimes = EEG.times/1000;
    t = EEG.times/1000;
    f = 1:30;
    winsize = 0.4;
    for nch = 1:EEG.nbchan
       [S, P, F, U] = sub_stft(squeeze(EEG.data(nch,:,:)), xtimes, t, f, Fs, winsize);    
       S_subject(:,:,:,nch) = S;
       clear P S F U
    end 
    %%%%% compute the PLV and PLI
    angle_subject = angle(S_subject);    
    for ii = 1:EEG.nbchan
        for jj = 1:EEG.nbchan
            if ii >= jj
                % PLV & PLI 
                temp1 = squeeze(angle_subject(:,:,:,ii));
                temp2 = squeeze(angle_subject(:,:,:,jj));
                relative_phase = temp1 - temp2;
                plv(:,:,ii,jj) = abs(sum(exp(1i*relative_phase),3)/size(relative_phase,3));
                pli(:,:,ii,jj) = abs(mean(sign((abs(relative_phase)- pi).*relative_phase),3));
                % WPLI               
                temp3 = squeeze(S_subject(:,:,:,ii));
                temp4 = squeeze(S_subject(:,:,:,jj));
                crossspec = temp3.* conj(temp4);
                crossspec_imag = imag(crossspec);
                wpli(:,:,ii,jj) = abs(mean(crossspec_imag,3))./mean(abs(crossspec_imag),3);
           end
        end
    end
    wpli(isnan(wpli)) = 0;
    clear angle_subject temp1 temp2 temp3 temp4 relative_phase S_subject crossspec crossspec_imag
    waitbar(iii/length(filename))
    %%%%%%%
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\PLV\V\',filename{1, iii}(1,1:end-4),'_plv.mat'),'plv');
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\PLI\V\',filename{1, iii}(1,1:end-4),'_pli.mat'),'pli');
    save(strcat('D:\FC\demo\eventEEG_analysis\ps_csd\WPLI\V\',filename{1, iii}(1,1:end-4),'_wpli.mat'),'wpli');
    clear plv pli wpli
end