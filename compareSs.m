function compareSs(Rtrain,Rtest,riskMeasure,sss,ers,steps,rf)
[~,n] = size(Rtrain);
if nargin <7
    rf = 1;
    if nargin < 6
        steps = 15;
    end
end

ssl = min(sss):(range(sss)/steps):max(sss);
x = zeros(1,steps+1); y =zeros(1,steps+1);Z = zeros(steps+1); j = 0;

for ssc = ssl
    i = 0;
    j = j+1;
    x(j) = ssc;
    ss = ssc*ones(n,1);
    errange = min(ers):(range(ers)/steps):max(ers);
    for er = errange
        i = i +1;
        y(i) = er;
        switch riskMeasure
            case 'mvo'
                [xx1,~]  = solveMvo(Rtrain,ss,er);
                [val1,~] = computeVar(Rtest,xx1);
            case 'mad'
                [xx1,~]  = solveMad(Rtrain,ss,er);
                [val1,~] = computeMad(Rtest,xx1);
            case 'dsv'
                [xx1,~]  = solveDsv(Rtrain,ss,er);
                [val1,~] = computeDsv(Rtest,xx1);
            % Sharpe ratio and Sortino Ratio have identical solution
            % through the loops, hence same expected return. 
            % Here manually change the y axis value to better plot it.
            case 'shp'
                [xx1,~]  = solveShp(Rtrain,ss,er,rf);
                [val1,~] = computeShp(Rtest,xx1,rf);
            case 'stn'
                [xx1,~]  = solveStn(Rtrain,ss,rf);
                [val1,~] = computeStn(Rtest,xx1,er,er,rf);
            otherwise
                error('Invalid input for risk measure two.');
        end
        Z(i,j) = max(max(Z(:,j)),val1);
    end
end
figure();whitebg([40,40,40]/255);
subplot(1,2,1);
set(gca,'xdir','reverse')
surf(x,y,Z);%,'Color',[131,103,220]/255
xlabel('x-Short Sale Allowance');
ylabel('y-Expected Return');
zlabel('z-Portforlio Risk');
subplot(1,2,2);hold on;
for i = 1:steps
    disp([1 1 1]*i/steps)
    plot(Z(:,i),y,'Color',[1 1 1]*i/steps);
end
end