function [obj,x] = Knitro_LinxH_noinit(C,s,gamma)
% calling knitro to solve the DDFact problem
%{
Input:
x0      - the initial point
s       - size of subset we want to choose
C       - data matrix
gamma   - scale factor

Output:
x       - final point output by Knitro
obj     - objective value of linx at x
%}

n=length(C);
x0=(s/n)*ones(n,1);
[x,obj,~] = Knitro_LinxH(x0,s,C,gamma);
end
