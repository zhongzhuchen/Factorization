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

info.integrality_gap=info.dualbound-obtain_lb(C,n,s);
% number of fixing variables
info.fixnum=0;
info.fixnum_to0=0;
info.fixto0list=[];
info.fixnum_to1=0;
info.fixto1list=[];
intgap=info.integrality_gap;
for i=1:n
    if intgap<info.dual_v(i)-1e-10
        info.fixnum=info.fixnum+1;
        info.fixnum_to0=info.fixnum_to0+1;
        info.fixto0list(end+1)=i;
    elseif intgap<info.dual_nu(i)-1e-10
        info.fixnum=info.fixnum+1;
        info.fixnum_to1=info.fixnum_to1+1;
        info.fixto1list(end+1)=i;
    end
end


end

