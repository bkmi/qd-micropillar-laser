%DIMENSION HANDLER
if dim_choice == 1
%define solver ready func, dimensional units
sys_4solver=@(x)qd_1ef_sys(x(1,1)+1i*x(2,1),x(1,2)+1i*x(2,2),x(3,1),x(3,2),x(4,1),x(4,2), ... 
			   par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9),par(10),par(11),par(12),par(13),par(14),par(15),par(16),par(17),par(18),par(19),par(20),par(21),par(22),par(23),par(24),par(25),par(26),par(27),par(28),par(29));
%Termwise function defined for inspection.
termwise_sys=@(x)qd_1ef_sys_TERMWISE(x(1,1)+1i*x(2,1),x(1,2)+1i*x(2,2),x(3,1),x(3,2),x(4,1),x(4,2), ... 
				     par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9),par(10),par(11),par(12),par(13),par(14),par(15),par(16),par(17),par(18),par(19),par(20),par(21),par(22),par(23),par(24),par(25),par(26),par(27),par(28),par(29));
fprintf('___using dimensional units (determined by setup_params) \n')
ef_units = '(V/m)';
time_units = 's';
n_units = 'm^{-2}';

elseif dim_choice == 2
%define solver ready func, dimensionless
sys_4solver=@(x)qd_1ef_sys_nondim(x(1,1)+1i*x(2,1),x(1,2)+1i*x(2,2),x(3,1),x(3,2),x(4,1),x(4,2), ... 
				  par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9),par(10),par(11),par(12),par(13),par(14),par(15),par(16),par(17),par(18),par(19),par(20),par(21),par(22),par(23),par(24),par(25),par(26),par(27),par(28),par(29));
%Termwise function defined for inspection.
termwise_sys=@(x)qd_1ef_sys_nondim_TERMWISE(x(1,1)+1i*x(2,1),x(1,2)+1i*x(2,2),x(3,1),x(3,2),x(4,1),x(4,2), ... 
					    par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9),par(10),par(11),par(12),par(13),par(14),par(15),par(16),par(17),par(18),par(19),par(20),par(21),par(22),par(23),par(24),par(25),par(26),par(27),par(28),par(29));

fprintf('___using dimensionless \n')
ef_units = '(\epsilon_{ss} \epsilon_{tilda})^{-1/2}';
time_units = '(\tau_{sp})';
n_units = '(S^{in} \tau_{sp})^{-1}';
				  
else
error('make a choice about units in options')

end


% --


%lags, in our case the feedback time
lags = tau_fb;

%print history
fprintf(strcat('___history vector \n___hist=',mat2str(hist)))

%search span, print tspan
tspan = [min_time, max_time];
fprintf(strcat('\n___Time span \n___tspan=',mat2str(tspan)))

%solver sets sol variable
%dde23_options in single_ef_coh_options
sol = dde23(@(t,y,z)sys_4solver([y,z]),lags,hist,tspan, dde23_options);


% --


%make the plots (time series)
figure(1); clf;
subplot(2,2,[1,2]);
plot(sol.x,arrayfun(@(x)norm(x),sol.y(1,:)+1i*sol.y(2,:)))
title({'Electric Field Amplitude vs Time '; strcat('with J=',num2str(J,'%1.1e'),'A,',' hist=[re(E),im(E),\rho,n_r]=', mat2str(hist))})
xlabel(strcat({'Time '}, time_units))
ylabel(strcat({'|E(t)| '}, ef_units))

subplot(2,2,3);
plot(sol.x,sol.y(3,:))
title('QD Occupation Prob vs Time')
xlabel(strcat({'Time '}, time_units))
ylabel('\rho(t) (no units)')

subplot(2,2,4);
plot(sol.x,sol.y(4,:))
title('Carrier Density vs Time')
xlabel(strcat({'Time '}, time_units))
ylabel(strcat({'n_r(t) '},n_units))


% --


%print out the guess the solver found for bifurcation!
fprintf('\n___The solver is recording the following steady state guess for use in bifurcation analysis:')
xx_guess = sol.y(:,end);

% Data structure notes

%implying the following for "x"
% [re(E),
%  im(E),
%  rho, 
%  n ] == x
% ['re(E)', 're(E_tau)'; 'im(E)', 'im(E_tau)'; 'rho', 'rho_tau'; 'n_r', 'n_r_tau']

%implying the following for "z"
% [re(E_tau_fb),
%  im(E_tau_fb),
%  rho_tau_fb,
%  n_tau_fb] == z


% --


if saveit == 1
  % Save turn on solution.
  turnON_TimeSeries = sol;
  save(strcat(datadir_specific,'turnON_TimeSeries.mat'),'turnON_TimeSeries')
  % Save the relevant units for our system
  save(strcat(datadir_specific,'unit_system.mat'),'ef_units','time_units','n_units','-append')

elseif saveit == 2
else
  warning('Choose a saveit setting in options!! You work is currently not saved!')
end
