% folder = 'Results_highdim';
% if ~exist(folder, 'dir')
%     mkdir(folder);
% end
% baseFileName = 'backtracking_n63_s10_X7.xlsx';
% fullFileNameexcel = fullfile(folder, baseFileName);
% if exist(fullFileNameexcel, 'file')==2
%   delete(fullFileNameexcel);
% end
% % A=randn(63);
% % C=A*A';
% % n=length(C);
% load('data63.mat');
% C=A;
% n=length(C);
% Minit=randcorr(n);
% s=10;
% mu=0.1;
% [gamma]=Linx_gamma(C,s);
% [exceloutput,M,bound,Mopt,boundopt,gnorm,dirnorm,time,initr,fyouter,failreason,linsearchfail, cursucc,curfail,info]...
%     = Barlbfgs(C,s,Minit,gamma,mu);
% [~,lb]=heur(C,n,s);
% [~,r]=chol(C);
% if r==0
%     optJ=fvalue_opt(ones(n),0,C,s);
% else
%     optJ=NaN;
% end
% title=["mu","linx_bound","gap","J_gap", "||r||_2","||g||_2","step length","max step length ", "line search", "curvature condition","C.*M_eigone","maskMinDistEigtoOne","scale factor"];
% xlswrite(fullFileNameexcel ,title,1,'A1');
% [m,~]=size(exceloutput);
% exceloutput1=[exceloutput(:,1:2),exceloutput(:,2)-lb*ones(m,1),(optJ-lb)*ones(m,1),exceloutput(:,3:11)];
% xlswrite(fullFileNameexcel ,exceloutput1,1,'A2');
% 
% optbound1=fvalue_opt(M,0,C,s);
% 
% fprintf('linx bound for M under optimal scale factor is: %s\n',optbound1-lb);
% fprintf('linx bound for J under optimal scale factor is: %s\n',optJ-lb);
% 
% normM=zeros(4,1);
% normM(1)=norm(ones(n)-Minit,'fro');
% normM(2)=norm(ones(n)-M,'fro');
% normM(3)=norm(eye(n)-Minit,'fro');
% normM(4)=norm(eye(n)-M,'fro');
% normM

%% 
folder = 'Results_data63';
if ~exist(folder, 'dir')
    mkdir(folder);
