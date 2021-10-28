function [obj,dx] = mix_compFact_Linx_obj_knitro(x,s,F,Fsquare,C,gamma,alpha,ldetC)
% callback function for mixing comp fact and linx bound
% Notice now that x is a 2*n length vector
n=length(C);
y1=x(1:n);
y2=x((n+1):(2*n));
if length(y1)~=n || length(y2) ~=n
    error('error calculating mixing objective function.');
end
[obj1,dy1,~] = DDFact_obj(y1,n-s,F,Fsquare);
[obj2,dy2] = Linx_obj(y2,s,C,gamma);
obj=-((1-alpha)*(obj1+ldetC)+alpha*obj2);
dx=[-(1-alpha)*dy1;
    -alpha*dy2];
end

