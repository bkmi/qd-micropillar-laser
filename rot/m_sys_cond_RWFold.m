function [r,J]=m_sys_cond_RWFold(p,orig_cond,dim,ind_rho)
%% constraints used for extended DDE in fold continuation of relative equilibria
%
% (c) DDE-BIFTOOL v. 3.1.1(20), 11/04/2014
%

%% Orig
p_orig=p; % point strut
p_orig.x=p.x(1:dim); % select actual guess/soln
p_orig.parameter=p_orig.parameter(1:ind_rho-1); % lose rho
[r_orig,J_orig]=orig_cond(p_orig);
nuser=length(r_orig);
for i=1:nuser
    J_orig(i).x=[J_orig(i).x;zeros(dim,1)]; % keep orig J, tack on 0s after so you have [x;v]
    J_orig(i).parameter=[J_orig(i).parameter,0]; % put a zero after for rho
end

%% I AM GOING TO TRY ADDING TWO phas
rphas1=0;
Jphas1=J_orig(end-1); 
Jphas1.x=[zeros(dim,1);Jphas1.x(1:dim)]; 

%% Phas
rphas2=0;
Jphas2=J_orig(end); % Grab the LAST J_orig (related to DDE-BIF rot_sym package.)
Jphas2.x=[zeros(dim,1);Jphas2.x(1:dim)]; % zeros for x guess, old guess in Jphas for v

%% Norm
rnorm=sum(p.x(dim+1:end).^2)+p.parameter(ind_rho)^2-1; %square each value of v in p, then add to rho^2 - 1.
Jnorm=p_axpy(0,p,[]); % x = 0, par from p
Jnorm.x(dim+1:end)=2*p.x(dim+1:end); %Give Jnorm, 2*v from p
Jnorm.parameter(ind_rho)=2*p.parameter(ind_rho); % 

%% Return
% r=[r_orig(:);rphas;rnorm];
% J=[J_orig(:);Jphas;Jnorm];
r=[r_orig(:);rphas1;rphas2;rnorm];
J=[J_orig(:);Jphas1;Jphas2;Jnorm];

end
