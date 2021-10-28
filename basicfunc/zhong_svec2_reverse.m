function [M] = zhong_svec2_reverse(y,n)
% reverse operation of zhong_svec2
M=zeros(n);
for j=1:n
    ind1=n*(j-1)-j*(j-1)/2+j;
    ind2=n*j-(j-1)*j/2;
    M(j:n,j)=y(ind1:ind2);
end
M=M+M'-diag(diag(M));
end

