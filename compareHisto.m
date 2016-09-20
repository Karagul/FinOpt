function compareHisto(R,Rtest,riskMeasure,ss,er,rf)
if nargin < 6
    rf = 1;
    if nargin <5
        er = 1.005;
        if nargin <4
            ss = 1;
        end
    end
end
k = length(riskMeasure);
[~,n] = size(Rtest);
xlist = zeros(n,k);
figure();
for i = 1:k
    r = riskMeasure{i};
    switch r
        case 'mvo'
            [xx1,~]  = solveMvo(R,ss,er)
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
    xlist(:,i) = xx1;
    disp(size(Rtest*xlist(:,i)));
    subplot(1,k,i);histogram(Rtest*xlist(:,i),'Normalization','probability');
end

end