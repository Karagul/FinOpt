%[xx,val] = solvemvo(R,ss,er)
%Author: Jerry Wong
%Problem: Compute the optimal mvo allocation.
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
%        val:= objective function value(variance in this case)
function [xx,val] = solveMvo(R,ss,er)
[~,n] = size(R);
H = cov(R);
A = -mean(R);
b = -er;
Aeq = ones(1,n);
beq = 1;

%====change lower bound according to short sales limits====
if ss == 0
    lb = zeros(n,1);
elseif ss == 1
    lb = -inf(n,1);
else
    lb = ss;
end
%===========================================================

ub = [];f=zeros(n,1);

opts = optimoptions('quadprog','TolFun',1e-16,'Maxiter',4000);
[xx,val] = quadprog(2*H,f,A,b,Aeq,beq,lb,ub,opts);
val = sqrt(val);
end