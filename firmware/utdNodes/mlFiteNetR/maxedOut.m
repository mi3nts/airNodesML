function a = maxedOut(n,varargin)
% Max of something 

if nargin > 0
    n = convertStringsToChars(n);
end

if ischar(n)
  a = nnet7.transfer_fcn(mfilename,n,varargin{:});
  return
end

% Apply
a = max(0,n);
