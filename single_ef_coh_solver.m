%addpath
addpath('/home/bkmiller/Dokumente/Redlich/');

if dim_choice == 1
%define solver ready func, dimensional units
sys_4solver=@(x)qd_1ef_sys(x(1,1)+1i*x(2,1),x(1,2)+1i*x(2,2),x(3,1),x(3,2),x(4,1),x(4,2), ... 
			   par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9),par(10),par(11),par(12),par(13),par(14),par(15),par(16),par(17),par(18),par(19),par(20),par(21),par(22),par(23),par(24),par(25),par(26),par(27),par(28),par(29));
fprintf('>>>using dimensional units (determined by setup_params) \n')
ef_units = '(V/m)';
time_units = 's';
n_units = 'm^{-2}';

elseif dim_choice == 2
%define solver ready func, dimensionless
sys_4solver=@(x)qd_1ef_sys_nondim(x(1,1)+1i*x(2,1),x(1,2)+1i*x(2,2),x(3,1),x(3,2),x(4,1),x(4,2), ... 
				  par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9),par(10),par(11),par(12),par(13),par(14),par(15),par(16),par(17),par(18),par(19),par(20),par(21),par(22),par(23),par(24),par(25),par(26),par(27),par(28),par(29));
fprintf('>>>using dimensionless \n')
ef_units = '(\epsilon_{ss} \epsilon_{tilda})^{-1/2}';
time_units = '(\tau_{sp})';
n_units = '(S^{in} \tau_{sp})^{-1}';
				  
else
error('make a choice about units in options')

end

%lags, in our case the feedback time
lags = [tau_fb];

%print history
fprintf(strcat('>>>history vector \n>>>hist=',mat2str(hist)))

%search span, print tspan
tspan = [min_time, max_time];
fprintf(strcat('\n >>>Time span \n>>>tspan=',mat2str(tspan)))

%sol
%options in single_ef_coh_options
sol = dde23(@(t,y,z)sys_4solver([y,z]),lags,hist,tspan, options);


figure(1); clf;
subplot(2,2,[1,2]);
plot(sol.x,arrayfun(@(x)norm(x),sol.y(1,:)+1i*sol.y(2,:)))
title({'Electric Field Amplitude vs Time '; strcat('with J=',num2str(J),'A,',' hist=[re(E),im(E),\rho,n_r]=', mat2str(hist))})
xlabel(strcat('Time ', time_units))
ylabel(strcat('|E(t)| ', ef_units))

subplot(2,2,3);
plot(sol.x,sol.y(3,:))
title('QD Occupation Prob vs Time')
xlabel(strcat('Time ', time_units))
ylabel('\rho(t) (no units)')

subplot(2,2,4);
plot(sol.x,sol.y(4,:))
title('Carrier Density vs Time')
xlabel(strcat('Time ', time_units))
ylabel(strcat('n_r(t) ',n_units))


xx_guess = sol.y(:,end)

%implying the following for "x"
% [re(E),
%  im(E),
%  rho, 
%  n ] == x

%implying the following for "z"
% [re(E_tau_fb),
%  im(E_tau_fb),
%  rho_tau_fb,
%  n_tau_fb] == z