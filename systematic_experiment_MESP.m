clear all:
n=length(C);
folder = 'Results/MESP';
subfolder=strcat(folder,'/data',int2str(n));
if ~exist(subfolder, 'dir')
    mkdir(subfolder);
end

s=floor(n/2);
baseFileName = strcat('data',int2str(n),'.xlsx');
fullFileNameexcel = fullfile(folder, baseFileName);
if exist(fullFileNameexcel, 'file')==2
  delete(fullFileNameexcel);
end
exceloutput=[];

ubfunc1=@kurtMESPBB_linx_heur;
ubfunc2=@kurtMESPBB_linx_sdpt3_opt;
ubfunc3=@kurtMESPBB_linx_knitro_opt;
ubfunc4=@kurtMESPBB_DDFact_knitro;

[x,obj,info] = kurtMESPBB(s,C,ubfunc1);
exceloutput(end+1,:)=[n, s, "linx_heur" ,info.obj, info.intgap_abs, info.Nnodes, info.time, info.cputime];
[x,obj,info] = kurtMESPBB(s,C,ubfunc2);
exceloutput(end+1,:)=[n, s, "linx_sdpt3_opt", info.obj, info.intgap_abs, info.Nnodes, info.time, info.cputime];
[x,obj,info] = kurtMESPBB(s,C,ubfunc3);
exceloutput(end+1,:)=[n, s, "linx_knitro_opt", info.obj, info.intgap_abs, info.Nnodes, info.time, info.cputime];
[x,obj,info] = kurtMESPBB(s,C,ubfunc4);
exceloutput(end+1,:)=[n, s, "DDFact_knitro", info.obj, info.intgap_abs, info.Nnodes, info.time, info.cputime];

title=["n", "s", "ub_method", "bestval", "intgap_abs", "Nnodes", "time", "cputime"];
xlswrite(fullFileNameexcel ,title,1,'A1');
xlswrite(fullFileNameexcel ,exceloutput,1,'A2');
% [x,obj,info] = Knitro_MESP(s,C,1);
% [x,obj,info] = Knitro_MESP(s,C,2);
% [x,obj,info] = Knitro_MESP(s,C,3);
