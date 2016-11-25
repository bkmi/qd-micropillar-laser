function [  ] = plot_hopf_branch( hbranch, par_names, par_units )
% 
%   Detailed explanation goes here


% Prepare figure and vals
figure; clf;
x_param_vals = arrayfun(@(p)p.parameter(hbranch.parameter.free(1)),hbranch.point); %Get hopf continued parameter values for xdir
y_param_vals = arrayfun(@(p)p.parameter(hbranch.parameter.free(2)),hbranch.point); %Get hopf continued parameter values for ydir

% Plot points
plot(x_param_vals,y_param_vals,'.');

% Add title, axes

title(strcat(par_names(hbranch.parameter.free(2)), '-vs-', par_names(hbranch.parameter.free(1)), ...
	      ' - Hopf Bifurcation Continuation'))
xlabel([par_names(hbranch.parameter.free(1)),par_units(hbranch.parameter.free(1))])
ylabel([par_names(hbranch.parameter.free(2)),par_units(hbranch.parameter.free(2))])


end

