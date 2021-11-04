function [obj,dx,info] = Linx_obj(x,s,C,gamma)
% This function calculate the objective value and gradient of linx for given data
%{
Input: 
x       - current point for linx bound
s       - the size of subset we want to choose, also equals to the summation of all elements of x
C       - data matrix
gamma   - scale factor

Output:
obj     - objective value of Linx at current point x
dx      - the gradient of obejctive function of Linx at x
info    - recording of important information
        dualgap - duality gap at current point x, which should be zero if x is an
                  optimal solution to DDFact
        dual_v  - corresponding dual solution
        dual_nu - corresponding dual solution
Output:
%}
n=length(C);
C=sqrt(gamma)*C;
F=C*diag(x)*C+eye(n)-diag(x);
F=1/2*(F+F');
obj=1/2*(log(det(F))-s*log(gamma));
Finv=inv(F);
dx=1/2*(diag(C*Finv*C-Finv));

% build dual solution
Theta=1/2*Finv;
temp=diag(C*Theta*C)-diag(Theta);
[sort_temp,ind]=sort(temp,'descend');
tau=sort_temp(s);
nu=zeros(n,1);
nu(ind(1:s))=sort_temp(1:s)-tau;
v=nu+tau-temp;
info.dual_v=v;
info.dual_nu=nu;
info.dualgap=trace(Theta)+sum(nu)+tau*s-n/2;
info.dualbound=obj+info.dualgap;
end

