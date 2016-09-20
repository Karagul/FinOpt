%This file process the raw time serie data.
% R is the return rate matrix, using 1 as basic.
% symbol is a column vector containing all the stock symbols.

%Read stock price from local files
[P,text] = xlsread('DJ_raw.xlsx');
symbol = text(1,2:end)';
R = returnRate(P);
R = R(106:end,:);
%Read index price from yahoo (computer needs to be online)
try
    iP = fetch(yahoo,'^DJI','Adj Close','12/30/12','12/31/15','w');
    disp('Data fetch successed');
    iR = returnRate(iP);
    iR = iR(:,2);
catch
    disp('Data fetch failed, use local data instead.');
    iR = xlsread('DJ_index.xlsx');
end
%If dimensions of stocks and that of Dow Jones Index are different, warn us
if size(R,1)~=size(iR,1)
    error('dimension!!!!!')
end
%Put all the comparable riskMeasure in a string array for future use
riskMeasure = {'mvo','mad','dsv','shp','stn','gap','tce'};%,'inm'};
%Default parameters
er = 1.010;
ers = [1,1.012];
pcts = [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1];
ss = 1;
rf = 1;
steps = 100;
%Seperate the data in to training set and testing set
[Rtrain,~,Rtest] = dividerand(R',0.8,0,0.2);
Rtrain = Rtrain';
Rtest = Rtest';
Rg = mvnrnd(mean(R),cov(R),5000);
%Storage the mvo optimizer as a initial point for non-convex model
global x0;
x0 = solveMvo(R,ss,er);