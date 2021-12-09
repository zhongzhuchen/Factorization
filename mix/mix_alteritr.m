function [x,obj,info] = mix_alteritr(C,s,mix_handle)
% This code iterates over mixing parameter and scaling parater to obtain better bound.
%{
Input:
C       - data matrix
s       - size of subset we want to choose
mix_handle     - mixing bound iterating over
Output:
x       - optimal solution
obj     - mixing upper bound
info    - a struct containing important information:
        x
        obj
        alpha   - mixing parameter
        scale_factor - final scale factor for linx bound
        time    - total elapsed time
        cputime - total cputime
%}
n=length(C);
gamma=Linx_gamma(C,s);
TStart=tic;
tStart=cputime;
[x,obj,mixinfo] = mix_handle(C,s,gamma);
alpha=mixinfo.alpha;
dualbound=mixinfo.dualbound;
while true
    [gamma,~] = Mix_gamma(C,s,alpha,mix_handle);
    [x,obj,mixinfo1] = mix_handle(C,s,gamma);
    progress=dualbound-mixinfo1.dualbound;
    if progress>1e-6
        mixinfo=mixinfo1;
        dualbound=mixinfo.dualbound;
        alpha=mixinfo.alpha;
    else
        break
    end  
end
time=toc(TStart);
tEnd=cputime-tStart;
info=struct;
info.x=mixinfo.x;
info.dx=mixinfo.dx;
info.obj=mixinfo.obj;
info.continuous_dualgap=mixinfo.continuous_dualgap;
info.dualbound=dualbound;
info.dual_v=mixinfo.dual_v;
info.dual_nu=mixinfo.dual_nu;
info.alpha=alpha;

info.integrality_gap=info.dualbound-obtain_lb(C,n,s);

info.time=time;
info.cputime=tEnd;

% evaluate fix ability of the mixing bound
fixto0list=[];
fixto1list=[];

n=length(x);
f=zeros(2*n+1,1);
Aeq=[-eye(n),eye(n),ones(n,1)];
beq=info.dx;
lb=[zeros(2*n,1);-inf];
ub=Inf(2*n+1,1);
x0=[];

options = knitro_options('algorithm',3,'outlev',0); 
I=eye(n);
LB=obtain_lb(C,n,s);
b=-mixinfo.fixcache+LB-info.obj;
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
info.fixto0list=fixto0list;
info.fixnum_to0=length(fixto0list);
info.fixto1list=fixto1list;
info.fixnum_to1=length(fixto1list);
end

