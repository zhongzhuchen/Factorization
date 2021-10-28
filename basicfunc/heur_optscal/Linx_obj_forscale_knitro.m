function [obj,dx] = Linx_obj_forscale_knitro(x,s,C,gamma)
[obj,dx] = Linx_obj_forscale(x,s,C,gamma);
obj=-obj;
dx=-dx;
end

