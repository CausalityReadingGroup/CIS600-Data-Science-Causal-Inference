function A = meanProd(mean, hyp, x, i)

% meanProd - compose a mean function as the product of other mean functions.
% This function doesn't actually compute very much on its own, it merely does
% some bookkeeping, and calls other mean functions to do the actual work.
%
% m(x) = \prod_i m_i(x)
%
% Copyright (c) by Carl Edward Rasmussen & Hannes Nickisch 2010-06-04.
%
% See also MEANFUNCTIONS.M.

for ii = 1:numel(mean)                             % iterate over mean functions
  f = mean(ii); if iscell(f{:}), f = f{:}; end  % expand cell array if necessary
  j(ii) = cellstr(feval(f{:}));                          % collect number hypers
end

if nargin<3                                        % report number of parameters
  A = char(j(1)); for ii=2:length(mean), A = [A, '+', char(j(ii))]; end; return
end

[n,D] = size(x);

v = [];                     % v vector indicates to which mean parameters belong
for ii = 1:length(mean), v = [v repmat(ii, 1, eval(char(j(ii))))]; end

A = ones(n,1);                                                  % allocate space
if nargin==3                                               % compute mean vector
  for ii = 1:length(mean)                     % iteration over summand functions
    f = mean(ii); if iscell(f{:}), f = f{:}; end   % expand cell array if needed
    A = A.*feval(f{:}, hyp(v==ii), x);                        % accumulate means
  end
else                                                 % compute derivative vector
  ii = v(i);                                               % which mean function
  j = sum(v(1:i)==ii);                            % which parameter in that mean
  for jj = 1:length(mean)
    f = mean(jj);
    if iscell(f{:}), f = f{:}; end         % dereference cell array if necessary
    if jj==ii
      A = A .* feval(f{:}, hyp(v==jj), x, j);              % multiply derivative
    else
      A = A .* feval(f{:}, hyp(v==jj), x);                       % multiply mean
    end
  end
end