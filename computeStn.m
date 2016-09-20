function [stn,er] = computeStn(R,xx,rf)
[T,~] = size(R);
if nargin < 3
    rf = 1;
end
mu = mean(R);
er = mu*xx;

omega = bsxfun(@minus,R,mean(R));
deviation = omega*xx;
downsideDeviation = deviation;
downsideDeviation(deviation>0) = 0;
stn = (er-rf)/sqrt(downsideDeviation'*downsideDeviation/T);
end
