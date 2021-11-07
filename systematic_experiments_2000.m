clear all;
load('data2000.mat');
n=length(C);
folder = 'Results';
subfolder=strcat(folder,'/data',int2str(n));
if ~exist(subfolder, 'dir')
    mkdir(subfolder);
end
subfolder_DDFact=strcat(subfolder,'/DDFact');
if ~exist(subfolder_DDFact, 'dir')
    mkdir(subfolder_DDFact);
end
subfolder_DDFact_comp=strcat(subfolder,'/DDFact_comp');
if ~exist(subfolder_DDFact_comp, 'dir')
    mkdir(subfolder_DDFact_comp);
end
subfolder_Linx=strcat(subfolder,'/Linx');
if ~exist(subfolder_Linx, 'dir')
    mkdir(subfolder_Linx);
end
subfolder_Linx_sdpt3=strcat(subfolder,'/Linx_sdpt3');
if ~exist(subfolder_Linx_sdpt3, 'dir')
    mkdir(subfolder_Linx_sdpt3);
end
% create data file for all-s results summary
baseFileName = strcat('data',int2str(n),'.xlsx');
fullFileNameexcel = fullfile(folder, baseFileName);
if exist(fullFileNameexcel, 'file')==2
  delete(fullFileNameexcel);
end
exceloutput=[];


[F,Fsquare,~] = gen_data(C,0);

for s=20:20:120
    % create data file for single s results details
    subbaseFileName = strcat('data',int2str(n),'s',int2str(s),'.xlsx');
    
    % DDFact data
    subfullFileNameexcel_DDFact = fullfile(subfolder_DDFact, subbaseFileName);
    if exist(subfullFileNameexcel_DDFact, 'file')==2
      delete(subfullFileNameexcel_DDFact);
    end
    
    x0=rand(n,1);
    x0=x0*s/sum(x0);
    [x,obj,info_DDFact] = Knitro_DDFact(x0,s,F,Fsquare);
    lengthexcel=length(info_DDFact.dualbound_everyiter);
%     length(info.dualbound_everyiter)
%     length(info.dualgap_everyiter)
%     length(info.normsubg_everyiter)
%     length(info.nonsmooth_everyiter)
    subexceloutput=[n*ones(lengthexcel,1), s*ones(lengthexcel,1), info_DDFact.dualbound_everyiter',...
        info_DDFact.dualgap_everyitr',info_DDFact.normsubg_everyitr',info_DDFact.num_nonsmooth_everyitr'];
    subtitle=["n", "s", "dualbound", "dualgap", "normsubg","prob_nomsmoothpts"];
    xlswrite(subfullFileNameexcel_DDFact ,subtitle,1,'A1');
    xlswrite(subfullFileNameexcel_DDFact ,subexceloutput,1,'A2');
    
    
    
    % Linx data
    subfullFileNameexcel_Linx = fullfile(subfolder_Linx, subbaseFileName);
    if exist(subfullFileNameexcel_Linx, 'file')==2
      delete(subfullFileNameexcel_Linx);
    end
    x0=rand(n,1);
    x0=x0*s/sum(x0);
    gamma=Linx_gamma(C,s);
    [x,obj,info_Linx] = Knitro_Linx(x0,s,C,gamma);
    lengthexcel=length(info_Linx.dualbound_everyiter);
    subexceloutput=[n*ones(lengthexcel,1), s*ones(lengthexcel,1), info_Linx.dualbound_everyiter',...
        info_Linx.dualgap_everyitr',info_Linx.normsubg_everyitr',info_Linx.num_nonsmooth_everyitr'];
    subtitle=["n", "s", "dualbound", "dualgap", "normsubg","prob_nomsmoothpts"];
    xlswrite(subfullFileNameexcel_Linx ,subtitle,1,'A1');
    xlswrite(subfullFileNameexcel_Linx ,subexceloutput,1,'A2');

    % Linx data sdpt3
    subfullFileNameexcel_Linx_sdpt3 = fullfile(subfolder_Linx_sdpt3, subbaseFileName);
    if exist(subfullFileNameexcel_Linx_sdpt3, 'file')==2
      delete(subfullFileNameexcel_Linx_sdpt3);
    end
    x0=rand(n,1);
    x0=x0*s/sum(x0);
    gamma=Linx_gamma(C,s);
    [x,obj,info_Linx_sdpt3] = Sdpt3_Linx(x0,s,C,gamma);
    
    
    
    exceloutput(end+1,:)=[n, s, info_DDFact.dualbound, info_Linx.dualbound, info_Linx_sdpt3.dualbound,...
        info_DDFact.dualgap, info_Linx.dualgap, info_Linx_sdpt3.dualgap,...
        info_DDFact.fixnum, info_Linx.fixnum, info_Linx_sdpt3.fixnum,...
        info_DDFact.firstorderopt, info_Linx.firstorderopt,...
        info_DDFact.num_nonsmooth,...
        info_DDFact.time, info_Linx.time, info_Linx_sdpt3.time,...
        info_DDFact.cputime, info_Linx.cputime, info_Linx_sdpt3.cputime,...
        info_DDFact.funcCount, info_Linx.funcCount];
end

title=["n", "s", "dualbound_DDFact", "dualbound_Linx", "dualbound_Linx_sdpt3",...   
    "dualgap_DDFact", "dualgap_Linx", "dualgap_Linx_sdpt3",...
    "fixnum_DDFact", "fixnum_Linx", "fixnum_Linx_sdpt3",...
    "firstorderopt_DDFact", "firstorderopt_Linx",...
    "prob_nonsmoothpts_DDFact",...
    "wall_clock time_DDFact", "wall_clock time_Linx", "wall_clock time_Linx_sdpt3",...
     "CPU time_DDFact",  "CPU time_Linx", "CPU time_Linx_sdpt3",...  
      "funcCount_DDFact", "funcCount_Linx"];
xlswrite(fullFileNameexcel ,title,1,'A1');
xlswrite(fullFileNameexcel ,exceloutput,1,'A2');