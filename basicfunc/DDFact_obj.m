function [obj,dx,y,dualgap] = DDFact_obj(x,s,F,Fsquare)
% This function calculate the objective value and gradient of DDFact for given data
%{
Input:
x       - current point for factorization bound
s       - the size of subset we want to choose, also equals to the summation of all elements of x
F       - C=FF' is a factorization of C where F is an n-by-d array
Fsquare - a 3d array where Fsquare(:,:,i) represents the F(i,:)'*F(i,:)

Output:
obj     - objective value of DDFact at current point x
dx      - the supgradient of obejctive function of DDFact at x
y       - linear oracle shown in Frank-Wolfe algorithm of Li-Xie's paper
dualgap - duality gap at current point x, which should be zero if x is an
          optimal solution to DDFact
%}
n=length(x);
d=length(Fsquare(:,:,1));
X=zeros(d);

for i=1:n
    if x(i)==0
    else
        X=X+x(i)*Fsquare(:,:,i);
    end
end
X=1/2*(X+X');
[U,D]=eig(X);
D=real(diag(D));
sort_D=sort(D, 'descend');

% calculate k and corresponding mid_value as shown in Nikolov's paper
[k,mid_val]=find_k(sort_D,s);
if k==-1 && mid_val<=0
    error('Something went wrong with calculating X or C might be a zero matrix.');
end
% construct the eigenvalue for the feasible solution to the dual problem, i.e., DFact
eigDual=zeros(d,1);
X_rank=rank(X);
for i=1:d
    if(D(i)>mid_val)
        eigDual(i)=1/D(i);
    else
        if mid_val>0
            eigDual(i)=1/mid_val;
        else
            eigDual(i)=1/sort_D(k);
        end
    end
end
% calculate supgradient dx
dX=U*diag(eigDual)*U';
dx=diag(F*dX*F');
  
% calculate linear oracle
y=zeros(n,1);
[sort_dx,ind]=sort(dx,'descend');
y(ind(1:s))=1;

% calculate objective value
sort_eigDual=sort(eigDual);
obj=-log(prod(sort_eigDual(1:s)));

% calculate dual gap
dualgap=sum(sort_dx(1:s))-s;
end

