%This whole thing is essentially pointless. I need rot_sym to solve the system in any valuable way. I just experimented with this before I got rot_sym working.
%The whole thing is commented out, but it will eventually be deleted... probably soon.

%{

%This program runs Redlich's system s.t. there is only 1 strong electric field.

%begin bifurcation analysis

% PICK GUESS
% x is the guess formatted [ re(E), im(E), rho, n ]
if exist('xx_guess')
  fprintf('A guess has been recorded (proably from using the solver already)\n')
  fprintf(strcat('xx_guess = ', mat2str(xx_guess)))
  fprintf('\n')
else
  fprintf('NO GUESS previously set. Using guess from source code.')
  xx_guess = [1;1;1;1];
  fprintf(strcat('xx_guess = ', mat2str(xx_guess)))
  fprintf('\n')
end


% CHOOSE UNITS
if dim_choice == 1
  %define rhs ready ddebif, dimensional units
  rhs=@(x,p)qd_1ef_sys(x(1,1,:)+1i*x(2,1,:),x(1,2,:)+1i*x(2,2,:),x(3,1,:),x(3,2,:),x(4,1,:),x(4,2,:),p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10),p(11),p(12),p(13),p(14),p(15),p(16),p(17),p(18),p(19),p(20),p(21),p(22),p(23),p(24),p(25),p(26),p(27),p(28),p(29));
  fprintf('>>>using dimensional units (determined by setup_params) \n')

elseif dim_choice == 2
  %define rhs ready func, dimensionless
  rhs=@(x,p)qd_1ef_sys_nondim(x(1,1,:)+1i*x(2,1,:),x(1,2,:)+1i*x(2,2,:),x(3,1,:),x(3,2,:),x(4,1,:),x(4,2,:),p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10),p(11),p(12),p(13),p(14),p(15),p(16),p(17),p(18),p(19),p(20),p(21),p(22),p(23),p(24),p(25),p(26),p(27),p(28),p(29));
  fprintf('>>>using dimensionless \n')
  
else
error('make a choice about units in options')
end

% SETUP BIFURCATION ANALYSIS
funcs=set_funcs(...
    'sys_rhs',rhs,...
    'sys_tau',qd_1ef_sys_tau,...
    'x_vectorized',true);

parbd={'min_bound',[ind_feed_ampli, 0.01],'max_bound',[ind_feed_ampli, 0.9],...
      'max_step',[ind_feed_ampli, 0.05]};

[branch1,suc]=SetupStst(funcs,...
    'parameter', par,'x',xx_guess,...
    'contpar',ind_feed_ampli,'step',0.01,parbd{:});

%branch1.method.continuation.plot=0; % don't plot prgress
figure(2); clf;
[branch1,s,f,r]=br_contn(funcs,branch1,100);
branch1=br_rvers(branch1);
[branch1,s,f,r]=br_contn(funcs,branch1,100)
    
%implying the following for "xx"
% [re(E), re(E_tau_fb),
%  im(E), im(E_tau_fb),
%  rho, rho_tau_fb,
%  n, n_tau_fb] == xx

%}