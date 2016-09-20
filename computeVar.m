%[var,er] = computeVar(R,xx)
%Author: Jerry Wong
%Problem: Compute the variance of a specific allocation.
%Input: R:= return rate matrix
%           example:
%               [AAPL   GE   MCD]
%           t1  1.04   0.98 1.02;
%           t2  1.02   0.99 1.01;
%           t3  1.01   1.02 0.99;
%       xx:= allocation **column** vector
%            example:
%           [0.33;0.33;0.34]
%Output: var:= the variance of the allocation
%        er:= the expected return of the allocation
function [var,er] = computeVar(R,xx)
var = sqrt(xx'*cov(R)*xx);
er = mean(R)*xx;
end