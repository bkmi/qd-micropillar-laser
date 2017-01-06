function [ slices ] = slice_along_branch( branch, funcs, scan_pt_count, ...
    scan_parm_ind, step_bound_options, min_real_part )
%Continue in a new parameter at every point along a branch.
%   Expands a branch into a new parameter along every point in the branch.
%   Input branch info, return 'slices' struct which is a set of
%   continuations along every point in an input branch.
%
%   Input:
%          ( branch, funcs, scan_pt_count, ...
%            scan_parm_ind, step_bound_options, min_real_part )
%
%   Options:
%      step_bound_options = { 'step',1,'max_step',[ind_,1], ...
%                             'newton_max_iterations',10, ...
%                             'min_bound',[ind_,1], 'max_bound',[ind_,2] }


% Create slices struct
slices = struct;

% Create each slice.
for i = 1:length(branch.point)
    [actSlice, actSlice_nunst] = alternate_param_scanner( ...
        branch.point(i), funcs, scan_pt_count, scan_parm_ind, ...
        step_bound_options, min_real_part );
    % Divide behavior into 1s, 10s, 100s
    if i<10
        slices.(strcat('sliceBranch00',num2str(i))) = actSlice;
    elseif i<100
        slices.(strcat('sliceBranch0',num2str(i))) = actSlice;
    else
        slices.(strcat('sliceBranch',num2str(i))) = actSlice;
    end
end

    
end

