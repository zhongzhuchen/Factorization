function [c,grad] = eqconst(F,theta,v,nu,pi,tau,A,b,s,k)
%{
We calculate the values and the gradients of the equality constraits of (DFact) with respect
to all variables. Note that we have in total n equality constraints where n
is the number of variables in the original problem.

Input:
    F: the factor of the prescribed facrtorizaton of C, C=FF'
    theta: a k(k+1)/2 length vector theta
           which is stacked into by a k-by-k matrix Theta
    v: n length vector
    nu: n length vector
    pi: m length vector
    tau: scalar
    A,b,s: parameters of the problemm. A is m-by-n, b is m-by-1, and s is a
    scalar.
    k: number of columns of the factor matrix F

Output:
    c: a vector of length n storing the values of equality constraint
    functions.
    grad: a matrix of size (k(k+1)/2+2n+m+1)-by-n whose columns are gradients
    of each equality constraint.
%}

[n,~]=size(F);
[m,~]=size(A);
I=eye(n);
c=zeros(n,1);
grad=zeros((k*(k+1)/2+2*n+m+1),n);

% recover matrix Theta from vectorized theta
Theta=zhong_svec2_reverse(theta,k);

% calculate equality constraint function values and gradients
for i=1:n
    c(i)=F(i,:)*Theta*F(i,:)'+v(i)-nu(i)-A(:,i)'*pi-tau;
    G=F(i,:)'*F(i,:);
    gradcol=[2*zhong_svec2(G)-zhong_svec2(diag(diag(G)));
        I(:,i);
        -I(:,i);
        -A(:,i);
        -1];
    grad(:,i)=gradcol;
end

% check the dimension
if (length(c)~= n)
    error('The length of the equality constraint fucntion values is incorrect.');
end

[l1,l2]=size(grad);
if (l1~= (k*(k+1)/2+2*n+m+1))|| (l2~=n)
    error('The size of the the equality constraint fucntion gradients is incorrect.');
end
end

