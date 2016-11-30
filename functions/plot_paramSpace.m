function [  ] = plot_paramSpace( branch, plot_params_ind, param, varargin )
% This creates a phase-space-eqsue plot of two parameters determined by
% plot_params_ind.
%   Detailed explanation goes here
%   Options:
%       'add_2_gcf' = 0, 1
%       'color'     = [ 0, 0, 0 ] or 'b', 'r', etc.


% Create an options struct from varargin, preserves cell arrays.
for i=1:length(varargin)
    if iscell(varargin{i})
        varargin{i}=varargin(i);
    end
end
options=struct(varargin{:});
held_prior = ishold; % Get current hold status

% Organize behavior from options
if isfield(options,'add_2_gcf') && options.add_2_gcf == 1
      figure(gcf);
      hold on
elseif ~isfield(options,'add_2_gcf') || options.add_2_gcf == 0
     figure; clf;
else
      warning('add_2_gcf can either equal 1 or 0. Since it doesnt, plotting new fig.')
      figure; clf;
end

if isfield(options,'color')
    color = options.color;
else
    color = 'b';
end


% Prepare figure and vals
x_param_vals = arrayfun(@(p)p.parameter(plot_params_ind(1)),branch.point); %Get continued parameter values for xdir
y_param_vals = arrayfun(@(p)p.parameter(plot_params_ind(2)),branch.point); %Get continued parameter values for ydir

% Plot points
plot(x_param_vals,y_param_vals,'.','Color',color);

% Add title, axes

title(strcat(param.plot_names(plot_params_ind(2)), '-vs-', param.plot_names(plot_params_ind(1)), ...
	      ' - Bifurcation Continuation'))
xlabel([param.plot_names(plot_params_ind(1)),param.units(plot_params_ind(1))])
ylabel([param.plot_names(plot_params_ind(2)),param.units(plot_params_ind(2))])

% Return hold to what it was before running this program.
if held_prior==1
    hold on
elseif held_prior==0
    hold off
end
    

end

