function [x,obj,dualgap, time] = Knitro_DDFact(x0,s,F,Fsquare)
% calling knitro to solve the DDFact problem
%{
Input:
x0      - the initial point
s       - size of subset we want to choose
F       - C=FF' is a factorization of C where F is an n-by-d array
Fsquare - a 3d array where Fsquare(:,:,i) represents the F(i,:)'*F(i,:)

Output:
x       - final point output by Knitro
obj     - objective value of DDFact at x
dualgap - duality gap at x, which should be zero if x is an
          optimal solution to DDFact
time    - running time
%}
n=length(x0);
% create callback function
obj_fn =  @(x) DDFact_obj_knitro(x,s,F,Fsquare);
lb=zeros(n,1);
ub=ones(n,1);
Aeq=ones(1,n);
beq=s;
A=[];
b=[];

if sum(abs(Aeq*x0-beq))>1e-10
    error('The initial point x0 is not feasible.')
end

options = knitro_options('algorithm', 3, 'convex', 1, 'derivcheck', 0, 'outlev', 0 , 'gradopt', 1, ...
                         'hessopt', 2, 'maxit', 1000, 'xtol', 1e-15, ...
                         'feastol', 1e-10, 'opttol', 1e-10, ...
                         'bar_maxcrossit', 10);
tic
[x,~] = knitro_nlp(obj_fn,x0,A,b,Aeq,beq,lb,ub,[],[],options);  
time=toc;
[obj,~,~,dualgap] = DDFact_obj(x,s,F,Fsquare); 
end

