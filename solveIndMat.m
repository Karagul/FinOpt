function [xx,val] = solveIndMat(R,iR,ss,er,num)
if nargin <5
    num = 5;
end
[T,n] = size(R);
mu = mean(R);
f = [zeros(1,2*n),ones(1,T)];
intcon = (n+1):(n+n);
A = [R,zeros(T,n),-eye(T);...
    -R,zeros(T,n),-eye(T);...
    eye(n),-100*eye(n),zeros(n,T);...
    -eye(n),-100*eye(n),zeros(n,T);...
    zeros(1,n),ones(1,n),zeros(1,T);...
    -mu,zeros(1,n),zeros(1,T)];
b = [iR;-iR;zeros(2*n,1);num;-er];
Aeq = [ones(1,n),zeros(1,n+T)];
beq = 1;
ub = [inf(n,1);ones(n,1);inf(T,1)];
if ss == 1
    lb = [-inf(n,1);zeros(n,1);-inf(T,1)];
elseif ss ==0
    lb = [zeros(n,1);zeros(n,1);-inf(T,1)];
else
    lb = [ss;zeros(n,1);-inf(T,1)];
end

opts = optimoptions('intlinprog','Display','off','TolFun',1e-10);
[xx,val] = intlinprog(f/T,intcon,A,b,Aeq,beq,lb,ub,opts);
xx = xx(1:n,:);
end

