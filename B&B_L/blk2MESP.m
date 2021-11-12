function [optv,names,results] = blk2MESP(C)
%{
This function calculates the optimal values of MESP for data matrix composed of
2-order positive-semidefinite diagonal blocks whre s, the size of subset we
choose, equals to n/2

Input:
    C: an n by n matrix composed of 2-order positive-semidefinite diagonal
       blocks, where the blocks can be different

Output:
    optv: optimal values of MESP where s=n/2
    results: struct result outputted by Gurobi optimizer

%}
n=length(C);
s=n/2;
f=zeros(n/2,3);
for i=1:(n/2)
    subC=C((2*i-1):2*i,(2*i-1):2*i);
    f(i,1)=0;
    f(i,2)=log(max(subC(1,1),subC(2,2)));
    f(i,3)=log(det(subC));
end
f=f';
f=reshape(f,1,[]);
f=f';
A=[];
for i=1:(n/2)
    A=[A;zeros(1,3*(i-1)), ones(1,3), zeros(1,3*(n/2-i))];
end
A=[A;repmat([0,1,2],1,n/2)];
b=[ones(n/2,1);s];
names=cell(3*n/2,1);
for i=1:(n/2)
    for j=1:3
        names{3*(i-1)+j,1}=strcat('x(',num2str(i),',',num2str(j-1),')');
    end
end

model.A=sparse(A);
model.obj=f;
model.sense='=';
model.rhs=b;
model.vtype='B';
model.modelsense='max';
model.varnames=names;

gurobi_write(model, '2blkMESP.lp');
params.outputflag = 0;
results=gurobi(model,params);
optv=results.objval;
end