end
load('data63.mat');
n=length(C);
s=15;
TrMinit=[];
TrM=[];
TtTime=[];
output=[];
for i=1:1
    if i==1
        initmethod='randcorr';
        baseFileName = strcat('backtracking_data63_s',num2str(s),'_randcorr','.xlsx');
        fullFileNameexcel = fullfile(folder, baseFileName);
        if exist(fullFileNameexcel, 'file')==2
          delete(fullFileNameexcel);
        end
        rng('shuffle');
        Minit=randcorr(n);
    elseif i==2
        initmethod='extendedOnion';
        baseFileName = strcat('backtracking_data63_s',num2str(s),'_extendedOnion','.xlsx');
        fullFileNameexcel = fullfile(folder, baseFileName);
        if exist(fullFileNameexcel, 'file')==2
          delete(fullFileNameexcel);
        end
        rng('shuffle');
        Minit=extendedOnion(n,1);
    elseif i==3
        initmethod='vine';
        baseFileName = strcat('backtracking_data63_s',num2str(s),'_vine','.xlsx');
        fullFileNameexcel = fullfile(folder, baseFileName);
        if exist(fullFileNameexcel, 'file')==2
          delete(fullFileNameexcel);
        end
        rng('shuffle');
        Minit=vine(n,1);
    elseif i==4
        initmethod=strcat('gallery_',num2str(i-3));
        baseFileName = strcat('backtracking_data63_s',num2str(s),'_gallery_',num2str(i-3),'.xlsx');
        fullFileNameexcel = fullfile(folder, baseFileName);
        if exist(fullFileNameexcel, 'file')==2
          delete(fullFileNameexcel);
        end
        rng('shuffle');
        Minit=gallery('randcorr',n);
    elseif i==5
        initmethod=strcat('gallery_',num2str(i-3));
        baseFileName = strcat('backtracking_data63_s',num2str(s),'_gallery_',num2str(i-3),'.xlsx');
        fullFileNameexcel = fullfile(folder, baseFileName);
        if exist(fullFileNameexcel, 'file')==2
          delete(fullFileNameexcel);
        end
        rng('shuffle');
        x=1+1.5*(rand(n,1)-0.5);
        x=n*x/sum(x);
        Minit=gallery('randcorr',x);
    elseif i==6
        initmethod=strcat('gallery_',num2str(i-3));
        baseFileName = strcat('backtracking_data63_s',num2str(s),'_gallery_',num2str(i-3),'.xlsx');
        fullFileNameexcel = fullfile(folder, baseFileName);
        if exist(fullFileNameexcel, 'file')==2
          delete(fullFileNameexcel);
        end
        rng('shuffle');
        x=1+1*(rand(n,1)-0.5);
        x=n*x/sum(x);
        Minit=gallery('randcorr',x);
    elseif i==7
        initmethod=strcat('gallery_',num2str(i-3));
        baseFileName = strcat('backtracking_data63_s',num2str(s),'_gallery_',num2str(i-3),'.xlsx');
        fullFileNameexcel = fullfile(folder, baseFileName);
        if exist(fullFileNameexcel, 'file')==2
          delete(fullFileNameexcel);
        end
        rng('shuffle');
        x=1+0.5*(rand(n,1)-0.5);
        x=n*x/sum(x);
        Minit=gallery('randcorr',x);
    elseif i==8
        initmethod=strcat('gallery_',num2str(i-3));
        baseFileName = strcat('backtracking_data63_s',num2str(s),'_gallery_',num2str(i-3),'.xlsx');
        fullFileNameexcel = fullfile(folder, baseFileName);
        if exist(fullFileNameexcel, 'file')==2
          delete(fullFileNameexcel);
        end
        rng('shuffle');
        x=1+0.2*(rand(n,1)-0.5);
        x=n*x/sum(x);
        Minit=gallery('randcorr',x);
    end
    i
    TrMinit(:,:,i)=Minit;
%     C=Cperm;
%     Minit=Minit1;
    mu=0.1;
    [gamma]=Linx_gamma(C,s); %gamma choice
    [exceloutput,M,bound,Mopt,boundopt,gnorm,dirnorm,time,initr,fyouter,failreason,linsearchfail, cursucc,curfail,info]...
        = Barlbfgs(C,s,Minit,gamma,mu);
    lb=-28.8569979073813;
    [~,r]=chol(C);
    if r==0
        optJ=fvalue_opt(ones(n),0,C,s);
    else
        optJ=NaN;
    end
    TrM(:,:,i)=M;
    TrTime(i)=time;
    optM=fvalue_opt(M,0,C,s);
    normM=zeros(4,1);
    normM(1)=norm(ones(n)-Minit,2);
    normM(2)=norm(ones(n)-M,2);
    normM(3)=norm(eye(n)-Minit,2);
    normM(4)=norm(eye(n)-M,2);
    outputadd=[bound-lb,optM-lb,optJ-lb,exceloutput(end-2,10),exceloutput(end-2,9),exceloutput(end-2,3)...
        exceloutput(end-2,4),normM(1),normM(2),normM(3),normM(4)];
    output=[output;outputadd];
    title=["mu","linx_bound","gap","J_gap", "||r||_2","||g||_2","step length","max step length ", "line search", "curvature condition","maskMinDistEigtoOne","MaskMinEig","scale factor"];
    xlswrite(fullFileNameexcel ,title,1,'A1');
    [m,~]=size(exceloutput);
    exceloutput1=[exceloutput(:,1:2),exceloutput(:,2)-lb*ones(m,1),(optJ-lb)*ones(m,1),exceloutput(:,3:11)];
    xlswrite(fullFileNameexcel ,exceloutput1,1,'A2');
end

