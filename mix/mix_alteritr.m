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
info.x=x;
info.obj=obj;
info.dualgap=mixinfo.dualgap;
info.dualbound=dualbound;
info.dual_v=mixinfo.dual_v;
info.dual_nu=mixinfo.dual_nu;
info.alpha=alpha;
if n==63 || n==90 || n==124
    info.integrality_gap=info.dualbound-obtain_lb(n,s);
    % number of fixing variables
    info.fixnum=0;
    info.fixnum_to0=0;
    info.fixnum_to1=0;
    intgap=info.integrality_gap;
    for i=1:n
        if intgap<info.dual_v(i)-1e-10
            info.fixnum=info.fixnum+1;
            info.fixnum_to0=info.fixnum_to0+1;
        elseif intgap<info.dual_nu(i)-1e-10
            info.fixnum=info.fixnum+1;
            info.fixnum_to1=info.fixnum_to1+1;
        end
    end
end
info.time=time;
info.cputime=tEnd;
end

