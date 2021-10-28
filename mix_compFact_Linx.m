function [upperb,alpha,time] = mix_compFact_Linx(datafile,s)
% This code use bisection search to produce a mixing bound of Factorization bound and Linx bound.
%{
Input:
datafile- datafile containing C
s       - size of subset we want to choose

Output:
ub      - mixing bound output
alpha   - mixing parameter
time    - total elapsed time
%}
% generate data 
comp=0;
[C,~] = gen_data(datafile,comp);
comp=1;
[~,F,Fsquare,ldetC] = gen_data(datafile,comp);

n=length(C);

% Obtain scale factor for Linx bound alone, note that fact bound is
% invariant under scaling
gamma=Linx_gamma(C,s);

% create initial point
n=length(C);
x0=rand(n,1);
x0=x0*s/sum(x0);
y0=ones(n,1)-x0;
x0=[y0;
    x0];
alpha=0;

% create necessary parameters for knitro 
lb=zeros(2*n,1);
ub=ones(2*n,1);
Aeq=[ones(1,n),zeros(1,n);
    zeros(1,n),ones(1,n);
    eye(n),eye(n)];
beq=[n-s;
    s;
    ones(n,1)];
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
[xa,obja1,~,~] = Knitro_DDFact(x0(1:n),n-s,F,Fsquare);
obja1=obja1+ldetC;
[xb,objb2,~] = Knitro_Linx(x0((n+1):(2*n)),s,C,gamma);

obja1=-obja1;
objb2=-objb2;

% caculate derivative with repespect to alpha=0 or 1
[obja2,~] = Linx_obj_knitro(ones(n,1)-xa,s,C,gamma);
[objb1,~] = DDFact_obj_knitro(ones(n,1)-xb,n-s,F,Fsquare);
objb1=objb1-ldetC;

da=obja2-obja1;
db=objb2-objb1;
sprintf('da=%0.8f, db=%0.8f',da,db)
if da<=0
    upperb=obja1;
    alpha=0;
elseif db>=0
    upperb=objb2;
    alpha=1;
else
    while b-a > 1e-6
        alpha=(a+b)/2;
        obj_fn = @(x) mix_compFact_Linx_obj_knitro(x,s,F,Fsquare,C,gamma,alpha,ldetC);
        [xmid,upperb,~] = knitro_nlp(obj_fn,x0,A,b,Aeq,beq,lb,ub,[],[],options);
        sprintf('alpha=%0.8f, ub=%0.8f',alpha,-upperb)
        [objmid1,~] = DDFact_obj_knitro(xmid(1:n),n-s,F,Fsquare);
        objmid1=objmid1-ldetC;
        [objmid2,~] = Linx_obj_knitro(xmid((n+1):(2*n)),s,C,gamma);
        dmid=objmid2-objmid1;
        if dmid>=0
            a=alpha;
        else
            b=alpha;
        end
    end
end
upperb=-upperb;
time=toc;

end

