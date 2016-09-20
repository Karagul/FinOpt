function [xx,val]=solveTce(R,ss,er,pcts,steps)
if nargin <  5
    steps = 9;
    if nargin <4
        pcts = 0.05;
    end
end
steplen = range(pcts)/steps;

if max(size(pcts)) == 1
    steplen = 1;
end

xx = []; val = [];
for p = min(pcts):steplen:max(pcts)
[T,n]=size(R);
Na=(T-1)*p+1;
Na=floor(Na);
A=[ones(T,1),eye(T),-R;zeros(1,T+1),-mean(R)];
b=[zeros(T,1);-er];
Aeq=[zeros(1,T+1),ones(1,n)];
beq=1;
f=[-1;-1/Na*ones(T,1);zeros(n,1)];
if ss==0
    lb=[-inf(T+1,1);zeros(n,1)];
elseif ss==1
    lb=-inf(n+T+1,1);
% else
%     lb=ss;
end
ub=[inf;zeros(T,1);inf(n,1)];
opts = optimoptions('linprog','Display','off','TolFun',1e-16,'Algorithm','dual-simplex');
[xxtmp,valtmp]=linprog(f,A,b,Aeq,beq,lb,ub,opts);
val=cat(2,val,-valtmp);
xx=cat(2,xx,xxtmp(T+2:end,1));
end
end
