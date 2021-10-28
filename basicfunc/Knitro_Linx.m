function [x,obj,info] = Knitro_Linx(x0,s,C,gamma)
% calling knitro to solve the DDFact problem
%{
Input:
x0      - the initial point
s       - size of subset we want to choose
C       - data matrix
gamma   - scale factor

Output:
x       - final point output by Knitro
obj     - objective value of linx at x
info     - a struct containing important information:
        x - optimal solution
        obj - optimal value
        time    - running wallclock time
        CPUtime - running CPU time
%}
n=length(x0);
function [obj,dx] = Linx_obj_knitro(x,s,C,gamma)
[obj,dx] = Linx_obj(x,s,C,gamma);
obj=-obj;
dx=-dx;
end
% create callback function
obj_fn =  @(x) Linx_obj_knitro(x,s,C,gamma);
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
tStart=cputime;
[x,obj,~] = knitro_nlp(obj_fn,x0,A,b,Aeq,beq,lb,ub,[],[],options);  
time=toc;
tEnd=cputime-tStart;
obj=-obj;
% record important information
info.time=time;
info.cputime=tEnd;
info.obj=obj;
info.x=x;
end

