function [ ptBranInd_extrema ] = plot_branch( branch, param_struct, ...
    varargin )
%Plot a branch (by default) along its two free continuation parameters.
%   Considering we are using rotational symmetry stst will also work since
%   omega counts as a free parameter. The function plots two continuation 
%   parameters like this by default:
%   
%   branch.parameter.free(1:2).
%   The x-axis get branch.parameter.free(1).
%   The y-axis get branch.parameter.free(2).
%   
%   Input:
%       branch
%       param_struct
%       varargin
%
%   Output:
%       ptBranInd_extrema
%           ptBranInd_extrema is a struct containing the point index
%           along the branch of extrema in the x and y directions. It is
%           organized as follows:
%               ptBranInd_extrema.(xdir).max = 0
%               ptBranInd_extrema.(xdir).min = 0
%               ptBranInd_extrema.(ydir).max = 0
%               ptBranInd_extrema.(ydir).min = 0
%           Where (xdir) and (ydir) are the var_names given by param_struct
%
%   Options:
%       'axes_indParam' = [ 0, 0 ]
%           Calling this sets the axes along different parameters than
%           given by branch.parameter.free. The axes are determined by the
%           index of the parameter you enter. The x-axis goes with the
%           first and the y-axis goes with the second.
%       'add_2_gcf' = 0, 1
%           'add_2_gcf' = 1 -> Adds plot to current figure.
%           'add_2_gcf' = 0 or Not Called -> New figure.
%       'Color' = [ 0, 0, 0 ] OR 'b', 'y', etc.
%           The branch will be the given color.
%       'PlotStyle' = { 'LineStyle', '-', 'Marker', '.' }
%           Input a cell array which will be passed to the plotter. Usual
%           plot commands apply.


% Get hold status
held_prior = ishold;

% Create an options struct from varargin, preserves cell arrays.
for i=1:length(varargin)
    if iscell(varargin{i})
        varargin{i}=varargin(i);
    end
end
options=struct(varargin{:});

% Setup defaults and behavior sorting.
if ~isfield(options,'axes_indParam')
    options.axes_indParam = ...
    [branch.parameter.free(1), branch.parameter.free(2)];
end

if ~isfield(options,'add_2_gcf')
    options.add_2_gcf = 0;
    figure; clf;
elseif options.add_2_gcf==1
    figure(gcf);
    hold on
elseif options.add_2_gcf==0
    figure; clf;
else
    error('add_2_gcf can either equal 1 or 0. Otherwise, do not call it.')
end

if ~isfield(options,'Color')
    options.Color = 'b';
end

if ~isfield(options,'PlotStyle')
    options.PlotStyle = { 'LineStyle', '-', 'Marker', '.' };
end
    

% Prepare figure and vals
x_param_vals = arrayfun(@(p)p.parameter(options.axes_indParam(1)), ... 
    branch.point); %Get fold continued parameter values for xdir
y_param_vals = arrayfun(@(p)p.parameter(options.axes_indParam(2)), ...
    branch.point); %Get fold continued parameter values for ydir

% Report extrema
ptBranInd_extrema = struct;
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(1)}) = struct;
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(2)}) = struct;
% x-dir
[max_val_x, max_ind_x] = max(x_param_vals);
[min_val_x, min_ind_x] = min(x_param_vals);
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(1)}).Val = ... 
    [min_val_x, max_val_x];
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(1)}).Ind = ... 
    [min_ind_x, max_ind_x];
% y-dir
[max_val_y, max_ind_y] = max(y_param_vals);
[min_val_y, min_ind_y] = min(y_param_vals);
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(2)}).Val = ... 
    [min_val_y, max_val_y];
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(2)}).Ind = ... 
    [min_ind_y, max_ind_y];

% Plot points
plot(x_param_vals,y_param_vals, ...
    'Color',options.Color, options.PlotStyle{:} );

% Add title, axes
title(strcat(param_struct.plot_names(options.axes_indParam(2)), ...
    '-vs-', param_struct.plot_names(options.axes_indParam(1)), ...
	      ' - Bifurcation Continuation'))
xlabel([param_struct.plot_names(options.axes_indParam(1)), ... 
    param_struct.units(options.axes_indParam(1))])
ylabel([param_struct.plot_names(options.axes_indParam(2)), ...
    param_struct.units(options.axes_indParam(2))])


% Return hold to what it was before running this function.
if held_prior==1
    hold on
elseif held_prior==0
    hold off
end

end

