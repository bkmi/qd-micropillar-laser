%This program runs for the single mode laser case.

%Prepare rotational symmetry for bifurcation analysis. Required by rotational DDEBIF tool.
%angular velocity estimate
omega = 0;
%tack on omega for rotational sym aspect
ind_omega=length(par)+1;
par(ind_omega)=omega;

%create rotation matrix
A_rot=[0,-1,0,0; 1,0,0,0; 0,0,0,0; 0,0,0,0];
expA_rot=@(phi) [cos(phi),-sin(phi),0,0; sin(phi),cos(phi),0,0; 0,0,1,0; 0,0,0,1];


% --


%Guess handler. Tries to use solver output if possible.
% x is the guess formatted [ re(E), im(E), rho, n ]
if exist('xx_guess')
  fprintf('___A guess has been recorded. (proably from using the solver.)\n')
  fprintf(strcat('___xx_guess = ', mat2str(xx_guess)))
  fprintf('\n')
else
  fprintf('___NO GUESS previously set. Using trivial guess from source code.')
  xx_guess = [0;0;0;0];
  fprintf(strcat('___xx_guess = ', mat2str(xx_guess)))
  fprintf('\n')
end


% --


%DIMENSION HANDLER
if dim_choice == 1
  %define rhs ready ddebif, dimensional units
  rhs=@(x,p)qd_1ef_sys(x(1,1,:)+1i*x(2,1,:),x(1,2,:)+1i*x(2,2,:),x(3,1,:),x(3,2,:),x(4,1,:),x(4,2,:),p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10),p(11),p(12),p(13),p(14),p(15),p(16),p(17),p(18),p(19),p(20),p(21),p(22),p(23),p(24),p(25),p(26),p(27),p(28),p(29));
  fprintf('___using dimensional units (determined by setup_params) \n')

elseif dim_choice == 2
  %define rhs ready func, dimensionless
  rhs=@(x,p)qd_1ef_sys_nondim(x(1,1,:)+1i*x(2,1,:),x(1,2,:)+1i*x(2,2,:),x(3,1,:),x(3,2,:),x(4,1,:),x(4,2,:),p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10),p(11),p(12),p(13),p(14),p(15),p(16),p(17),p(18),p(19),p(20),p(21),p(22),p(23),p(24),p(25),p(26),p(27),p(28),p(29));
  fprintf('___using dimensionless \n')
  
else
error('make a choice about units in options')
end


% --


%prepare function for solver
funcs=set_rotfuncs('sys_rhs',rhs,'rotation',A_rot,'exp_rotation',expA_rot,'sys_tau',qd_1ef_sys_tau,'x_vectorized',true);
%for rotational system
opt_inputs={'extra_condition',1,'print_residual_info',0};

% Data structure notes
%implying the following for "xx"
% [re(E), re(E_tau_fb),
%  im(E), im(E_tau_fb),2
%  rho, rho_tau_fb,
%  n, n_tau_fb] == xx

% --


% Setup steady state and start with continuation.

%Setup stst
%[dummycw,suc]=SetupStst(funcs,'contpar',[ind_feed_phase,ind_omega],'corpar',ind_omega,...
%    'x',xx_guess,'parameter',par,opt_inputs{:},...
%    'max_step',[ind_feed_phase,2*pi/64] ,'max_bound',[ind_feed_phase,4*pi*4],'newton_max_iterations',10);
%figure(2); clf;
%dummycw=br_contn(funcs,dummycw,50);

%{ %FOR FEED AMPLI
par_cont_ind = [ind_feed_ampli,ind_omega];
[branch1,suc]=SetupStst(funcs,'contpar',par_cont_ind,'corpar',ind_omega,...
    'x',xx_guess,'parameter',par,opt_inputs{:},...
    'max_step',[ind_feed_ampli,0.1] ,'max_bound',[ind_feed_ampli,0.99],'newton_max_iterations',10);
branch1.method.continuation.plot=0;
[branch1,s,f,r]=br_contn(funcs,branch1,100);
%branch1=br_rvers(branch1);
%[branch1,s,f,r]=br_contn(funcs,branch1,50);
%}

%FOR FEED PHASE
par_cont_ind = [ind_feed_phase,ind_omega];
[branch1,suc]=SetupStst(funcs,'contpar',par_cont_ind,'corpar',ind_omega,...
    'x',xx_guess,'parameter',par,opt_inputs{:},...
    'max_step',[ind_feed_phase,2*pi/64] ,'max_bound',[ind_feed_phase,4*pi],'newton_max_iterations',10);
branch1.method.continuation.plot=0;
[branch1,s,f,r]=br_contn(funcs,branch1,100);
%branch1=br_rvers(branch1);
%[branch1,s,f,r]=br_contn(funcs,branch1,50);


% --


% Access values at data points from continuation.

branch1_plot_vals = c_extract(branch1, par_cont_ind);

% Create plots versus modified params
figure(2); clf;
subplot(2,2,[1,2]);
plot(branch1_plot_vals.par(1,:), arrayfun(@(x)norm(x),branch1_plot_vals.soln(1,:)+1i*branch1_plot_vals.soln(2,:)))
title({'Electric Field Amplitude vs Param'; strcat('with J=',num2str(J),'A')})
xlabel(strcat('Param', ' needs units'))
ylabel(strcat('|E(t)| ', ef_units))

subplot(2,2,3);
plot(branch1_plot_vals.par(1,:),branch1_plot_vals.soln(3,:))
title('QD Occupation Prob vs Param')
xlabel(strcat('Param', ' needs units'))
ylabel('\rho(t) (no units)')

subplot(2,2,4);
plot(branch1_plot_vals.par(1,:),branch1_plot_vals.soln(4,:))
title('Carrier Density vs Param')
xlabel(strcat('Param', ' needs units'))
ylabel(strcat('n_r(t) ',n_units))
