folder = 'Results_data90';
if ~exist(folder, 'dir')
    mkdir(folder);
end
baseFileName = strcat('data90','.xlsx');
fullFileNameexcel = fullfile(folder, baseFileName);
if exist(fullFileNameexcel, 'file')==2
  delete(fullFileNameexcel);
end
exceloutput=[];
datafile='data90.mat';
load(datafile);
n=length(C);
difftol=1e-6;
for s=30:65
    gamma=Linx_gamma(C,s);
    x0=(s/n)*ones(n,1);
    comp=0;
    [F,Fsquare,~] = gen_data(C,comp);
    [x,linx_v,linx_time] = Knitro_Linx(x0,s,C,gamma);
    [linx_v2,xval,linx_time2]=linx_vsfampa2_ver2(C,s,gamma);
    [x,DDFact_v,dualgap, DDFact_time] = Knitro_DDFact(x0,s,F,Fsquare);
    DFact_v=DDFact_v+dualgap;
    
    diffgap=1;
    tic
    while diffgap>difftol
        [mix_v,x,alpha,~] = mix_Fact_Linx(C,s,gamma);
        mix_handle=@mix_Fact_Linx;
        [optgamma,optbound] = Gamma_mix(C,s,alpha,mix_handle);
        diffgap=mix_v-optbound;
        gamma=optgamma;
    end
    mix_time=toc;
    exceloutput=[exceloutput; n,s,linx_v,linx_v2,DFact_v,optbound,optgamma,linx_time,linx_time2,DDFact_time,mix_time];
end
lb=[161.5145596
166.426246
171.3276399
176.205987
181.0087235
185.8761358
190.7339351
195.5770253
200.4164984
205.1901259
209.9579343
214.7148632
219.4662392
224.2148055
228.9492067
233.6735216
238.3618492
243.0683144
247.7733895
252.4671552
257.1153293
261.7734118
266.4179166
270.9969886
275.6340582
280.2269194
284.7831661
289.3779151
293.9314672
298.4557995
302.9747218
307.5091563
312.0079712
316.4879728
320.9529716
325.4171332];
exceloutput=[exceloutput(:,1:2),lb,exceloutput(:,3:end)];
exceloutput(:,(end+1):(end+4))=exceloutput(:,4:7)-exceloutput(:,3);
title=["n","s","lb","Linx bound(knitro)", "Linx bound(sdpt3)","Fact bound", "mix_Fact(0)_Linx",...
    "final_gamma", "Linx time(knitro)", "Linx time(sdpt3)", "Fact time", "mix time", "gap Linx bound(knitro)",...
    "gap Linx bound(sdpt3)", "gap Fact bound", "gap mix_Fact(0)_Linx"];
xlswrite(fullFileNameexcel ,title,1,'A1');
xlswrite(fullFileNameexcel ,exceloutput,1,'A2');


% load('data63.mat');
% n=length(C);
% s=37;
% gamma=Linx_gamma(C,s);
% x0=(s/n)*ones(n,1);
% [mix_v,x,alpha,mix_time] = mix_Fact_Linx(C,s,gamma);
% mix_handle=@mix_Fact_Linx;
% [optgamma,optbound] = Gamma_mix(C,s,alpha,mix_handle);