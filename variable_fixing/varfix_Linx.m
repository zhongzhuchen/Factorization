function [fixto0list,fixto1list]= varfix_Linx(x,s,C,gamma)
% This function evaluate the ability of DDFact upper bound to
% fix variables
%{
x       - optimal solution for the DDFact problem
s       - the size of subset we want to choose, also equals to the summation of all elements of x
C       - data matrix (for complementary problem, C is the data matrix of the original problem)
gamma   - scale factor

Output:
fixto0list - list of variables fixed to 0
fixto1list - list of variables fixed to 1
%}
fixto0list=[];
fixto1list=[];

n=length(x);
[obj,dx,info] = Linx_obj(x,s,C,gamma);
f=zeros(2*n+1,1);
Aeq=[-eye(n),eye(n),ones(n,1)];
beq=dx;
lb=[zeros(2*n,1);-inf];
ub=Inf(2*n+1,1);
x0=[];

options = knitro_options('algorithm',3,...  % active-set/simplex algorithm
                         'outlev',0);       % iteration display

I=eye(n);
LB=obtain_lb(C,n,s);
b=-info.cache1+LB-obj-1e-10;
for i=1:n
    A=[-I(i,:),ones(1,n),s];
    [xlp, ~, exitflag, ~] = knitro_lp (f, A, b, Aeq, beq, lb, ub, x0, [], options);
    if exitflag>=-199
%         exitflag
%         A*xlp-b
        fixto0list(end+1)=i;
    else
        A=[zeros(1,n),ones(1,n)-I(i,:),s];
        [xlp, ~, exitflag, ~] = knitro_lp (f, A, b, Aeq, beq, lb, ub, x0, [], options);
        if exitflag>=-199
            fixto1list(end+1)=i;
        end
    end 
end
end

