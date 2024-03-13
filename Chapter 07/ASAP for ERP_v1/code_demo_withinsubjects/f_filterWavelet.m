% % % % % % % wfl - a filter based on wavelet. 
% % % % % % %           1. Decomposition level = lv 
% % % % % % %           2. to keep coefficents in scale [kp]  
% % % % % % %           3. Reconstruction and output the result%
% % % % % % % Example: rc=wfl(d,7,'rbio6.8',[3 4])
% % % % % % % Notice that kp (keep-position) order is [A7 D7 D6 D5 D4 D3 D2 D1]  
% % % % % % % The [3 4] in example means to keep [ D6 D5 ]. Others will be set to zero. 
% % % % % % %  
% % % % % % % Nov.17, 2007

%%% This code was written by Dr. Yixiang Huang
%%% 560 Rhodes Hall, University of Cincinnati, Ohio 45221
%%% Tel: 513-556-3820
%%% E-mails: huangyx@uc.edu, jetload@126.com

%%% Using this code please cite the following article:
%%% Fengyu Cong, Yixiang Huang, Igor Kalyakin, Hong Li, Tiina Huttunen-Scott, Heikki Lyytinen, Tapani Ristaniemi, 
%%% Frequency Response based Wavelet Decomposition to Extract Children's Mismatch Negativity Elicited by Uninterrupted Sound, 
%%% Journal of Medical and Biological Engineering, DOI: 10.5405/jmbe.908 (2012, article in press).


function rc = f_filterWavelet(x,lv,wname,kp)
[c l]=wavedec(x,lv,wname);
k = length(kp);
c2=zeros(size(c));
a=0;
b=0;
for i=1:k  
    if kp(i) == 1
        a=1;
        b=l(1);
    else       
        a=0;
        b=0;
        for j=1:kp(i)
            a=b;
            b=b+l(j);            
        end        
    end 
    c2(a:b)=c(a:b);
end

rc=waverec(c2,l,wname);

return