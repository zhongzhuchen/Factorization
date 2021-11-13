function [x,obj,time] = Knitro_DFact(x0,s,F,maxitr)
% calling knitro to solve the DDFact problem
%{
Input:
x0      - the initial point
s       - size of subset we want to choose
F       - C=FF' is a factorization of C where F is an n-by-d array
maxitr  - maximum number of iterations allowed

Output:
x       - final point output by Knitro
obj     - objective value of DFact at x
time    - running time
%}
[n,k]=size(F);
quasi_method=6;
A=zeros(1,n);
b=0;
tic
[x,obj,~] = running_knitro(x0,F,k,A,b,s,maxitr,quasi_method);
time=toc;
end

