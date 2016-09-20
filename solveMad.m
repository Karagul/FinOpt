%[xx,val] = solvemad(R,ss,er)
%Author: Jerry Wong
%Problem: Compute the optimal mad allocation.
%Input: R:= return rate matrix
%           example:
%               [AAPL   GE   MCD]
%           t1  1.04   0.98 1.02;
%           t2  1.02   0.99 1.01;
%           t3  1.01   1.02 0.99;
%
%       ss:= short sales allowed or not (boolean)
%       er:= expected return
%Output: xx:= optimal allocation as a column vector
%        val:= objective function value(mad in this case)
function [xx,val] = solveMad(R,ss,er)
[T,n] = size(R);
omega = bsxfun(@minus,R,mean(R));
A = [omega, -eye(T);-omega, -eye(T);-mean(R) zeros(1,T)];
b = [zeros(2*T,1);-er];
Aeq = [ones(1,n),zeros(1,T)];
beq = 1;
f = (1- Aeq)';
if ss == 0
    lb = zeros(n+T,1);
elseif ss == 1
    lb = -inf(n+T,1);
else
    lb = [ss;zeros(T,1)];
end
ub = [];
opts = optimoptions('linprog','Display','iter','TolFun',1e-10,'Algorithm','dual-simplex');
[xx,val] =linprog(f/T,A,b,Aeq,beq,lb,ub,opts);
xx = xx(1:n,:);
end