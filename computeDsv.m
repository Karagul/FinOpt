function [dsv,er] = computeDsv(R,xx)
[T,~] = size(R);
mu = mean(R);
er = mu*xx;
omega = bsxfun(@minus,R,mu);
k = omega*xx;
k(k<0) = 0;
dsv = sqrt(sum(k.^2)/T);
end