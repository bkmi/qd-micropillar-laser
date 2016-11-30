function [ scanned_branch, nunst_scanned_branch ] = alternate_param_scanner( branch_point, funcs, scan_point_count, scan_parm_ind, step_bound_options, min_real_part )
%
%   Input: ( branch_point, funcs, scan_point_count, scan_parm_ind, step_bound_options, min_real_part )
%   
%   step_bound_options = { 'step',1,'max_step',[ind_,1],'newton_max_iterations',10, ...
%                          'min_bound',[ind_,1], 'max_bound',[ind_,2] }

opt_inputs={'extra_condition',1,'print_residual_info',0};
ind_omega = length(branch_point.parameter);
par_cont_ind = [scan_parm_ind, ind_omega];

[scanned_branch,~]=SetupStst(funcs,'contpar',par_cont_ind,'corpar',ind_omega,...
    'x',branch_point.x,'parameter',branch_point.parameter,opt_inputs{:},...
    step_bound_options{:} );

scanned_branch.method.continuation.plot=0;
[scanned_branch,~,~,~]=br_contn(funcs,scanned_branch,scan_point_count);
scanned_branch=br_rvers(scanned_branch);
scanned_branch=br_contn(funcs,scanned_branch,scan_point_count);

scanned_branch.method.stability.minimal_real_part = min_real_part;
[nunst_scanned_branch,~,~,scanned_branch.point]=GetStability(scanned_branch,...
'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',funcs);

end

