function [f,grad] = obj(theta,v,nu,pi,tau,A,b,s,k)
%{
We calculate the values and gradients of the objective function of (DFact) with respect
to all variables.

Input:
    theta: a k(k+1)/2 length vector theta
           which is stacked into by a k-by-k matrix Theta
    v: n length vector
    nu: n length vector
    pi: m length vector
    tau: scalar
    A,b,s: parameters of the problem. A is m-by-n, b is m-by-1, and s is a
    scalar.
    k: number of columns of the factor matrix F

Output:
    grad: a vector of length k(k+1)/2+2n+m+1 with the form [d theta, d v, d nu,
    d pi, d tau, 1]'
%}

% calculate n: number of the varibles in the original problem and m: number
% of rows of A
n=length(v);
m=length(pi);

% recover matrix Theta from vectorized theta
Theta=zhong_svec2_reverse(theta,k);

% calculate objective value and the gradient
[U,D]=eig(Theta);
if ~issorted(diag(D))
    [D,I] = sort(diag(D));
    U = U(:, I);
else
    D=diag(D);
end

if D(1)<=0
    f=Inf;
    grad=zeros((k*(k+1)/2+2*n+m+1),1);
else
    f=-log(prod(D(1:s)))+sum(nu)+pi'*b+(tau-1)*s;

    U1=U(:,1:s);
    G=-U1*diag(1./(D(1:s)))*U1';
    grad=[2*zhong_svec2(G)-zhong_svec2(diag(diag(G)));
       zeros(n,1);
       ones(n,1);
       b;
       s];
end

% check the dimension
if (length(f)~= 1)
    error('The length of the objective value is incorrect.');
end
if length(grad)~= (k*(k+1)/2+2*n+m+1)
    error('The length of the gradient is incorrect.');
end
end

