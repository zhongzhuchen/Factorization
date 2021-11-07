clear all:
load('data124.mat');
n=length(C);
folder = 'mix_Results';
subfolder=strcat(folder,'/data',int2str(n));
if ~exist(subfolder, 'dir')
    mkdir(subfolder);
end
baseFileName = strcat('data',int2str(n),'.xlsx');
fullFileNameexcel = fullfile(folder, baseFileName);
if exist(fullFileNameexcel, 'file')==2
  delete(fullFileNameexcel);
end
exceloutput=[];

[F,Fsquare,~] = gen_data(C,0);
[Finv,Fsquareinv,ldetC] = gen_data(C,1);

for s=2:(n-1)
    subbaseFileName = strcat('data',int2str(n),'s',int2str(s),'.xlsx');
    % DDFact data
    subfullFileNameexcel = fullfile(subfolder, subbaseFileName);
    if exist(subfullFileNameexcel, 'file')==2
      delete(subfullFileNameexcel);
    end
    
    x0=rand(n,1);
    x0=x0*s/sum(x0);
    [x,obj,info_DDFact] = Knitro_DDFact(x0,s,F,Fsquare);
    
    gamma=Linx_gamma(C,s);
    [x,obj,info_Linx] = Knitro_Linx(x0,s,C,gamma);
    
    x0inv=rand(n,1);
    x0inv=x0inv*(n-s)/sum(x0inv);
    [x,obj,info_DDFact_comp] = Knitro_DDFact(x0inv,n-s,Finv,Fsquareinv);
    info_DDFact_comp.dualbound=info_DDFact_comp.dualbound+ldetC;
    
    mix_handle1=@mix_Fact_Linx;
    [x,obj,info_Mix1] = mix_alteritr(C,s,mix_handle1);
    
     mix_handle2=@mix_compFact_Linx;
    [x,obj,info_Mix2] = mix_alteritr(C,s,mix_handle2);
    
     mix_handle3=@mix_compFact_Fact;
    [x,obj,info_Mix3] = mix_alteritr(C,s,mix_handle3);
    
    exceloutput(end+1,:)=[n, s, info_DDFact.dualbound, info_DDFact_comp.dualbound info_Linx.dualbound, ...
        info_Mix1.dualbound, info_Mix2.dualbound, info_Mix3.dualbound,...
        info_Mix1.alpha, info_Mix2.alpha, info_Mix3.alpha, ...
        info_DDFact.time, info_Linx.time, info_DDFact_comp.time, ...
        info_Mix1.time, info_Mix2.time, info_Mix2.time, ...
        info_DDFact.cputime, info_Linx.cputime, info_DDFact_comp.cputime, ...
        info_Mix1.cputime, info_Mix2.cputime, info_Mix3.cputime];
    
end
title=["n", "s", "dualbound_DDFact", "dualbound_Linx", "dualbound_DDFactcomp",...
    "Mix_bound DDFact&Linx", "Mix_bound DDFactcomp&Linx", "Mix_bound DDFactcomp&DDFact",...
    "Mix_alpha DDFact&Linx", "Mix_alpha DDFactcomp&Linx", "Mix_alpha DDFactcomp&DDFact",...
    "wall_clock time_DDFact", "wall_clock time_Linx", "wall_clock time_DDFactcomp",...
    "Mix_time DDFact&Linx", "Mix_time DDFactcomp&Linx", "Mix_time DDFactcomp&DDFact",...
     "CPU time_DDFact", "CPU time_Linx", "CPU time_DDFactcomp",...
     "Mix_cputime DDFact&Linx", "Mix_cputime DDFactcomp&Linx", "Mix_cputime DDFactcomp&DDFact"];
 
xlswrite(fullFileNameexcel ,title,1,'A1');
xlswrite(fullFileNameexcel ,exceloutput,1,'A2');
