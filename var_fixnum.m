n=length(C);
folder = 'mix_Results';
baseFileName = strcat('data',int2str(n),'fixnum.xlsx');
fullFileNameexcel = fullfile(folder, baseFileName);
if exist(fullFileNameexcel, 'file')==2
  delete(fullFileNameexcel);
end

[F,Fsquare,~] = gen_data(C,0);
[Finv,Fsquareinv,ldetC] = gen_data(C,1);

exceloutput=[];
for s=2:(n-1)
    s
    x0=s/n*ones(n,1);
    x0inv=(n-s)/n*ones(n,1);
    sinv=n-s;
    % DDFact 
    [x,obj,info_DDFact] = Knitro_DDFact(x0,s,C,0,F,Fsquare);
    [fixto0list,fixto1list] = varfix_DDFact(x,s,C,0,F,Fsquare);
    DDFact_fixto0=length(fixto0list);
    DDFact_fixto1=length(fixto1list);
    DDFact_fix=DDFact_fixto0+DDFact_fixto1;
    % DDFactcomp
    [xinv,obj,info_DDFactcomp] = Knitro_DDFact(x0inv,sinv,C,1,Finv,Fsquareinv);
    [fixto0list,fixto1list] = varfix_DDFact(xinv,sinv,C,1,Finv,Fsquareinv);
    DDFactcomp_fixto0=length(fixto0list);
    DDFactcomp_fixto1=length(fixto1list);
    DDFactcomp_fix=DDFactcomp_fixto0+DDFactcomp_fixto1;
    % Linx
    gamma=Linx_gamma(C,s);
    [x,obj,info_Linx] = Knitro_Linx(x0,s,C,gamma);
    [fixto0list,fixto1list] = varfix_Linx(x,s,C,gamma);
    Linx_fixto0=length(fixto0list);
    Linx_fixto1=length(fixto1list);
    Linx_fix=Linx_fixto0+Linx_fixto1;
    % mix_DDFact_Linx
    mix_handle2=@mix_Fact_Linx;
    [x,obj,info_Mix2] = mix_alteritr(C,s,mix_handle2);

    if n==124
        % mix_DDFact_DDFactcomp
        mix_handle1=@mix_compFact_Fact;
        [x,obj,info_Mix1] = mix_alteritr(C,s,mix_handle1);
        
        % mix_DDFactcomp_Linx
         mix_handle3=@mix_compFact_Linx;
        [x,obj,info_Mix3] = mix_alteritr(C,s,mix_handle3);
    end

    if n==124
        exceloutput(end+1,:)=[n, s, info_DDFact.solved,info_DDFact.fixnum_to0, DDFact_fixto0, info_DDFact.fixnum_to1, DDFact_fixto1, info_DDFact.fixnum, DDFact_fix,...
            info_DDFactcomp.solved,info_DDFactcomp.fixnum_to0, DDFactcomp_fixto0, info_DDFactcomp.fixnum_to1, DDFactcomp_fixto1, info_DDFactcomp.fixnum, DDFactcomp_fix,...
            info_Linx.solved,info_Linx.fixnum_to0, Linx_fixto0, info_Linx.fixnum_to1, Linx_fixto1, info_Linx.fixnum, Linx_fix,...
            info_Mix1.solved,info_Mix1.fixnum_to0, info_Mix1.fixnum_to02, info_Mix1.fixnum_to1, info_Mix1.fixnum_to12, info_Mix1.fixnum, info_Mix1.fixnum,...
            info_Mix2.solved,info_Mix2.fixnum_to0, info_Mix2.fixnum_to02, info_Mix2.fixnum_to1, info_Mix2.fixnum_to12, info_Mix2.fixnum, info_Mix2.fixnum,...
            info_Mix3.solved,info_Mix3.fixnum_to0, info_Mix3.fixnum_to02, info_Mix3.fixnum_to1, info_Mix3.fixnum_to12, info_Mix3.fixnum, info_Mix3.fixnum];
    else
        exceloutput(end+1,:)=[n, s, info_DDFact.solved,info_DDFact.fixnum_to0, DDFact_fixto0, info_DDFact.fixnum_to1, DDFact_fixto1, info_DDFact.fixnum, DDFact_fix,...
            info_DDFactcomp.solved,info_DDFactcomp.fixnum_to0, DDFactcomp_fixto0, info_DDFactcomp.fixnum_to1, DDFactcomp_fixto1, info_DDFactcomp.fixnum, DDFactcomp_fix,...
            info_Linx.solved,info_Linx.fixnum_to0, Linx_fixto0, info_Linx.fixnum_to1, Linx_fixto1, info_Linx.fixnum, Linx_fix,...
            info_Mix2.solved,info_Mix2.fixnum_to0, info_Mix2.fixnum_to02, info_Mix2.fixnum_to1, info_Mix2.fixnum_to12, info_Mix2.fixnum, info_Mix2.fixnum];
    end
end

if n==124
    title=["n","s","solved_DDFact","fixnum0_DDFact","fixnum0_DDFact_2","fixnum1_DDFact","fixnum1_DDFact_2","fixnum_DDFact","fixnum_DDFact_2",...
        "solved_DDFactcomp","fixnum0_DDFactcomp","fixnum0_DDFactcomp_2","fixnum1_DDFactcomp","fixnum1_DDFactcomp_2","fixnum_DDFactcomp","fixnum_DDFactcomp_2",...
        "solved_Linx","fixnum0_Linx","fixnum0_Linx_2","fixnum1_Linx","fixnum1_Linx_2","fixnum_Linx","fixnum_Linx_2",...
        "solved_DDFactcomp_DDFact","fixnum0_DDFactcomp_DDFact","fixnum0_DDFactcomp_DDFact_2","fixnum1_DDFactcomp_DDFact","fixnum1_DDFactcomp_DDFact_2","fixnum_DDFactcomp_DDFact","fixnum_DDFactcomp_DDFact_2",...
        "solved_DDFact_Linx","fixnum0_DDFact_Linx","fixnum0_DDFact_Linx_2","fixnum1_DDFact_Linx","fixnum1_DDFact_Linx_2","fixnum_DDFact_Linx","fixnum_DDFact_Linx_2",...
        "solved_DDFactcomp_Linx","fixnum0_DDFactcomp_Linx","fixnum0_DDFactcomp_Linx_2","fixnum1_DDFactcomp_Linx","fixnum1_DDFactcomp_Linx_2","fixnum_DDFactcomp_Linx","fixnum_DDFactcomp_Linx_2"];
else
    title=["n","s","solved_DDFact","fixnum0_DDFact","fixnum0_DDFact_2","fixnum1_DDFact","fixnum1_DDFact_2","fixnum_DDFact","fixnum_DDFact_2",...
        "solved_DDFactcomp","fixnum0_DDFactcomp","fixnum0_DDFactcomp_2","fixnum1_DDFactcomp","fixnum1_DDFactcomp_2","fixnum_DDFactcomp","fixnum_DDFactcomp_2",...
        "solved_Linx","fixnum0_Linx","fixnum0_Linx_2","fixnum1_Linx","fixnum1_Linx_2","fixnum_Linx","fixnum_Linx_2",...
        "solved_DDFact_Linx","fixnum0_DDFact_Linx","fixnum0_DDFact_Linx_2","fixnum1_DDFact_Linx","fixnum1_DDFact_Linx_2","fixnum_DDFact_Linx","fixnum_DDFact_Linx_2"];
end
xlswrite(fullFileNameexcel ,title,1,'A1');
xlswrite(fullFileNameexcel ,exceloutput,1,'A2');