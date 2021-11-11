function [x,obj,info] = Knitro_DDFact(x0,s,F,Fsquare)
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
info     - a struct containing important information:
        x - optimal solution
        obj - optimal value
        dualgap - duality gap at x, which should be zero if x is an
                  optimal solution to DDFact
        time    - running wallclock time
        CPUtime - running CPU time
        num_nonsmooth - number of possible nonsmooth points encounterd
                       during the iteration 
        dual_v  - corresponding dual solution
        dual_nu - corresponding dual solution
%}

info=struct;
info.num_nonsmooth=0;
info.obj=0;
info.dualgap=0;
info.dualgap_everyitr=[];
info.num_nonsmooth_everyitr=[];
info.dualbound_everyiter=[];
info.normsubg_everyitr=[];
% make sure all variables except log have different names from the outer
% function to avoid overwrites
function [obj,dx] = DDFact_obj_knitro(x,s,F,Fsquare)
% create a callback function for Knitro specifying objective value and gradient 
[obj,dx,ininfo] = DDFact_obj(x,s,F,Fsquare);
info.num_nonsmooth=info.num_nonsmooth+ininfo.prob_nonsmooth;
info.num_nonsmooth_everyitr(end+1)=ininfo.prob_nonsmooth;
info.dualgap_everyitr(end+1)=ininfo.dualgap;
info.dualbound_everyiter(end+1)=obj+ininfo.dualgap;
info.normsubg_everyitr(end+1)=norm(dx);
obj=-obj;
dx=-dx;
end

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
tStart=cputime;
[x,~,exitflag,output,lambda,~] = knitro_nlp(obj_fn,x0,A,b,Aeq,beq,lb,ub,[],[],options);  
time=toc;
tEnd=cputime-tStart;
% record important information
info.x=x; % optimal solution
[obj,dx,finalinfo] = DDFact_obj(x,s,F,Fsquare);
info.obj=obj;
info.continuous_dualgap=finalinfo.dualgap;
info.dualbound=info.obj+info.continuous_dualgap;
info.dual_v=finalinfo.dual_v;
info.dual_nu=finalinfo.dual_nu;
info.ub_lambda=lambda.upper;
info.lb_lambda=lambda.lower;

if n==63 || n==90 || n==124
    info.integrality_gap=info.dualbound-obtain_lb(n,s);
    % number of fixing variables
    info.fixnum=0;
    intgap=info.integrality_gap;
    for i=1:n
        if intgap<info.dual_v(i)
            info.fixnum=info.fixnum+1;
        elseif intgap<info.dual_nu(i)
            info.fixnum=info.fixnum+1;
        end
    end
end

info.normsubg=norm(dx);
info.exitflag=exitflag;
info.time=time;
info.cputime=tEnd;
info.iterations=output.iterations;
info.funcCount=output.funcCount;
info.firstorderopt=output.firstorderopt;
info.constrviolation=output.constrviolation;
info.algorithm=output.algorithm;



end
