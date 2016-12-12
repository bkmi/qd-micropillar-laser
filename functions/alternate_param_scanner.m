function [scanned_branch, nunst_scanned_branch]=alternate_param_scanner(...
    branch_point, funcs, scan_point_count, scan_parm_ind, ...
    min_real_part, step_bound_options, varargin )
%Scans along a new parameter starting at any branch point.
%   Input: 
%       branch_point
%       funcs
%       scan_point_count
%       scan_parm_ind
%       min_real_part
%       step_bound_options
%           step_bound_options={'step',1,'max_step',[ind_,1], ...
%                               'newton_max_iterations',10, ...
%                               'min_bound',[ind_,1], 'max_bound',[ind_,2]}
%   Output:
%       scanned_branch
%           New stst branch starting from that point moving in
%           scan_parm_ind direction.
%
%       nunst_scanned_branch
%           nunst for scanned_branch.
%
%
%   Options:
%       'plot_prog' = 0, 1
%           Plot progress? Yes or no.
%

% Create an options struct from varargin, preserves cell arrays.
for i=1:length(varargin)
    if iscell(varargin{i})
        varargin{i}=varargin(i);
    end
end
options=struct(varargin{:});

% Setup defaults and behavior sorting.
if ~isfield(options,'plot_prog')
    options.plot_prog = 0;
elseif options.plot_prog==1
    figure; clf;
end

opt_inputs={'extra_condition',1,'print_residual_info',0};
ind_omega = length(branch_point.parameter);
par_cont_ind = [scan_parm_ind, ind_omega];

[scanned_branch,~]=SetupStst(funcs,'contpar',par_cont_ind,...
    'corpar',ind_omega,...
    'x',branch_point.x,'parameter',branch_point.parameter,opt_inputs{:},...
    step_bound_options{:} );

scanned_branch.method.continuation.plot=options.plot_prog;
[scanned_branch,~,~,~]=br_contn(funcs,scanned_branch,scan_point_count);
scanned_branch=br_rvers(scanned_branch);
scanned_branch=br_contn(funcs,scanned_branch,scan_point_count);

scanned_branch.method.stability.minimal_real_part = min_real_part;
[nunst_scanned_branch,~,~,scanned_branch.point]=GetStability(scanned_branch,...
'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',funcs);

end

