%------------------------  check: invariant under different factorization ---------------------
%------------------------  Results:   ------------------------------
n=2;
B=rand(n);
C=B*B'+eye(n);
%load('data63.mat');
n=length(C);
s=1;
maxit=10000;
% Factorization 1: Cholesky factorization
[F1,r]=chol(C);
if r~=0
    error('Data matrix C is not positive definite');
end
F1=F1';
[n,k]=size(F1);
A=zeros(1,n);
b=0;
[soln1,logsoln1] = running(F1,k,A,b,s,maxit);
x=logsoln1.x(end);
x=x{1,1};
theta=x(1:(k*(k+1)/2));
Theta=zhong_svec2_reverse(theta,k);
[U,D]=eig(Theta);
if ~issorted(diag(D))
    [D,I] = sort(diag(D));
    U = U(:, I);
else
    D=diag(D);
end
fprintf('The s-th eigenvalue of Theta is: %s\n',D(s));
fprintf('The (s+1)-th eigenvalue of Theta is: %s\n:%s\n',D(s+1));
%fprintf('The minimum eigenvalue of final Theta is: %s\n', min(eig(Theta)));


% Factorization 2: matrix square root factorization
% F2=sqrtm(C);
% F2=(F2+F2')/2;
% [n,k]=size(F2);
% A=zeros(1,n);
% b=0;
% [soln2,logsol2] = running(F2,k,A,b,s,maxit);
% fprintf('DFact bound under Cholesky factorization is: %s\n',logsol1.f(end));
% fprintf('DFact bound under matrix square root factorization is:
% %s\n',logsol2.f(end));


%------------------------  gradient check: Mitchell code ------------------------------
%------------------------  Results: PASS  ------------------------------
% load('data63.mat');
% [F,r]=chol(C);
% if r~=0
%     error('Data matrix C is not positive definite');
% end
% F=F';
% [n,k]=size(F);
% A=zeros(1,n);
% b=0;
% m=1;
% s=8;
% Theta=eye(k)+diag(rand(k,1));
% theta=zhong_svec2(Theta);
% v=zeros(n,1);
% nu=diag(F*Theta*F');
% pi=zeros(m,1);
% tau=0;
% x0 = [theta;v;nu;pi;tau];   
% obj_fn = @(x) obj(x(1:(k*(k+1)/2)),x((k*(k+1)/2+1):(k*(k+1)/2+n)),x((k*(k+1)/2+n+1):(k*(k+1)/2+2*n)),...
%     x((k*(k+1)/2+2*n+1):(k*(k+1)/2+2*n+m)),x(k*(k+1)/2+2*n+m+1),A,b,s,k);
% 
% ineq_fn= @(x) ineqconst(x(1:(k*(k+1)/2)),x((k*(k+1)/2+1):(k*(k+1)/2+n)),x((k*(k+1)/2+n+1):(k*(k+1)/2+2*n)),...
%         x((k*(k+1)/2+2*n+1):(k*(k+1)/2+2*n+m)),x(k*(k+1)/2+2*n+m+1),A,b,s,k);
%     
% eq_fn= @(x) eqconst(F,x(1:(k*(k+1)/2)),x((k*(k+1)/2+1):(k*(k+1)/2+n)),x((k*(k+1)/2+n+1):(k*(k+1)/2+2*n)),...
%         x((k*(k+1)/2+2*n+1):(k*(k+1)/2+2*n+m)),x(k*(k+1)/2+2*n+m+1),A,b,s,k);
%     
% fderrs = gradCheck(x0,eq_fn);
% plot(fderrs);


%------------------------  gradient check: CheckGradients (matlab opt toolbox) ---------------
%------------------------  Results: PASS  ------------------------------
% load('data63.mat');
% [F,r]=chol(C);
% if r~=0
%     error('Data matrix C is not positive definite');
% end
% F=F';
% [n,k]=size(F);
% A=zeros(1,n);
% b=0;
% m=1;
% s=8;
% Theta=eye(k)+diag(rand(k,1));
% theta=zhong_svec2(Theta);
% v=zeros(n,1);
% nu=diag(F*Theta*F');
% pi=zeros(m,1);
% tau=0;
% x0 = [theta;v;nu;pi;tau];   
% obj_fn = @(x) obj(x(1:(k*(k+1)/2)),x((k*(k+1)/2+1):(k*(k+1)/2+n)),x((k*(k+1)/2+n+1):(k*(k+1)/2+2*n)),...
%     x((k*(k+1)/2+2*n+1):(k*(k+1)/2+2*n+m)),x(k*(k+1)/2+2*n+m+1),A,b,s,k);
% 
% 
% 
% rng(0,'twister'); 
% options = optimoptions(@fmincon,'Algorithm','interior-point',...
%     'CheckGradients',true,'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true);
% 
% [x, fval, exitflag, output] = fmincon(obj_fn,...
%    x0,[],[],[],[],[],[],@constr,options);
% 
% 
% function [c,ce,gc,gce]=constr(x)
% load('data63.mat');
% [F,r]=chol(C);
% if r~=0
%     error('Data matrix C is not positive definite');
% end
% F=F';
% [n,k]=size(F);
% A=zeros(1,n);
% b=0;
% m=1;
% s=8;
% ineq_fn= @(x) ineqconst(x(1:(k*(k+1)/2)),x((k*(k+1)/2+1):(k*(k+1)/2+n)),x((k*(k+1)/2+n+1):(k*(k+1)/2+2*n)),...
%         x((k*(k+1)/2+2*n+1):(k*(k+1)/2+2*n+m)),x(k*(k+1)/2+2*n+m+1),A,b,s,k);
%     
% eq_fn= @(x) eqconst(F,x(1:(k*(k+1)/2)),x((k*(k+1)/2+1):(k*(k+1)/2+n)),x((k*(k+1)/2+n+1):(k*(k+1)/2+2*n)),...
%         x((k*(k+1)/2+2*n+1):(k*(k+1)/2+2*n+m)),x(k*(k+1)/2+2*n+m+1),A,b,s,k);
% 
% [c,gc]=ineq_fn(x);
% [ce,gce]=eq_fn(x);
% end
    






