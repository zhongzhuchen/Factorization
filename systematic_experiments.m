clear all;
load('data63.mat');
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
[Finv,Fsquareinv,ldetC] = gen_data(C,1);

for s=2:(n-1)
    s
    % create data file for single s results details
    subbaseFileName = strcat('data',int2str(n),'s',int2str(s),'.xlsx');
    
    % DDFact data
    subfullFileNameexcel_DDFact = fullfile(subfolder_DDFact, subbaseFileName);
    if exist(subfullFileNameexcel_DDFact, 'file')==2
      delete(subfullFileNameexcel_DDFact);
    end
    
    x0=s/n*ones(n,1);
    [x,obj,info_DDFact] = Knitro_DDFact(x0,s,F,Fsquare);
    lengthexcel=length(info_DDFact.dualbound_everyiter);
%     length(info.dualbound_everyiter)
%     length(info.continuous_dualgap_everyiter)
%     length(info.normsubg_everyiter)
%     length(info.nonsmooth_everyiter)
    subexceloutput=[n*ones(lengthexcel,1), s*ones(lengthexcel,1), info_DDFact.dualbound_everyiter',...
        info_DDFact.continuous_dualgap_everyitr',info_DDFact.normsubg_everyitr',info_DDFact.num_nonsmooth_everyitr'];
    subtitle=["n", "s", "dualbound", "continuous_dualgap", "normsubg","prob_nomsmoothpts"];
    xlswrite(subfullFileNameexcel_DDFact ,subtitle,1,'A1');
    xlswrite(subfullFileNameexcel_DDFact ,subexceloutput,1,'A2');

    
    
    % DDFact comp data
    subfullFileNameexcel_DDFact_comp = fullfile(subfolder_DDFact_comp, subbaseFileName);
    if exist(subfullFileNameexcel_DDFact_comp, 'file')==2
      delete(subfullFileNameexcel_DDFact_comp);
    end
    
    x0=(n-s)/n*ones(n,1);
    [x,obj,info_DDFact_comp] = Knitro_DDFact(x0,n-s,Finv,Fsquareinv);
    info_DDFact_comp.dualbound=info_DDFact_comp.dualbound+ldetC;
    info_DDFact_comp.dualbound_everyiter=info_DDFact_comp.dualbound_everyiter+ldetC;
    lengthexcel=length(info_DDFact_comp.dualbound_everyiter);
    subexceloutput=[n*ones(lengthexcel,1), s*ones(lengthexcel,1), info_DDFact_comp.dualbound_everyiter',...
        info_DDFact_comp.continuous_dualgap_everyitr',info_DDFact_comp.normsubg_everyitr',info_DDFact_comp.num_nonsmooth_everyitr'];
    subtitle=["n", "s", "dualbound", "continuous_dualgap", "normsubg","prob_nomsmoothpts"];
    xlswrite(subfullFileNameexcel_DDFact_comp ,subtitle,1,'A1');
    xlswrite(subfullFileNameexcel_DDFact_comp ,subexceloutput,1,'A2');
    
    
    
    % Linx data
    subfullFileNameexcel_Linx = fullfile(subfolder_Linx, subbaseFileName);
    if exist(subfullFileNameexcel_Linx, 'file')==2
      delete(subfullFileNameexcel_Linx);
    end
    x0=s/n*ones(n,1);
    gamma=Linx_gamma(C,s);
    [x,obj,info_Linx] = Knitro_Linx(x0,s,C,gamma);
    lengthexcel=length(info_Linx.dualbound_everyiter);
    subexceloutput=[n*ones(lengthexcel,1), s*ones(lengthexcel,1), info_Linx.dualbound_everyiter',...
        info_Linx.continuous_dualgap_everyitr',info_Linx.normsubg_everyitr',info_Linx.num_nonsmooth_everyitr'];
    subtitle=["n", "s", "dualbound", "continuous_dualgap", "normsubg","prob_nomsmoothpts"];
    xlswrite(subfullFileNameexcel_Linx ,subtitle,1,'A1');
    xlswrite(subfullFileNameexcel_Linx ,subexceloutput,1,'A2');

    % Linx data sdpt3
    subfullFileNameexcel_Linx_sdpt3 = fullfile(subfolder_Linx_sdpt3, subbaseFileName);
    if exist(subfullFileNameexcel_Linx_sdpt3, 'file')==2
      delete(subfullFileNameexcel_Linx_sdpt3);
    end
    x0=s/n*ones(n,1);
    % gamma=Linx_gamma(C,s);
    [x,obj,info_Linx_sdpt3] = Sdpt3_Linx(x0,s,C,gamma);
    
    exceloutput(end+1,:)=[n, s, info_DDFact.exitflag, info_DDFact_comp.exitflag, info_Linx.exitflag, info_Linx_sdpt3.code,...
        info_DDFact.dualbound, info_DDFact_comp.dualbound, info_Linx.dualbound, info_Linx_sdpt3.dualbound,...
        info_DDFact.integrality_gap, info_DDFact_comp.dualbound-obtain_lb(n,s), info_Linx.integrality_gap, info_Linx_sdpt3.integrality_gap,...
        info_DDFact.continuous_dualgap, info_DDFact_comp.continuous_dualgap, info_Linx.continuous_dualgap, info_Linx_sdpt3.continuous_dualgap,...
        info_DDFact.fixnum, info_DDFact_comp.fixnum, info_Linx.fixnum, info_Linx_sdpt3.fixnum,...
        info_DDFact.firstorderopt, info_DDFact_comp.firstorderopt, info_Linx.firstorderopt,...
        info_DDFact.num_nonsmooth, info_DDFact_comp.num_nonsmooth,...
        info_DDFact.time, info_DDFact_comp.time, info_Linx.time, info_Linx_sdpt3.time,...
        info_DDFact.cputime, info_DDFact_comp.cputime, info_Linx.cputime, info_Linx_sdpt3.cputime,...
        info_DDFact.funcCount, info_DDFact_comp.funcCount, info_Linx.funcCount];
end

title=["n", "s", "dualbound_DDFact_exitflag", "dualbound_DDFact_comp_exitflag", "dualbound_Linx_exitflag", "dualbound_Linxsdpt3_exitflag",...
    "dualbound_DDFact", "dualbound_DDFact_comp", "dualbound_Linx", "dualbound_Linx_sdpt3",...
    "intgap_DDFact", "intgap_DDFact_comp", "intgap_Linx", "intgap_Linx_sdpt3",...
    "continuous_dualgap_DDFact", "continuous_dualgap_DDFact_comp", "continuous_dualgap_Linx", "continuous_dualgap_Linx_sdpt3",...
    "fixnum_DDFact", "fixnum_DDFact_comp", "fixnum_Linx", "fixnum_Linx_sdpt3",...
    "firstorderopt_DDFact", "firstorderopt_DDFact_comp", "firstorderopt_Linx",...
    "prob_nonsmoothpts_DDFact", "prob_nonsmoothpts_DDFact_comp",...
    "wall_clock time_DDFact", "wall_clock time_DDFact_comp", "wall_clock time_Linx", "wall_clock time_Linx_sdpt3",...
     "CPU time_DDFact", "CPU time_DDFact_comp", "CPU time_Linx", "CPU time_Linx_sdpt3",...  
      "funcCount_DDFact", "funcCount_DDFact_comp", "funcCount_Linx"];
xlswrite(fullFileNameexcel ,title,1,'A1');
xlswrite(fullFileNameexcel ,exceloutput,1,'A2');