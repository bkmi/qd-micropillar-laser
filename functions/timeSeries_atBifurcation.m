function [ timeSeries_solns ] = timeSeries_atBifurcation( funcs, branch, ...
    timeSpan, param, branch_name, varargin )
%Takes in a branch and produces time series plots around a bifurcation
%point "n," by making a time series at branch point n and n+1. If
%bifurcations occur at two point sequentially, the system rejects them.
%   Options:
%       'plot' = 1,0
%           If you choose to plot = 1 then the solver will output the
%           solver plot. These are timeseries with ef, rho, and n.
%       'save' = 'directory'
%           The program will save the structure generated named relevant to
%           the branch it 
%       'dde23_options' = ddeset('RelTol',10^-8), ...;
%           Calling this flag will let you change the precision, behavior
%           of the dde23 solver. The default is written above. For more
%           information check out the following link:
%         https://www.mathworks.com/help/matlab/ref/ddeset.html#f81-1031913


% Create an options struct from varargin, preserves cell arrays.
for i=1:length(varargin)
    if iscell(varargin{i})
        varargin{i}=varargin(i);
    end
end
options=struct(varargin{:});



% Setup defaults, Process varargin
if isfield(options,'save')
    datadir_specific = options.save;
end


% Sort solver options into its own, sensible/relevant cell array.
solver_opt = {};
if isfield(options,'plot')
    solver_opt{end+1} = 'plot';
    solver_opt{end+1} = options.plot;
end
%{
% I commented this out because I don't want to have to save the unit system
if isfield(options.SI_units)
    solver_opt{end+1} = 'SI_units';
    solver_opt{end+1} = options.SI_units;
end
%}
if isfield(options,'dde23_options')
    solver_opt{end+1} = 'dde23_options';
    solver_opt{end+1} = options.dde23_options;
end



% Get nunst, index bifurcations
[nunst_branch,~,~,branch.point]=GetStability(branch,...
'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',funcs);


% Find all bifurcations
ind_bif = find(abs(diff(nunst_branch))~=0);
% Find cases where bifurcations occur next to other bifurcations. Note:
% these values are pairs, so we will have to create two lists. First list
% has the first element in the pair and the second list has the second.
% Union these two lists for the indicies of all bifurcations directly
% next to other bifurcations.
ind_elem1_sequential_bif = find(diff(ind_bif)==1);
ind_elem2_sequential_bif = find(diff(ind_bif)==1) + 1;
ind_sequential_bifurcations = union(ind_bif(ind_elem1_sequential_bif), ...
    ind_bif(ind_elem2_sequential_bif));
disp('The following bifurcations were ignored:')
disp(ind_sequential_bifurcations)
% Remove the cases of sequential bifurcations, leaving only 'certified' bif
ind_certified_bif = setdiff(ind_bif,ind_sequential_bifurcations);


% Run the solver on ind_certified_bif & ind_certified_bif+1.
timeSeries_solns = struct;
for ind_val = transpose(ind_certified_bif)
    % Pre-bifurcation element
    savename1 = strcat('tSer_',branch_name,'_BifInd_',num2str(ind_val));
    active_soln_elem1 = solver( branch.point(ind_val).x, timeSpan, ...
        branch.point(ind_val).parameter, ...
        param.tau_fb.index, param.J.index, ...
        solver_opt{:} );
    % Post-bifurcation element
    savename2 = strcat('tSer_',branch_name,'_BifInd_',num2str(ind_val+1));
    active_soln_elem2 = solver( branch.point(ind_val+1).x, timeSpan, ...
        branch.point(ind_val+1).parameter, ...
        param.tau_fb.index, param.J.index, ...
        solver_opt{:} );
    % Make a struct with the solutions for each.
    timeSeries_solns.(savename1) = active_soln_elem1;
    timeSeries_solns.(savename2) = active_soln_elem2;
    

end

if isfield(options,'save')
    save(strcat(datadir_specific,'tSer_atBif_',branch_name),...
        'timeSeries_solns')
end


end

