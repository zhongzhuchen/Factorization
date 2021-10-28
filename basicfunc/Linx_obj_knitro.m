function [obj,dx] = Linx_obj_knitro(x,s,C,gamma)
[obj,dx] = Linx_obj(x,s,C,gamma);
obj=-obj;
dx=-dx;
end

