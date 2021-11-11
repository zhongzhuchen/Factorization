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
        dual_v  - corresponding dual solution with x>=0
        dual_nu - corresponding dual solution with x<=1
Output:
%}
n=length(C);
C=sqrt(gamma)*C;
F=C*diag(x)*C+eye(n)-diag(x);
F=1/2*(F+F');

% [R,flag]=chol(F); % F=R'*R
% if flag>0
%     error("F(x) is not positive definite when calculating linx bound objective function.");
% end
% 
% obj=log(prod(diag(R)))-1/2*s*log(gamma); % calculate the objective function
% 
% % calculate the inverse of F, we have R'*R*Finv=I. First we calculate R'*J=I. 
% % Then we solve R*Finv=J.
% J=fixed.forwardSubstitute(R,eye(n));
% Finv=fixed.backwardSubstitute(R,J);

[U,D]=eig(F);
obj=1/2*log(prod(diag(D)))-1/2*s*log(gamma); % calculate the objective function
Finv=U*diag(1./diag(D))*U'; % calculate the inverse of F

% calculate the derivative
dx=1/2*(diag(C*Finv*C)-diag(Finv));
% build dual solution
[sort_dx,ind]=sort(dx,'descend');
tau=sort_dx(s);
nu=zeros(n,1);
nu(ind(1:s))=sort_dx(1:s)-tau;
v=nu+tau-dx;
info.dual_v=v;
info.dual_nu=nu;
info.dualgap=1/2*trace(Finv)+sum(nu)+tau*s-n/2;
info.dualbound=obj+info.dualgap;
end

