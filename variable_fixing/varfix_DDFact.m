function [fixto0list,fixto1list] = varfix_DDFact(x,s,F,Fsquare)
% This function approximately evaluate the ability of DDFact upper bound to
% fix variables
%{
x       - optimal solution for the DDFact problem
s       - the size of subset we want to choose, also equals to the summation of all elements of x
F       - C=FF' is a factorization of C where F is an n-by-d array
Fsquare - a 3d array where Fsquare(:,:,i) represents the F(i,:)'*F(i,:)

Output:
fixto0list - list of variables fixed to 0
fixto1list - list of variables fixed to 1
%}
fixto0list=[];
fixto1list=[];

n=length(x);
[obj,dx,~] = DDFact_obj(x,s,F,Fsquare);
f=[zeros(n,1);ones(n,1);s];
Aeq=[-eye(n),eye(n),ones(n,1)];
beq=dx;
lb=[zeros(2*n,1);-inf];
ub=Inf(2*n+1,1);
x0=[];

options = knitro_options('algorithm',3,...  % active-set/simplex algorithm
                         'outlev',0);       % iteration display

I=eye(n);
if n==63 || n==90||n==124
    LB=obtain_lb(n,s);
else
    LB=heur(C,n,s);
end
b=s+LB-obj;

for i=1:n
    A=[-I(i,:),ones(1,n),s];
    [~, ~, exitflag, ~] = knitro_lp (f, A, b, Aeq, beq, lb, ub, x0, [], options);
    if exitflag>=-199
        fixto0list(end+1)=i;
    else
        A=[zeros(1,n),ones(1,n)-I(i,:),s];
        [~, ~, exitflag, ~] = knitro_lp (f, A, b, Aeq, beq, lb, ub, x0, [], options);
        if exitflag>=-199
            fixto1list(end+1)=i;
        end
    end 
end

end

