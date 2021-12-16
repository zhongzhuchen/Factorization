function [fixto0list,fixto1list] = varfix_DDFact(x,s,C,comp,F,Fsquare)
% This function evaluate the ability of DDFact upper bound to
% fix variables
%{
x       - optimal solution for the DDFact problem
s       - the size of subset we want to choose, also equals to the summation of all elements of x
C       - data matrix (for complementary problem, C is the data matrix of the original problem)
comp    - indicating if we are solving complementary DDFact or not, comp=1
          means yes and =0 means no
F       - C=FF' is a factorization of C where F is an n-by-d array
Fsquare - a 3d array where Fsquare(:,:,i) represents the F(i,:)'*F(i,:)

Output:
fixto0list - list of variables fixed to 0
fixto1list - list of variables fixed to 1
%}
fixto0list=[];
fixto1list=[];

n=length(x);
[obj,dx,info] = DDFact_obj(x,s,F,Fsquare);
f=zeros(2*n+1,1);
Aeq=[-eye(n),eye(n),ones(n,1)];
beq=dx;
lb=[zeros(2*n,1);-inf];
ub=Inf(2*n+1,1);
x0=[];

options = knitro_options('algorithm',3,...  % active-set/simplex algorithm
                         'outlev',0);       % iteration display

I=eye(n);
if comp==0
    LB=obtain_lb(C,n,s);
    if info.dualbound-LB>1e-6
        b=s+LB-obj-1e-10;
        for i=1:n
            A=[-I(i,:),ones(1,n),s];
            [xlp, ~, exitflag, ~] = knitro_lp (f, A, b, Aeq, beq, lb, ub, x0, [], options);
            if exitflag==0 && A*xlp-b<-1e-6
                fixto0list(end+1)=i;
            else
                A=[zeros(1,n),ones(1,n)-I(i,:),s];
                [xlp, ~, exitflag, ~] = knitro_lp (f, A, b, Aeq, beq, lb, ub, x0, [], options);
                if exitflag==0 && A*xlp-b<-1e-6
                    fixto1list(end+1)=i;
                end
            end 
        end
    end
else
    LB=obtain_lb(C,n,n-s);
    if info.dualbound-LB>1e-6
        b=s+LB-obj-log(det(C))-1e-10;
        for i=1:n
            A=[-I(i,:),ones(1,n),s];
            [xlp, ~, exitflag, ~] = knitro_lp (f, A, b, Aeq, beq, lb, ub, x0, [], options);
            if exitflag==0 && A*xlp-b<-1e-6
                fixto1list(end+1)=i;
            else
                A=[zeros(1,n),ones(1,n)-I(i,:),s];
                [xlp, ~, exitflag, ~] = knitro_lp (f, A, b, Aeq, beq, lb, ub, x0, [], options);
                if exitflag==0 && A*xlp-b<-1e-6
                    fixto0list(end+1)=i;
                end
            end 
        end
    end
end

end

