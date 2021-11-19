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
gamma=Linx_gamma(C,s);
TStart=tic;
tic;
tStart=cputime;
[x,obj,mixinfo] = mix_handle(C,s,gamma);
alpha=mixinfo.alpha;
dualbound=mixinfo.dualbound;
progress=1;
while progress > 1e-6
    [gamma,~] = Mix_gamma(C,s,alpha,mix_handle);
    [x,obj,mixinfo] = mix_handle(C,s,gamma);
    progress=dualbound-mixinfo.dualbound;
    dualbound=mixinfo.dualbound;
    alpha=mixinfo.alpha;
end
time=toc(TStart);
tEnd=cputime-tStart;
info=struct;
info.x=x;
info.obj=obj;
info.dualbound=dualbound;
info.alpha=alpha;
info.time=time;
info.cputime=tEnd;
end

