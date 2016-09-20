function [xx, val] = solveGap(R,ss,er,p)
global x0;
[~,n] = size(R);
phi = norminv(p);
mu = mean(R);
gap = @(xx) -(mu*xx+phi*sqrt(xx'*cov(R)*xx));
xx0 = x0;
A=-mean(R); b=-er;
Aeq = ones(1,n); beq = 1;
ub = inf(n,1);
if ss == 0
    lb = zeros(n,1);
elseif ss == 1
    lb = -inf(n,1);
else
    lb = ss;
end
opts = optimoptions('fmincon','Display','off','TolX',1e-12);
[xx,val] = fmincon(gap,xx0,A,b,Aeq,beq,lb,ub,[],opts);
val = -val;
end
