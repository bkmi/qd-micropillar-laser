%This program runs for the single mode laser case.

%Prepare rotational symmetry for bifurcation analysis. Required by rotational DDEBIF tool.
%angular velocity estimate
omega = 0;
%tack on omega for rotational sym aspect
ind_omega=length(par)+1;
par(ind_omega)=omega;
par_units(ind_omega) = {'1/tau_sp'};
par_names(ind_omega) = {'omega'};

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


% Save rotation parameters
if saveit==1
  save(strcat(datadir_specific,'rot_parameters.mat'),'omega','ind_omega','A_rot','expA_rot', 'xx_guess')
  save(strcat(datadir_specific,'parameters.mat'), 'par', 'par_units', 'par_names', '-append')
elseif saveit == 2
else
  error('Choose a saveit setting in options!!')
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


% Save rotation functions
if saveit==1
  save(strcat(datadir_specific,'rot_funcs.mat'),'rhs','funcs','opt_inputs')
elseif saveit == 2
else
  error('Choose a saveit setting in options!!')
end
