function [score,premium] = compare(r1,r2,R,Rt,ss,er,rf,p)
if nargin <8
    rf = 1;
    if nargin<7
        p = 0.05;
    end
end
p = p(1,1);
switch r1
    case 'mvo'
        [xx1,~]  = solveMvo(R,ss,er);
    case 'mad'
        [xx1,~]  = solveMad(R,ss,er);
    case 'dsv'
        [xx1,~]  = solveDsv(R,ss,er);
    case 'shp'
        [xx1,~]  = solveShp(R,ss,rf);
    case 'stn'
        [xx1,~]  = solveStn(R,ss,er,rf);
    case 'gap'
        [xx1,~] = solveGap(R,ss,er,p);
    case 'tce'
        [xx1,~] = solveTce(R,ss,er,p);
    otherwise
        error('Invalid input for risk measure one.');
end
switch r2
    case 'mvo'
        [xx2,~]  = solveMvo(R,ss,er);
        [val1,er1] = computeVar(Rt,xx1);
        [val2,er2] = computeVar(Rt,xx2);
    case 'mad'
        [xx2,~]  = solveMad(R,ss,er);
        [val1,er1] = computeMad(Rt,xx1);
        [val2,er2] = computeMad(Rt,xx2);
    case 'dsv'
        [xx2,~]  = solveDsv(R,ss,er);
        [val1,er1] = computeDsv(Rt,xx1);
        [val2,er2] = computeDsv(Rt,xx2);
    case 'shp'
        [xx2,~]  = solveShp(R,ss,er);
        [val1,er1] = computeShp(Rt,xx1);
        [val2,er2] = computeShp(Rt,xx2);
        [val2,val1] = deal(val1,val2);
    case 'stn'
        [xx2,~]  = solveStn(R,ss,er);
        [val1,er1] = computeStn(Rt,xx1);
        [val2,er2] = computeStn(Rt,xx2);
        [val2,val1] = deal(val1,val2);
    case 'gap'
        [xx2,~] = solveGap(R,ss,er,p);
        [val1,er1] = computePct(Rt,xx1,p);
        [val2,er2] = computePct(Rt,xx2,p);
        [val2,val1] = deal(val1,val2);
    case 'tce'
        [xx2,~] = solveTce(R,ss,er,p);
        [val1,er1] = computePct(Rt,xx1,p);
        [val2,er2] = computePct(Rt,xx2,p);
        [val2,val1] = deal(val1,val2);
    otherwise
        error('Invalid input for risk measure two.');
end
% ratio = val1/val2;
% score = 1/exp(ratio-1);
score = (val1-val2)/val2;
premium = er1-er2;
end