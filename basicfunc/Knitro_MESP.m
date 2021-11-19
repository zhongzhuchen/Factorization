function [x,obj,info] = Knitro_MESP(s,C,cvx_tech)
% solve MESP problem with knitro and different convex-relaxation tricks
%{
Input:
C       - data matrix
s       - size of subset to choose
cvx     - which convex-relaxation technique to use
          =1: factorization bound
          =2: comp factorization bound
          =3: linx bound

Output:
x       - optimal solution
obj     - optimal value 
info    - a struct containing important information:
              x - optimal solution
            obj - optimal value
%}
n=length(C);
[xind,~]=heur(C,n,s);
x0=zeros(n,1);
x0(xind)=1;
if cvx_tech==2
    [xind,~]=heur(C,n,n-s);
    x0=zeros(n,1);
    x0(xind)=1;
end
% define nested function for DDFact
function [obj,dx] = DDFact(x,s,F,Fsquare,comp,ldetC)
% create a callback function for Knitro specifying objective value and gradient
[obj,dx,~] = DDFact_obj(x,s,F,Fsquare);
if comp==0 % original fact bound    
else % comp fact bound
    obj=obj+ldetC;
end
obj=-obj;
dx=-dx;
end

% define nested function for linx
function [obj,dx] = Linx(x,s,C,gamma)
[obj,dx,~] = Linx_obj(x,s,C,gamma);
obj=-obj;
dx=-dx;
end

if cvx_tech==1
    [F,Fsquare,~] = gen_data(C,0);
    obj_fn =  @(x) DDFact(x,s,F,Fsquare,0,0);
elseif cvx_tech==2
    [F,Fsquare,ldetC] = gen_data(C,1);
    obj_fn =  @(x) DDFact(x,n-s,F,Fsquare,1,ldetC);
else
    [gamma]=Linx_gamma(C,s);
    obj_fn =  @(x) Linx(x,s,C,gamma);
end

lb=zeros(n,1);
ub=ones(n,1);
Aeq=ones(1,n);
beq=s;
if cvx_tech==2
    beq=n-s;
end
% Aeq=[];
% beq=[];

A=[];
b=[];
% A=[ones(1,n);
%     -ones(1,n)];
% b=[s+1e-4;
%     1e-4-s];


xType=2*ones(n,1);

% if sum(abs(Aeq*x0-beq))>1e-10 || sum(floor(x0)==ceil(x0))~=n
%     error('The initial point x0 is not feasible.')
% end

%                          'mip_heuristic_strategy', -1, 'mip_heuristic_feaspump',0,...
%                           
options = knitro_options('algorithm', 3, 'derivcheck', 0, 'mip_outlevel', 1 , 'gradopt', 1, ...
                         'hessopt', 2, 'maxit', 1000, 'mip_method', 1, 'mip_nodealg', 3,...
                         'convex', 1, 'mip_rounding', 0,...
                         'mip_integral_gap_rel', 1e-12,'mip_integral_gap_abs',1e-6,...
                         'feastol', 1e-8, 'opttol', 1e-8, 'mip_maxtime_real', 20000,...
                         'bar_maxcrossit', 10);
TStart=tic;
tStart=cputime;
[x,obj,exitflag,output,~] = ...
     knitro_minlp(obj_fn,x0,xType,A,b,Aeq,beq,lb,ub,[],[],options);
time=toc(TStart);
tEnd=cputime-tStart;
info.x=x;
info.time=time;
info.cputime=tEnd;
info.obj=-obj;
info.exitflag=exitflag;
end
