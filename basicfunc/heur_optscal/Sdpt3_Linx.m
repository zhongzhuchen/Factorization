function [xval,obj,info]=Sdpt3_Linx(x0,s,C,gamma)
% calling knitro to solve the DDFact problem
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
n=length(x0);
info=struct;
x=sdpvar(n,1);

constraints=[x >= zeros(n,1), x <= ones(n,1), sum(x)==s];
obj1=logdet(.5*gamma*((C*diag(x)*C)+(C*diag(x)*C)')+eye(n)-diag(x)); % force symmetry
options=sdpsettings('solver','sdpt3','sdpt3.maxit',75,'sdpt3.gaptol',1E-7,'sdpt3.inftol',1E-7,'verbose',0,'cachesolvers',1);

tic
tStart=cputime;
diagnostics=optimize(constraints,-obj1,options); 
diagnostics;
time=toc;
tEnd=cputime-tStart;

code=diagnostics.problem;    
% value of the optimal solution
xval=value(x); 
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

