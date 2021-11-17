function [x,obj,info] = mix_compFact_Fact(C,s,gamma)
% This code use bisection search to produce a mixing bound of 
% complementary Factorization bound and Linx bound.
%{
Input:
C       - data matrix
s       - size of subset we want to choose
gamma   - =1 just keep the same form as other mix functions
Output:
x       - optimal solution
obj     - mixing upper bound
info    - a struct containing important information:
        x
        obj
        alpha   - mixing parameter
        time    - total elapsed time
        cputime - total cputime
%}

% prepare data for calculating factorization and comp factorization bound
n=length(C);
[F,Fsquare,~] = gen_data(C,0);
sinv=n-s;
[invF,invFsquare,ldetC] = gen_data(C,1);

% create initial point
x0=s/n*ones(n,1);
alpha=0;

% create necessary parameters for knitro 
lb=zeros(n,1);
ub=ones(n,1);
Aeq=ones(1,n);
beq=s;

if sum(abs(Aeq*x0-beq))>1e-10
    error('The initial point x0 is not feasible.')
end

options = knitro_options('algorithm', 3, 'convex', 1, 'derivcheck', 0, 'outlev', 0 , 'gradopt', 1, ...
                         'hessopt', 2, 'maxit', 1000, 'xtol', 1e-15, ...
                         'feastol', 1e-10, 'opttol', 1e-10, ...
                         'bar_maxcrossit', 10);
% Initialize search interval where a is the lower bound and b is the upper
% bound
tic
tStart=cputime;
a=0;
b=1;
[xa,obja1,infoa_compDDFact] = Knitro_DDFact(ones(n,1)-x0,sinv,invF,invFsquare);
xa=ones(n,1)-xa;
obja1=obja1+ldetC;
[xb,objb2,infob_DDFact] = Knitro_DDFact(x0,s,F,Fsquare);

% caculate derivative with repespect to alpha=0 or 1
[obja2,~,infoa_DDFact] = DDFact_obj(xa,s,F,Fsquare);
[objb1,~,infob_compDDFact] = DDFact_obj(ones(n,1)-xb,sinv,invF,invFsquare);
objb1=objb1+ldetC;

da=obja1-obja2;
db=objb1-objb2;
if da<=0
    obj=obja1;
    x=xa;
    alpha=0;
    info_compDDFact=infoa_compDDFact;
    info_DDFact=infoa_DDFact;
elseif db>=0
    obj=objb2;
    x=xb;
    alpha=1;
    info_compDDFact=infob_compDDFact;
    info_DDFact=infob_DDFact;
else
    while b-a > 1e-6
        xalpha0=(xa+xb)/2;
        alpha=(a+b)/2;
        obj_fn = @(x) mix_compFact_Fact_obj_knitro(x,s,invF,invFsquare,F,Fsquare,alpha,ldetC);
        [xalpha,obj,~] = knitro_nlp(obj_fn,xalpha0,[],[],Aeq,beq,lb,ub,[],[],options);
        obj=-obj;
        % sprintf('alpha=%0.8f, ub=%0.8f',alpha,-upperb)
        [objalpha1,~,info_compDDFact] = DDFact_obj(ones(n,1)-xalpha,sinv,invF,invFsquare);
        objalpha1=objalpha1+ldetC;
        [objalpha2,~,info_DDFact] = DDFact_obj(xalpha,s,F,Fsquare);
        dalpha=objalpha1-objalpha2;
        if dalpha>=0
            a=alpha;
            xa=xalpha;
        else
            b=alpha;
            xb=xalpha;
        end
    end
    x=xalpha;
end
time=toc;
tEnd=cputime-tStart;
info.x=x;
info.obj=obj;
info.alpha=alpha;
info.dualbound=alpha*(info_compDDFact.dualbound+ldetC)+(1-alpha)*(info_DDFact.dualbound);
info.time=time;
info.cputime=tEnd;
end

