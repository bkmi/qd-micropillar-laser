function [ res, J ] = self_rot_cond( point, A_rot )
%Personal version of rot_cond, hardcoded for my system
%   Input:
%       point
%
%   Output:
%       res, ...
%       J

if isfield(point,'x')
    % Generally
    res=0;
    J=p_axpy(0,point,[]);
    J.x=A_rot*point.x;
elseif strcmp(point.kind, 'psol')
    % For psol, there is more in rot_cond
    error('Not yet supported!')
else
    error('?!?!')
end


end

