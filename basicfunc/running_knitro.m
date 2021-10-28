function [x,fval,exitflag,output,lambda,grad,hess] = running_knitro(x0,F,k,A,b,s,maxit,quasi_method)
%{
Using knitro_nlp solver to solve DFact problems, note that we only have
linear constraints.
%}
% =========================================================================
    
    % calculate necessary length parameters
    [n,~]=size(F);
    [m,~]=size(A);
    
%     % randomly generate a feasible solution to the DFact problem
%     Theta=eye(k)+diag(rand(k,1));
%     theta=zhong_svec2(Theta);
%     v=zeros(n,1);
%     nu=diag(F*Theta*F');
%     pi=zeros(m,1);
%     tau=0;
%     x0    = [theta;v;nu;pi;tau];

    theta=x0(1:(k*(k+1)/2));
    Theta=zhong_svec2_reverse(theta,k);
    v=x0((k*(k+1)/2+1):(k*(k+1)/2+n));
    nu=x0((k*(k+1)/2+n+1):(k*(k+1)/2+2*n));
    tau=x0(end);
    
    pi=zeros(m,1);
    
    [U,D]=eig(Theta);
    if ~issorted(diag(D))
        [D1,~] = sort(diag(D));
    else
        D1=diag(D);
    end
    if D1(s+1)-D1(s)<1e-4
        D=D+(1e-8)*blkdiag(zeros(s),eye(n-s));
        Theta=U*D*U';
        v=nu+tau-diag(F*Theta*F');
        if sum(v>=0)<n
            warning('v is infeasible.');
        end
        theta=zhong_svec2(Theta);
    end
    x0  = [theta;v;nu;pi;tau];

    
    
   
    % SET UP THE (ANONYMOUS) obj, eq, ineq GRANSO FORMAT FUNCTION HANDLE
    % Then we set an anonymous function handle to function adhering to
    % GRANSO's "simultaneous" format
    obj_fn = @(x) obj(x(1:(k*(k+1)/2)),x((k*(k+1)/2+1):(k*(k+1)/2+n)),x((k*(k+1)/2+n+1):(k*(k+1)/2+2*n)),...
        x((k*(k+1)/2+2*n+1):(k*(k+1)/2+2*n+m)),x(k*(k+1)/2+2*n+m+1),A,b,s,k);
    
    lb=[-Inf(k*(k+1)/2,1);
        zeros(2*n+m,1);
        -Inf];
    ub=[];
    
    [~,grad] = eqconst(F,theta,v,nu,pi,tau,A,b,s,k);
    Aeq=grad';
    beq=zeros(n,1);
    A=[];
    b=[];
    % check if the intial point x0 is feasible
    if sum(abs(Aeq*x0-beq))>1e-4
        error('The initial point x0 is infeasible with violation: %s\n', sum(abs(Aeq*x0-beq)))
    end
    
    options = knitro_options('algorithm', 1, 'convex', 1, 'derivcheck', 0, 'outlev', 4 , 'gradopt', 1, ...
                         'hessopt', quasi_method, 'lmsize', 30, 'maxit', maxit, 'xtol', 1e-15, ...
                         'feastol', 1e-8, 'opttol', 1e-8, ...
                         'bar_maxcrossit', 10);
    
    [x,fval,exitflag,output,lambda,grad,hess] = knitro_nlp(obj_fn,x0,A,b,Aeq,beq,lb,ub,[],[],options);
    
end

