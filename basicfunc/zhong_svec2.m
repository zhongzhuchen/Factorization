function [y] = zhong_svec2(M)
%{
convert M to a column vector y (link the lower triangular columns of M by 
sequence which includes the diagonal elements); Note the the dimension of y is n(n+1)/2
%}
n=length(M);
y=zeros(n*(n+1)/2,1);
for j=1:n
    ind1=n*(j-1)-j*(j-1)/2+j;
    ind2=n*j-(j-1)*j/2;
    y(ind1:ind2)=M(j:n,j);
end
end

