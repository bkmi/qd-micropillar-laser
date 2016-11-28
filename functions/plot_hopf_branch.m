function [  ] = plot_hopf_branch( hbranch, par_names, par_units, add_2_gcf, color )
% Plot a hopf branch.
%   add_2_gcf = 1 -> Adds plot to current figure.
%   add_2_gcf = 0 or Not Called -> New figure.


% Multiplot
switch nargin
  case {4, 5}
    if add_2_gcf==1
      figure(gcf);
      hold on
    elseif add_2_gcf==0
      figure; clf;
    else
      error('add_2_gcf can either equal 1 or 0. Otherwise, do not call it.')
    end
  case 3
    figure; clf;
    color = 'b';
end
    

% Prepare figure and vals
x_param_vals = arrayfun(@(p)p.parameter(hbranch.parameter.free(1)),hbranch.point); %Get hopf continued parameter values for xdir
y_param_vals = arrayfun(@(p)p.parameter(hbranch.parameter.free(2)),hbranch.point); %Get hopf continued parameter values for ydir

% Plot points
plot(x_param_vals,y_param_vals,'.','Color',color);

% Add title, axes

title(strcat(par_names(hbranch.parameter.free(2)), '-vs-', par_names(hbranch.parameter.free(1)), ...
	      ' - Bifurcation Continuation'))
xlabel([par_names(hbranch.parameter.free(1)),par_units(hbranch.parameter.free(1))])
ylabel([par_names(hbranch.parameter.free(2)),par_units(hbranch.parameter.free(2))])

hold off

end

