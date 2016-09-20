function comparePlot(Rtrain,Rtest,riskMeasure,ss,ers,steps,rf)
% ers = [1,1.06];steps = 100;
p = 0.05;
fignum = 0;
figure();
if nargin <7
    rf = 1;
    if nargin < 6
        steps = 30;
        if nargin <5
            ers = [1,1.020];
        end
    end
end
ers = [min(ers),min(mean(Rtrain)*(ss+1),max(ers))];
errange = min(ers):(range(ers)/steps):max(ers);
%Loop through all risk measure pair
for i = 1:length(riskMeasure)
    for j = 1:length(riskMeasure)
        r1 = riskMeasure{i}; r2 = riskMeasure{j};
        fignum = fignum + 1;
        x1=[];x2=[];
        y1=[];y2=[];
        itecount = 0;
        for er = errange
            % Compute the solution using risk measure 1
            switch r1
                case 'mvo'
                    [xx1,~]  = solveMvo(Rtrain,ss,er);
                case 'mad'
                    [xx1,~]  = solveMad(Rtrain,ss,er);
                case 'dsv'
                    [xx1,~]  = solveDsv(Rtrain,ss,er);
                case 'shp'
                    [xx1,~]  = solveShp(Rtrain,ss,er,rf);
                case 'stn'
                    [xx1,~]  = solveStn(Rtrain,ss,er,rf);
%                     [xx1,~]  = solvestr(Rtrain,ss,er);
                case 'tce'
                    [xx1,~] = solveTce(Rtrain,ss,er,p);
                otherwise
                    error('Invalid input for risk measure one.');
            end
            % compute the solution in risk measure 2. Then compare the
            % solution 1 and solution 2 in risk measure 2.
            switch r2
                case 'mvo'
                    [xx2,~]  = solveMvo(Rtrain,ss,er);
                    [val1,er1] = computeVar(Rtest,xx1);
                    [val2,er2] = computeVar(Rtest,xx2);
                case 'mad'
                    [xx2,~]  = solveMad(Rtrain,ss,er);
                    [val1,er1] = computeMad(Rtest,xx1);
                    [val2,er2] = computeMad(Rtest,xx2);
                case 'dsv'
                    [xx2,~]  = solveDsv(Rtrain,ss,er);
                    [val1,er1] = computeDsv(Rtest,xx1);
                    [val2,er2] = computeDsv(Rtest,xx2);
                % Sharpe ratio and Sortino Ratio have identical solution
                % through the loops, hence same expected return. 
                % Here manually change the y axis value to better plot it.
                case 'shp'
                    [xx2,~]  = solveShp(Rtrain,ss,er,rf);
                    [val1,er1] = computeShp(Rtest,xx1,rf);
                    [val2,er2] = computeShp(Rtest,xx2,rf);
                case 'stn'
                    [xx2,~]  = solveStn(Rtrain,ss,er,rf);
%                     [xx2,~]  = solvestr(Rtrain,ss,er);
                    [val1,er1] = computeStn(Rtest,xx1);
                    [val2,er2] = computeStn(Rtest,xx2);
                case 'tce'
                    [xx2,~]  = solveTce(Rtrain,ss,er,p);
                    [val1,er1] = computeTce(Rtest,xx1,p);
                    [val2,er2] = computeTce(Rtest,xx2,p);
                otherwise
                    error('Invalid input for risk measure two.');
            end
            itecount = itecount+1;
            x1 = cat(2,x1,val1);
            x2 = cat(2,x2,val2);
            
            % If the training set and the testing set are the same, that
            % means it is plotting traditional efficient frontier. Some
            % solutions have higher actual expected return than the
            % expected return in the formular.
            if isequal(Rtrain,Rtest)
                y1 = cat(2,y1,er);
                y2 = cat(2,y2,er);
            else
                y1 = cat(2,y1,er1);
                y2 = cat(2,y2,er2);
            end
        end
        
%Use subplot to demostrate different pairs. Adjust the color of the 
%background and lines.
subplot(length(riskMeasure),length(riskMeasure),fignum);hold on;whitebg([40,40,40]/255);

% If it is plotting a pair of same risk measure, plot only one line and 
% show only one legend.
if strcmp(r1,r2)
    plot(x1,y1,'-','Color',[131,103,220]/255);
    legend(r2,'Location','Northwest');
else
    plot(x1,y1,'-','Color',[235,125,34]/255);
    plot(x2,y2,'-','Color',[131,103,220]/255);
    plot(abs(x1-x2),y2,'-','Color',[255,255,255]/255);
    legend({r1,r2},'Location','Northwest')
end
legend BOXOFF



% If too many risk measures, omit the labels
if length(riskMeasure) <=3
    if strcmp(r2,'shp')
        xlabel('Sharpe Ratio');
    elseif strcmp(r2,'stn')
        xlabel('Sortino Ratio');
    else
        xlabel('Portfolio Risk');
    end
    ylabel('Expected Return')
else
    %shrink the font size on the axis
    set(gca,'FontSize',6);
end


hold off;
    end
end


end
