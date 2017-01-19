function [ res, J ] = self_rot_cond( point, A_rot )
%Personal version of rot_cond, hardcoded for my system
%   Input:
%       point
%
%   Output:
%       res, ...
%       J

if isa(A_rot,'double')
    % Given only one rotation matrix!
    if isfield(point,'x')
        % Generally
        res=0; % residual is always zero
        J=p_axpy(0,point,[]); % create a 'zero' point, used as the deriv
        J.x=A_rot*point.x; % Update zero point with deriv = Arot*orig_point
    elseif strcmp(point.kind, 'psol')
        % For psol, there is more in rot_cond
        error('Not yet supported!')
    else
        error('?!?!')
    end
elseif isa(A_rot,'cell')
% THIS ISN'T CORRECT. YOU HAVE TO GET THE ROTATION FROM EACH MATRIX + THE J
% FROM EACH MATRIX
%     % Given more rotation matricies!
%     TOTAL_rot = zeros(size(A_rot{1}));
%     for i = 1:numel(A_rot) %number of elements of okay
%         TOTAL_rot = TOTAL_rot + A_rot{i};
%     end
    
    
    % Later on, somewhere in p_correc/correct_ini DDE BIF-TOOL NEEDS
    % another jacobian column(or row??) to continue each new parameter.
    % I.e. one for
    % omega1, one for omega2, etc...
    % 
    % When the rot_cond func calls the orig_sys_cond func then it generates
    % another jacobian column(row?) for each one. For reference I put the
    % code below:
    % [userres,userJ]=usercond(userpoint);
    % J=[userJ(:);Jphas]; (Jphas == This J from rot_cond)
    
    
    if isfield(point,'x')
        % Generally
        res_one=0; % residual is always zero
        res_two=0;
        % First matrix
        J_one=p_axpy(0,point,[]); % create a 'zero' point, used as the deriv
        J_one.x=A_rot{1}*point.x; % Update zero point with deriv = Arot*orig_point
        % Second Matrix
        J_two=p_axpy(0,point,[]); % create a 'zero' point, used as the deriv
        J_two.x=A_rot{2}*point.x; % Update zero point with deriv = Arot*orig_point
        
    elseif strcmp(point.kind, 'psol')
        % For psol, there is more in rot_cond
        error('Not yet supported!')
    else
        error('?!?!')
    end
    
    res = [res_one;res_two];
    J = [J_one; J_two];
    
end

end

