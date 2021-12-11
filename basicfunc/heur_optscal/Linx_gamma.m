function [gamma,info]=Linx_gamma(C,s)
% Interior point method to optimize the scaling factor for linx bound,
% adapted to handle singular matrix
t1=tic;
[n,~]=size(C);
TOL= 10^(-6); %Tolerance for residual and dualtity gap
Numiterations=20; %Maximum number of Newton steps to optimize psi=log(gamma)
[U,D]=eig(C);
lam=diag(D);

% calculate the better lower bound among C and Cinv if C is invertible
if min(lam)> 0
    shift=log(prod(lam));  % logdet C
    Cinv=U*diag(1./lam)*U';
    [~,heurval]=heur(C,n,s);        % HEURSITIC ON ORIGINAL
    [~,cheurval]=heur(Cinv,n,n-s); % HEURISTIC ON COMPLEMENT
    if cheurval+shift > heurval        % PICK THE BEST
        heurval=cheurval+shift;
    end
else
    [~,heurval]=heur(C,n,s);        % HEURSITIC ON ORIGINAL
end

csortoriginal=sort(diag(C),'descend');

% Select initial gamma
gamma=1/csortoriginal(s); % initial scale factor if none provided
power=1.5;
gamma=gamma^power;

difgap=1;
k=1;

c1=1e-4;
c2=0.9;
%solve the linx ralaxation for gamma and obtain x
[bound,x]=Knitro_Linx_noinit(C,s,gamma);
AUX = C*diag(x)*C;
%Compute F(gamma,x)
F=gamma*AUX - diag(x) + eye(n);
F=(F+F')/2; % force symmetry
%Compute inv(F(gamma,x))
[U,D]=eig(F);
lam=diag(D);
Finv=U*diag(1./lam)*U';
%Compute the residual res
gap=bound-heurval;
res= n - s - trace(Finv*diag(ones(n,1)-x)); 
allgamma=gamma;
allres=res;
allbound=bound;

while(k<=Numiterations && gap > TOL && abs(res) > TOL && difgap > TOL) 
    if k>1
        difgap=abs(allbound(k)-allbound(k-1));
    end
    %Compute MAT= H_G(gamma:=exp(psi))
    Mat = gamma*(ones(n,1)-x)'*diag(Finv*AUX*Finv);
    %Compute the search direction for Newton's method (dir=-res/Mat)
    dir=-res/Mat;
    edir=exp(dir);
    if abs(edir)==Inf
        edir=sign(edir)*1e10;
    end
    dir=log(edir);
    %check if alfa=1 satisfies the Strong Wolfe Conditions
    alfa=1;
    ngamma=gamma*exp(alfa*dir);
    [nbound,nx]=Knitro_Linx_noinit(C,s,ngamma);
    nAUX = C*diag(nx)*C;
    nF=ngamma*nAUX - diag(nx) + eye(n);
    nF=(nF+nF')/2; % force symmetry
    [U,D]=eig(nF);
    lam=diag(D);
    nFinv=U*diag(1./lam)*U';
    nres= n - s - trace(nFinv*diag(ones(n,1)-nx)); 
    if nbound-bound>c1*alfa*dir*res
        judge=0;
    elseif abs(dir*nres)>c2*abs(dir*res)
        judge=0;
    else
        judge=1;
    end
    %line search
    b=1;
    a=0;
    while judge==0
        alfa=(a+b)/2;
        ngamma=gamma*exp(alfa*dir);
        [nbound,nx]=Knitro_Linx_noinit(C,s,ngamma);
        nAUX = C*diag(nx)*C;
        nF=ngamma*nAUX - diag(nx) + eye(n);
        nF=(nF+nF')/2; % force symmetry
        [U,D]=eig(nF);
        lam=diag(D);
        nFinv=U*diag(1./lam)*U';
        nres= n - s - trace(nFinv*diag(ones(n,1)-nx)); 
        if nbound-bound>c1*alfa*dir*res
            b=alfa;
        elseif abs(dir*nres)>c2*abs(dir*res)
            a=alfa;
        else
            break
        end
        if abs(b-a)<1e-3
            break
        end   
    end
    gamma=ngamma;
    res=nres;
    Finv=nFinv;
    AUX=nAUX;
    x=nx;
    bound=nbound;
    gap=bound-heurval;
    allgamma=[allgamma,gamma];
    allres=[allres,res];
    allbound=[allbound,bound];
    k=k+1; 
end
info.iterations=k-1;
info.gap=gap;
info.absres=abs(res);
info.difgap=difgap;
[optbound,optiteration]=min(allbound);
optgamma=allgamma(optiteration);
[bound1,~]=Knitro_Linx_noinit(C,s,1);
if optbound>bound1
    optbound=bound1;
    optgamma=1;
end
info.optbound=optbound;
info.optgamma=optgamma;
time=toc(t1);
info.time=time;
end