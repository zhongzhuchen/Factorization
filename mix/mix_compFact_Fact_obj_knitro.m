function [obj,dx] = mix_compFact_Fact_obj_knitro(x,s,invF,invFsquare,F,Fsquare,alpha,ldetC)
% callback function for mixing comp fact and fact bound
n=length(x);
y=ones(n,1)-x;
[objy,dy,~] = DDFact_obj(y,n-s,invF,invFsquare);
[objx,dx,~] = DDFact_obj(x,s,F,Fsquare);

obj=-((1-alpha)*(objy+ldetC)+alpha*objx);
dx=-((1-alpha)*(-dy)+alpha*dx);
end

