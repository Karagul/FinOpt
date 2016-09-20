%Convert raw time series data table into return rate matrix, using 1 as basic.
function R = returnRate(P)
R = P(2:end,:)./P(1:end-1,:);
end