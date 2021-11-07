% --------------------------------- Test Fact/Linx code ------------------------------------------
% ------------------------------------------ pass ---------------------------------
clear all;
load('data63.mat');
% B=randn(10);
% C=B*B';
s=10;
n=length(C);

% for s=10:50
%     comp=0;
%     x0=rand(n,1);
%     x0=x0*s/sum(x0);
%     [F,Fsquare,ldetC] = gen_data(C,comp);
%     [x,obj,info] = Knitro_DDFact(x0,s,F,Fsquare);
% end
% sum(abs(info.dual_v-info.lb_lambda))
% sum(abs(info.dual_nu-info.ub_lambda))

% gamma=Linx_gamma(C,s);
% [x,obj,info] = Knitro_Linx(x0,s,C,gamma);
% info;

ind=randsample(n,s);
x0=zeros(n,1);
x0(ind)=1;
[x,obj,info] = Knitro_MESP(x0,s,C,1);

% gamma=Linx_gamma(C,s);
% [x,obj,info] = mix_Fact_Linx(C,s,gamma);
% info
