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
% subfolder_Linx_sdpt3=strcat(subfolder,'/Linx_sdpt3');
% if ~exist(subfolder_Linx_sdpt3, 'dir')
%     mkdir(subfolder_Linx_sdpt3);
% end
% create data file for all-s results summary
baseFileName = strcat('data',int2str(n),'.xlsx');
fullFileNameexcel = fullfile(folder, baseFileName);
if exist(fullFileNameexcel, 'file')==2
  delete(fullFileNameexcel);
end
exceloutput=[];


[F,Fsquare,~] = gen_data(C,0);
load('optgammas_2000_20_20_200.mat');
totaltimes=5;
for repeattimes=1:totaltimes
    exceloutput=[];
    for s=20:20:200
        s
        [~,lb]=heur(C,n,s);
        % create data file for single s results details
        subbaseFileName = strcat('data',int2str(n),'s',int2str(s),'.xlsx');
        
        % DDFact data
        subfullFileNameexcel_DDFact = fullfile(subfolder_DDFact, subbaseFileName);
        if exist(subfullFileNameexcel_DDFact, 'file')==2
          delete(subfullFileNameexcel_DDFact);
        end
        
        x0=s/n*ones(n,1);
        [x,obj,info_DDFact] = Knitro_DDFact(x0,s,C,0,F,Fsquare);
        
        [fixto0list,fixto1list] = varfix_DDFact(x,s,C,0,F,Fsquare);
        DDFact_fixto0=length(fixto0list);
        DDFact_fixto1=length(fixto1list);
        
        lengthexcel=length(info_DDFact.dualbound_everyiter);
        subexceloutput=[n*ones(lengthexcel,1), s*ones(lengthexcel,1), info_DDFact.dualbound_everyiter',...
            info_DDFact.continuous_dualgap_everyitr',info_DDFact.normsubg_everyitr',info_DDFact.num_nonsmooth_everyitr'];
        subtitle=["n", "s", "dualbound", "continuous_dualgap", "normsubg","prob_nomsmoothpts"];
        xlswrite(subfullFileNameexcel_DDFact ,subtitle,1,'A1');
        xlswrite(subfullFileNameexcel_DDFact ,subexceloutput,1,'A2');
        
        
        
        % Linx data
        subfullFileNameexcel_Linx = fullfile(subfolder_Linx, subbaseFileName);
        if exist(subfullFileNameexcel_Linx, 'file')==2
          delete(subfullFileNameexcel_Linx);
        end
        x0=s/n*ones(n,1);
        gamma=optgammas(s/20);% gamma=Linx_gamma(C,s);
        [x,obj,info_Linx] = Knitro_Linx(x0,s,C,gamma);
    
        [fixto0list,fixto1list] = varfix_Linx(x,s,C,gamma);
        Linx_fixto0=length(fixto0list);
        Linx_fixto1=length(fixto1list);
    
        lengthexcel=length(info_Linx.dualbound_everyiter);
        subexceloutput=[n*ones(lengthexcel,1), s*ones(lengthexcel,1), info_Linx.dualbound_everyiter',...
            info_Linx.continuous_dualgap_everyitr',info_Linx.normsubg_everyitr',info_Linx.num_nonsmooth_everyitr'];
        subtitle=["n", "s", "dualbound", "continous_dualgap", "normsubg","prob_nomsmoothpts"];
        xlswrite(subfullFileNameexcel_Linx ,subtitle,1,'A1');
        xlswrite(subfullFileNameexcel_Linx ,subexceloutput,1,'A2');
    
    %     % Linx data sdpt3
    %     subfullFileNameexcel_Linx_sdpt3 = fullfile(subfolder_Linx_sdpt3, subbaseFileName);
    %     if exist(subfullFileNameexcel_Linx_sdpt3, 'file')==2
    %       delete(subfullFileNameexcel_Linx_sdpt3);
    %     end
    %     x0=rand(n,1);
    %     x0=x0*s/sum(x0);
    %     gamma=Linx_gamma(C,s);
    %     [x,obj,info_Linx_sdpt3] = Sdpt3_Linx(x0,s,C,gamma);
        
        
        
        exceloutput(end+1,:)=[n, s, info_DDFact.exitflag, info_Linx.exitflag,...
            info_DDFact.dualbound,info_Linx.dualbound, ...
            info_DDFact.integrality_gap, info_Linx.integrality_gap, ...
            info_DDFact.continuous_dualgap, info_Linx.continuous_dualgap,...
            DDFact_fixto0, Linx_fixto0,...
            DDFact_fixto1, Linx_fixto1,...
            DDFact_fixto0+DDFact_fixto1, Linx_fixto0+Linx_fixto1,...
            info_DDFact.firstorderopt,info_Linx.firstorderopt,...
            info_DDFact.num_nonsmooth, ...
            info_DDFact.time, info_Linx.time,...
            info_DDFact.cputime,info_Linx.cputime,...
            info_DDFact.funcCount, info_Linx.funcCount];
    end
    if repeattimes==1
        exceloutputall=exceloutput;
    else
        exceloutputall=exceloutputall+exceloutput;
    end
end
exceloutputall=exceloutputall./totaltimes;
title=["n", "s", "DDFact_exitflag", "Linx_exitflag",...
    "dualbound_DDFact", "dualbound_Linx", ...
    "intgap_DDFact","intgap_Linx",...
    "continuous_dualgap_DDFact", "continuous_dualgap_Linx",...
    "fixnum0_DDFact", "fixnum0_Linx",...
    "fixnum1_DDFact", "fixnum1_Linx",...
    "fixnum_DDFact", "fixnum_Linx",...
    "firstorderopt_DDFact", "firstorderopt_Linx",...
    "prob_nonsmoothpts_DDFact",...
    "wall_clock time_DDFact", "wall_clock time_Linx", ...
     "CPU time_DDFact", "CPU time_Linx", ...  
      "funcCount_DDFact", "funcCount_Linx"];
xlswrite(fullFileNameexcel ,title,1,'A1');
xlswrite(fullFileNameexcel ,exceloutput,1,'A2');