function [upperb,x,alpha,time] = mix_Fact_Linx(C,s,gamma)
% This code use bisection search to produce a mixing bound of Factorization bound and Linx bound.
%{
Input:
C       - data matrix
s       - size of subset we want to choose
gamma   - optimal scale factor for linx bound

Output:
ub      - mixing bound output
x       - optimal solution
alpha   - mixing parameter
time    - total elapsed time
%}

% generate data 
comp=0;
[F,Fsquare,~] = gen_data(C,comp);

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
A=[];
b=[];

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
a=0;
b=1;
[xa,obja1,~,~] = Knitro_DDFact(x0,s,F,Fsquare);
[xb,objb2,~] = Knitro_Linx(x0,s,C,gamma);

obja1=-obja1;
objb2=-objb2;

% caculate derivative with repespect to alpha=0 or 1
[obja2,~] = Linx_obj_knitro(xa,s,C,gamma);
[objb1,~] = DDFact_obj_knitro(xb,s,F,Fsquare);

da=obja2-obja1;
db=objb2-objb1;
% sprintf('da=%0.8f, db=%0.8f',da,db)
if da<=0
    upperb=obja1;
    x=xa;
    alpha=0;
elseif db>=0
    upperb=objb2;
    x=xb;
    alpha=1;
else
    while b-a > 1e-6
        alpha=(a+b)/2;
        % create callback function
        obj_fn = @(x) mix_Fact_Linx_obj_knitro(x,s,F,Fsquare,C,gamma,alpha);
        [xmid,upperb,~] = knitro_nlp(obj_fn,x0,A,b,Aeq,beq,lb,ub,[],[],options);
        % sprintf('alpha=%0.8f, ub=%0.8f',alpha,-upperb)
        [objmid1,~] = DDFact_obj_knitro(xmid,s,F,Fsquare);
        [objmid2,~] = Linx_obj_knitro(xmid,s,C,gamma);
        dmid=objmid2-objmid1;
        if dmid>=0
            a=alpha;
        else
            b=alpha;
        end
    end
    x=xmid;
end
upperb=-upperb;
time=toc;
end

