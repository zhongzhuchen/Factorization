function [obj,dx] = DDFact_obj_knitro(x,s,F,Fsquare)
% create a callback function for Knitro specifying objective value and gradient 
[obj,dx,~] = DDFact_obj(x,s,F,Fsquare);
obj=-obj;
dx=-dx;
end

