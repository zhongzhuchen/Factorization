function [obj,dx] = mix_compFact_Linx_obj_knitro(x,s,F,Fsquare,C,gamma,alpha,ldetC)
% callback function for mixing comp fact and linx bound
n=length(C);
y=ones(n,1)-x;
[objy,dy,~] = DDFact_obj(y,n-s,F,Fsquare);
[objx,dx,~] = Linx_obj(x,s,C,gamma);

obj=-((1-alpha)*(objy+ldetC)+alpha*objx);
dx=-((1-alpha)*(-dy)+alpha*dx);
end

