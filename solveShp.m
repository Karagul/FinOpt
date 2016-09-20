function [xx,val] = solveShp(R,ss,er,rf)
if nargin <4
    rf = 1;
end
[~,n] = size(R);
Q = blkdiag(cov(R),0);
f = zeros(n+1,1);
mu = mean(R);
if ss == 0
    sl = zeros(n,1);
    b = zeros(n+1,1);
elseif ss ==1;
    sl = zeros(n,1);
    b = [inf(n,1);0];
else
    sl = ss;
    b = zeros(n+1,1);
end
A = -[eye(n),-sl;...
        mu, -er];

Aeq = [ones(1,n), -1;...
        mu, -rf];
beq = [0;1];
ub = inf(n+1,1);
lb = [-inf(n,1);0];
opts = optimoptions('quadprog','Display','off','TolX',1e-12);
[sol,~] = quadprog(2*Q,f,A,b,Aeq,beq,lb,ub,opts);
y = sol(1:n,1);
z = sol(n+1,1);
xx = y./z;
val = (mu*xx-rf)/sqrt(xx'*Q(1:n,1:n)*xx);
end

