function [c, grad] = ineqconst(theta,v,nu,pi,tau,A,b,s,k)
%{
We calculate the values and gradients of the inequality constraint functions of (DFact) with respect
to all variables.

Input:
    theta: a k(k+1)/2 length vector theta
           which is stacked into by a k-by-k matrix Theta
    v: n length vector
    nu: n length vector
    pi: m length vector
    tau: scalar
    A,b,s: parameters of the problemm. A is m-by-n, b is m-by-1, and s is a
    scalar
    k: number of columns of the factor matrix F

Output:
    c: a vector of length 2n+m storing values of inequality constraint
    functions
    grad: a matrix of size (k(k+1)/2+2n+m+1)-by-(2m+n) whose columns are gradients
    of each inequality constraint
%}

% calculate inequality constraint function values and gradients 
[m,n]=size(A);
c=[v;nu;pi];
I=eye(k*(k+1)/2+2*n+m+1);
grad=I(:,(k*(k+1)/2+1):(k*(k+1)/2+2*n+m));

% check the dimension
if length(c)~= (2*n+m)
    error('The length of the inequality constraint fucntion values is incorrect.');
end

[l1,l2]=size(grad);
if (l1~= (k*(k+1)/2+2*n+m+1))|| (l2~= (2*n+m))
    error('The size of the the equality constraint fucntion gradients is incorrect.');
end
c=-c;
grad=-grad;
end

