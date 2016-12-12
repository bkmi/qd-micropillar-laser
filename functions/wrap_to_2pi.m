function [ out_branch_OR_struct ] = wrap_to_2pi( branch, ...
    ind_wrap, varargin )
%Wraps the parameter in the index to 2pi.
%   Input:
%       branch,
%       ind_wrap
%
%   Options:
%       struct_output_set, {  branch_name, wrapped_branches_struct }
%           Outputs an updated wrapped_branches_struct with the new wrapped
%           branch as fieldname = (branch_name) inside 
%           wrapped_branches_struct

% Create an options struct from varargin, preserves cell arrays.
for i=1:length(varargin)
    if iscell(varargin{i})
        varargin{i}=varargin(i);
    end
end
options=struct(varargin{:});

% Behavior sorting.
if isfield(options,'struct_output_set')
    % When you want to return a struct with a new branch inside
    branch_name = options.struct_output_set{1};
    wrapped_branches_struct = options.struct_output_set{2};
    
    for i = 1:length(branch.point)
        branch.point(i).parameter(ind_wrap) = ...
            mod(branch.point(i).parameter(ind_wrap),2*pi);
    end

    wrapped_branches_struct.(branch_name) = branch;
    
    out_branch_OR_struct = wrapped_branches_struct;
    
else
    % When you want to return a branch
    
    for i = 1:length(branch.point)
        branch.point(i).parameter(ind_wrap) = ...
            mod(branch.point(i).parameter(ind_wrap),2*pi);
    end
    
    out_branch_OR_struct = branch;
    
end



end

