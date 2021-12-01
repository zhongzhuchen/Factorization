function [x,obj,info] = mix_Fact_Linx(C,s,gamma)
% This code use bisection search to produce a mixing bound of Factorization bound and Linx bound.
%{
Input:
C       - data matrix
s       - size of subset we want to choose
gamma   - optimal scale factor for linx bound

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
info=struct;
% generate data 
[F,Fsquare,~] = gen_data(C,0);
comp=0;

% create initial point
n=length(C);
% x0=rand(n,1);
% x0=x0*s/sum(x0);
x0=(s/n)*ones(n,1);
alpha=0;

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
TStart=tic;
tStart=cputime;
a=0;
b=1;
[xa,obja1,infoa_DDFact] = Knitro_DDFact(x0,s,C,comp,F,Fsquare);
[xb,objb2,infob_Linx] = Knitro_Linx(x0,s,C,gamma);

[~,dax1,infoa_DDFact] = DDFact_obj(xa,s,F,Fsquare);
[~,dbx2,infob_Linx] = Linx_obj(xb,s,C,gamma);

% caculate derivative with repespect to alpha=0 or 1
[obja2,dax2,infoa_Linx] = Linx_obj(xa,s,C,gamma);
[objb1,dbx1,infob_DDFact] = DDFact_obj(xb,s,F,Fsquare);

% calculate the derivative of the mixing function with respect to x when
% alpha=a, b
dax=dax1;
dbx=dbx2;

da=obja2-obja1;
db=objb2-objb1;
% sprintf('da=%0.8f, db=%0.8f',da,db)
if da>=0
    obj=obja1;
    x=xa;
    dx=dax;
    alpha=0;
    info_DDFact=infoa_DDFact;
    info_Linx=infoa_Linx;
elseif db<=0
    obj=objb2;
    x=xb;
    dx=dbx;
    alpha=1;
    info_DDFact=infob_DDFact;
    info_Linx=infob_Linx;
else
    while b-a > 1e-6
        % False position method (usually better than bisection method)
        xalpha0=(xa+xb)/2;% might be a more reasonable point for the starting point
        % alpha=(b*da-a*db)/(da-db); 
        alpha=(a+b)/2;
        % create callback function
        obj_fn = @(x) mix_Fact_Linx_obj_knitro(x,s,F,Fsquare,C,gamma,alpha);
        [xalpha,obj,~] = knitro_nlp(obj_fn,xalpha0,[],[],Aeq,beq,lb,ub,[],[],options);
        obj=-obj;
        % sprintf('alpha=%0.8f, ub=%0.8f',alpha,-upperb)
        [objalpha1,dalphax1,info_DDFact] = DDFact_obj(xalpha,s,F,Fsquare);
        [objalpha2,dalphax2,info_Linx] = Linx_obj(xalpha,s,C,gamma);
        dalpha=objalpha2-objalpha1;
        dalphax=(1-alpha)*dalphax1+alpha*dalphax2;
        if abs(dalpha)<1e-8
            break
        elseif dalpha<0
            a=alpha;
            xa=xalpha;
        else
            b=alpha;
            xb=xalpha;
        end
    end
    x=xalpha;
    dx=dalphax;
end
time=toc(TStart);
tEnd=cputime-tStart;
info.x=x;
info.dx=dx;
info.obj=obj;
info.alpha=alpha;
% calculate dual solutions
[sort_dx,ind]=sort(dx,'descend');
% calculate dual variables
tau=sort_dx(s);
nu=zeros(n,1);
nu(ind(1:s))=sort_dx(1:s)-tau;
v=nu+tau-dx;
info.dual_v=v;
info.dual_nu=nu;
% calculate dual gap
info.continuous_dualgap=(1-alpha)*info_DDFact.cache1+alpha*info_Linx.cache1+sum(sort_dx(1:s));
info.dualbound=obj+info.continuous_dualgap;
info.time=time;
info.cputime=tEnd;

info.fixcache=(1-alpha)*info_DDFact.cache1+alpha*info_Linx.cache1;
end

