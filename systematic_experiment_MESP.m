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


[x,obj,info] = Knitro_MESP(s,C,1);
[x,obj,info] = Knitro_MESP(s,C,2);
[x,obj,info] = Knitro_MESP(s,C,3);
