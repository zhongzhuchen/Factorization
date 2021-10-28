slist=[];
alphalist=[];
upperblist=[];

for s=2:88
    [upperb,alpha,time] = mix_Fact_Linx('data90.mat',s);
    slist(end+1)=s;
    alphalist(end+1)=alpha;
    upperblist(end+1)=upperb;
end
slist=slist';
alphalist=alphalist';
upperblist=upperblist';
