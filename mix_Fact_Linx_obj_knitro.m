function [obj,dx] = mix_Fact_Linx_obj_knitro(x,s,F,Fsquare,C,gamma,alpha)
% callback function for mixing fact and linx bound
[obj1,dx1,~] = DDFact_obj(x,s,F,Fsquare);
[obj2,dx2] = Linx_obj(x,s,C,gamma);
obj=-((1-alpha)*obj1+alpha*obj2);
dx=-((1-alpha)*dx1+alpha*dx2);
end

