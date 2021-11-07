clear all:
load('data90.mat');
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
    
    mix_handle=@mix_Fact_Linx;
    [x,obj,info_Mix] = mix_alteritr(C,s,mix_handle);
    exceloutput(end+1,:)=[n, s, info_DDFact.dualbound, info_Linx.dualbound, info_Mix.dualbound,...
        info_Mix.alpha,...
        info_DDFact.time, info_Linx.time, info_Mix.time,...
        info_DDFact.cputime, info_Linx.cputime, info_Mix.cputime];
    
end
title=["n", "s", "dualbound_DDFact", "dualbound_Linx", "dualbound_Mix",...
    "Mix_alpha",...
    "wall_clock time_DDFact", "wall_clock time_Linx", "wall_clock time_Mix",...
     "CPU time_DDFact", "CPU time_Linx", "CPU time_Mix"];
 
xlswrite(fullFileNameexcel ,title,1,'A1');
xlswrite(fullFileNameexcel ,exceloutput,1,'A2');
