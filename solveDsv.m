function [xx,val] = solveDsv (R,ss,er)
[T,n] = size(R);
mu = mean(R);
omega = bsxfun(@minus,R,mu);
H = blkdiag(zeros(n),eye(T));
A = [omega,-eye(T);-mu,zeros(1,T)];
b = [zeros(T,1);-er];
Aeq = [ones(1,n) zeros(1,T)];
beq = 1;
ub = inf(n+T,1);
f = zeros(n+T,1);
if ss == 0
    lb = zeros(n+T,1);
elseif ss == 1
    lb = [-inf(n,1); zeros(T,1)];
else
    lb = [ss; zeros(T,1)];
end
opts = optimoptions('quadprog','TolFun',1e-16,'Maxiter',4000);
[xx,val] = quadprog(H*2/T,f,A,b,Aeq,beq,lb,ub,opts);
xx = xx(1:n,:);
val = sqrt(val);
end