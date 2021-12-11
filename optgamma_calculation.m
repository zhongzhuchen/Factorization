n=length(C);
folder = 'Results';
subfolder=strcat(folder,'/data',int2str(n));
if ~exist(subfolder, 'dir')
    mkdir(subfolder);
end
baseFileName = strcat('data',int2str(n),'gamma.xlsx');
fullFileNameexcel = fullfile(folder, baseFileName);
if exist(fullFileNameexcel, 'file')==2
  delete(fullFileNameexcel);
end

totaltimes=5;
for repeattimes=1:totaltimes
    exceloutput=[];
    for s=2:(n-1)
        s
        [gamma,info]=Linx_gamma(C,s);
        exceloutput(end+1,:)=[n, s, info.iterations, info.gap,info.absres,info.difgap,...
            info.optbound, info.optgamma, info.time];
    end
    if repeattimes==1
        exceloutputall=exceloutput;
    else
        exceloutputall=exceloutputall+exceloutput;
    end
end
exceloutputall=exceloutputall./totaltimes;
title=["n", "s", "iterations", "intgap", "abs(res)", "difgap", "optbound","optgamma", "time"];
xlswrite(fullFileNameexcel ,title,1,'A1');
xlswrite(fullFileNameexcel ,exceloutputall,1,'A2');