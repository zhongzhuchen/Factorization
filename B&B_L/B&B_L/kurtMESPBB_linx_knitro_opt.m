function [results,xval,delta_zero,delta_one] = kurtMESPBB_linx_knitro_opt(C,s,control)
% function for solving linx bound under optimal scale factor obtained
%{
Input:
C       - data matix 
s       - size of subset to choose
control - control parameters used by kurt's heuristic code for calculating
          linx bound

Output:
results - an 6-length array containing:

                results(1)=bound;
                results(2)=code;
                results(3)=time;
                results(4)=newgamma;
                results(5)=kscale;
                results(6)=scalerror;

delta_one (v) - minus of the dual variables associated with constraint x>=0
delta_zeros (nu) - minus of the dual variables associated with constraint x<=1
xval    - value of optimal solution when solving linx bound problem
%}

n=length(C);
gamma=control(6);
if gamma==0
    gamma=Linx_gamma(C,s);
end
% gamma=Linx_gamma(C,s);

x0=s/n*ones(n,1);
[xval,~,info] = Knitro_Linx(x0,s,C,gamma);

delta_one=-info.dual_v;  % change sign and correct for factor 2 in objective
delta_zero=-info.dual_nu; 

results(1)=info.dualbound;
results(2)=1;
results(3)=info.time;
results(4)=gamma;
results(5)=1;
results(6)=1;
end

