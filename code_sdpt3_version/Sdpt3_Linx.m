function [xval,obj,info]=Sdpt3_Linx(x0,s,C,gamma)
% calling knitro to solve the DDFact problem
% exclusively for use by n=63, 90, 124 instances
%{
Input:
x0      - the initial point (just to keep consistent with other solving function, no use here)
s       - size of subset we want to choose
C       - data matrix
gamma   - scale factor

Output:
xval    - final point output by Knitro
obj     - objective value of linx at x
info     - a struct containing important information:
        x - optimal solution
        obj - optimal value
        time    - running wallclock time
        CPUtime - running CPU time
%}
n=length(C);
TStart=tic;
tStart=cputime;
[~,xval,code]=linx_vsfampa2_ver2(C,s,gamma);
time=toc(TStart);
tEnd=cputime-tStart;

% check if sdpt3 outputs a feasible solution
if code==0
else
    gamma=obtain_gamma(n,s);
    tic
    tStart=cputime;
    [~,xval,code]=linx_vsfampa2_ver2(C,s,gamma);
    time=toc;
    tEnd=cputime-tStart;  
end

info=struct;
info.code=code;
info.x=xval;
[obj,dx,finalinfo] = Linx_obj(xval,s,C,gamma);
info.obj=obj;
info.continuous_dualgap=finalinfo.dualgap;
info.dualbound=info.obj+info.continuous_dualgap;
info.normsubg=norm(dx);
info.time=time;
info.cputime=tEnd;
info.dual_v=finalinfo.dual_v;
info.dual_nu=finalinfo.dual_nu;

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


end

