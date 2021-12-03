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
F=0.5*(F+F');

[R,flag]=chol(F); % F=R'*R cholesky decomposition

if flag>0
    warning("F(x) is not positive definite when calculating linx bound objective function.");
    obj=-Inf;
    dx=zeros(n,1);
    info.dual_v=nan*ones(n,1);
    info.dual_nu=nan*ones(n,1);
    info.dualgap=nan;
    info.dualbound=nan;
else
    obj=sum(log(diag(R)))-1/2*s*log(gamma); % calculate the objective function
    Rinv=inv(R);
    K=C*Rinv;
    % calculate the derivative: 1/2*diag(C*F^{-1}*C-F^{-1})
    dx2=sum(Rinv.*Rinv,2);
    dx=0.5*(sum(K.*K,2)-dx2);
    % [U,D]=eig(F);
    % obj=1/2*sum(log(diag(D)))-1/2*s*log(gamma); % calculate the objective function
    % 
    % 
    % K1=U.*(1./sqrt(diag(D)))';
    % K2=C*K1;
    % dx1=sum(K2.*K2,2);
    % dx2=sum(K1.*K1,2);
    % dx=1/2*(dx1-dx2);
    
    % build dual solution
    [sort_dx,ind]=sort(dx,'descend');
    tau=sort_dx(s);
    nu=zeros(n,1);
    nu(ind(1:s))=sort_dx(1:s)-tau;
    v=nu+tau-dx;
    info.dual_v=v;
    info.dual_nu=nu;
    info.dualgap=1/2*sum(dx2)+sum(nu)+tau*s-n/2;
    info.dualbound=obj+info.dualgap;
    % cache for mixing
    info.cache1=1/2*sum(dx2)-n/2;
end
end

