%------------------------  check: invariant under different factorization ---------------------
%------------------------  Results: PASS ------------------------------
% n=3;
% B=rand(n);
% C=B*B'+eye(n);
% C=C4;
load('counterex.mat');
n=length(C);
s=1;
maxit=1000;
% Factorization 1: Cholesky factorization
% [F1,r]=chol(C);
% if r~=0
%     error('Data matrix C is not positive definite');
% end
% F1=F1';
% % load('data90svd.mat');
% % F1=Fpy;
% % if sum(sum(abs(F1-F)))>1e-4
% %     error('Two svd decompostion are different!')
% % end
% [n,k]=size(F1);
% A=zeros(1,n);
% b=0;
% [x1,fval1,exitflag1,output1,lambda1,grad1,hess1] = running_knitro(F1,k,A,b,s,maxit,6);
% theta=x1(1:(k*(k+1)/2));
% Theta=zhong_svec2_reverse(theta,k);
% [U,D]=eig(Theta);
% if ~issorted(diag(D))
%     [D,I] = sort(diag(D));
%     U = U(:, I);
% else
%     D=diag(D);
% end
% fprintf('The s-th eigenvalue of Theta is: %s\n',D(s));
% fprintf('The (s+1)-th eigenvalue of Theta is: %s\n:%s\n',D(s+1));

% Factorization 2: matrix square root factorization
% F2=sqrtm(C);
% F2=(F2+F2')/2;
% [n,k]=size(F2);
% A=zeros(1,n);
% b=0;
% [x2,fval2,exitflag2,output2,lambda2,grad2,hess2] = running_knitro(F2,k,A,b,s,maxit,6);
% fprintf('DFact bound under Cholesky factorization is: %s\n',fval1);
% fprintf('DFact bound under matrix square root factorization is:%s\n',fval2);

%------------------------  check: complementing ---------------------
%------------------------  Results:  ------------------------------
maxitinv=5000;
Cinv=inv(C);
sinv=n-s;
[Finv,rinv]=chol(Cinv);
% if rinv~=0
%     error('Data matrix Cinv is not positive definite');
% end
Finv1=Finv';
[n,k]=size(Finv1);
A=zeros(1,n);
b=0;
[xinv1,fvalinv1,exitflaginv1,outputinv1,lambdainv1,gradinv1,hessinv1] = running_knitro(Finv1,k,A,b,sinv,maxitinv,6);
thetainv=xinv1(1:(k*(k+1)/2));
Thetainv=zhong_svec2_reverse(thetainv,k);

[U,D]=eig(Thetainv);
if ~issorted(diag(D))
    [D,I] = sort(diag(D));
    U = U(:, I);
else
    D=diag(D);
end
fprintf('The (n-s)-th eigenvalue of Thetainv is: %s\n',D(n-s));
fprintf('The (n-s+1)-th eigenvalue of Theta is: %s\n',D(n-s+1));

% fvalinv1=fvalinv1+log(det(C));
% fprintf('DFact bound is: %s\n',fval1);
% fprintf('Complementing DFact bound is:%s\n',fvalinv1);


