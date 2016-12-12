function [nunst,dom,triv_defect,points] = GetRotStability( branch, funcs )
%Expand on DDEBIF GetStability. The options to account for rotating waves
%are all checked when using this function.
%
%This is with the follow options marked:
%   GetStability(branch,...
%       'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',funcs);
%
%   Output:
%       nunst
%       dom
%       triv_defect
%       points

[nunst,dom,triv_defect,points] = GetStability(branch, ...
    'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',funcs);


end

