function [tce,er]=computeTce(R,xx,p)

[T,~]=size(R);
Na=(T-1)*p+1;
Na=floor(Na);
A=R*xx;
A=sort(A,1);
A=A(1:Na,1);
tce=1/Na*(ones(1,Na)*A);
er = mean(R)*xx;
end