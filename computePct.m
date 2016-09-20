function [pr,er,optx] = computePct(R,xx,p)
mu = mean(R);
pr = prctile(R*xx,p*100);
er = mu*xx;
optx = xx(:,(pr>=max(pr)));
end