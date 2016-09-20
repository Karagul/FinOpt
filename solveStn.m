function [xx,val] = solveStn(R,ss,er,rf,xx0)
global x0;
if nargin <5
    xx0 = x0;
    if nargin < 4
        rf = 1;
    end
end
[~,n] = size(R);
A=-mean(R);
b=-er;
Aeq = ones(1,n);
beq = 1;
ub = inf(n,1);
if ss == 0
    lb = zeros(n,1);
elseif ss == 1
    lb = -inf(n,1);
else
    lb = ss;
end
mstn = @(xx) -computeStn(R,xx,rf);
opts = optimoptions('fmincon','Display','off','TolX',1e-12);
[xx,val] = fmincon(mstn,xx0,A,b,Aeq,beq,lb,ub,[],opts);
val = -val;
end