function [riskBoard,returnBoard] = compareScore(R,riskMeasure,ss,er,porp,rf,p)
riskBoard = zeros(length(riskMeasure));
returnBoard = zeros(length(riskMeasure));
if nargin <7
    rf = 1;
end
testnum = 100;
tic;
for tn = 1:testnum
    if porp < 1
        [Rtrain,~,Rtest] = dividerand(R',porp,0,1-porp);
    else
        Rtrain = R';
        Rtest = R';
    end
    Rtrain = Rtrain';
    Rtest = Rtest';
    for i = 1:length(riskMeasure)
        for j = 1:length(riskMeasure)
        [a,b] = compare(riskMeasure{i},riskMeasure{j},Rtrain,Rtest,ss,er,rf,p);
        riskBoard(i,j) = riskBoard(i,j)+a/testnum;
        returnBoard(i,j) = returnBoard(i,j)+b/testnum;
        end
    end
end
toc
disp(riskBoard);
disp(returnBoard);
