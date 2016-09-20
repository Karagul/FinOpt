function [Shp,er] = computeShp(R,xx,rf)
if nargin <3
    rf = 1;
end
er = mean(R)*xx;
Shp = (er-rf)/sqrt(xx'*cov(R)*xx);
end