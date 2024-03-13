function [A,f,tt] = hhspectrum(imf,t,l,aff)

% [A,f,tt] = HHSPECTRUM(imf,t,l,aff) computes the Hilbert-Huang spectrum
%
% inputs:
% 	- imf : matrix with one IMF per row
%   - t   : time instants
%   - l   : estimation parameter for instfreq
%   - aff : if 1, displays the computation evolution
%
% outputs:
%   - A   : amplitudes of IMF rows
%   - f   : instantaneous frequencies
%   - tt  : truncated time instants
%
% calls:
%   - hilbert  : computes the analytic signal
%   - instfreq : computes the instantaneous frequency

if nargin < 2

  t=1:size(imf,2);

end

if nargin < 3

  l=1;

end

if nargin < 4

  aff = 0;

end

lt=length(t);

tt=t((l+1):(lt-l));

for i=1:(size(imf,1)-1)

  an(i,:)=hilbert(imf(i,:)')';
  f(i,:)=instfreq(an(i,:)',tt,l)';
  A=abs(an(:,l+1:end-l));

  if aff

    disp(['mode ',int2str(i),' trait']);

  end

end
