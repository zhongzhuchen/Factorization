function [optv,xval,code]=linx_vsfampa2_ver2(C,s,gamma)
% solve the linx bound
% Input:
%   C: data matrix
%   s: size of the to select submatrix
%   gamma: scaling parameter
% Output:
%   optv: linx bound
%   xval: corresponding optimal solution
n=size(C,1);
x=sdpvar(n,1);
time=0; % total time spent in solvers

constraints=[x >= zeros(n,1), x <= ones(n,1), sum(x)==s];
obj1=logdet(.5*gamma*((C*diag(x)*C)+(C*diag(x)*C)')+eye(n)-diag(x)); % force symmetry
options=sdpsettings('solver','sdpt3','sdpt3.maxit',75,'sdpt3.gaptol',1E-7,'sdpt3.inftol',1E-7,'verbose',0,'cachesolvers',1);
solvetime=tic;
diagnostics=optimize(constraints,-obj1,options);    
time=time+toc(solvetime); % record time in solver
code=diagnostics.problem;
xval=value(x); % value of optimal solution
optv=0.5*(double(obj1)-s*log(gamma));
end

