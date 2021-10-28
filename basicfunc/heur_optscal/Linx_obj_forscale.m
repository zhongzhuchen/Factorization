function [obj,dx] = Linx_obj_forscale(x,s,C,gamma)
% This function calculate the objective value and gradient of linx for given data
%{
Input: 
x       - current point for linx bound
s       - the size of subset we want to choose, also equals to the summation of all elements of x
C       - data matrix
gamma   - scale factor

Output:
obj     - objective value of Linx at current point x
dx      - the gradient of obejctive function of Linx at x
Output:
%}
n=length(C);
F=gamma*C*diag(x)*C+eye(n)-diag(x);
F=1/2*(F+F');
obj=1/2*(log(det(F))-s*log(gamma));
Finv=inv(F);
dx=1/2*(diag(gamma*C*Finv*C-Finv));
end

