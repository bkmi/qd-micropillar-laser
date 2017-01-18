function [ y ] = self_rot_rhs(xx,p,A,expA,user_rhs,user_tau,isvec)
%My own version of the right hand side eqn.
%   Input:
%       xx, ...
%       p, ...
%       A, ...
%       expA, ...
%       user_rhs, ...
%       user_tau, ...
%       isvec
%   Output:
%       y

%% right-hand side in rotating coordinates
%
% (c) DDE-BIFTOOL v. 3.1.1(20), 11/04/2014
%
omega=p(end);
userpar=p(1:end-1);
xxrot=xx;
tau_ind=user_tau();
if ~isvec
    for i=2:size(xx,2)
        xxrot(:,i)=expA(-omega*p(tau_ind(i-1)))*xxrot(:,i);
    end
else
    dim=size(xxrot,1); % Number of rows
    nvec=size(xxrot,3); % Number of 'sheets' -- vectorized
    for i=2:size(xx,2) % 2:(number of columns)
%         xxrot(:,i,:) % all rows, second column, all pages 
%         expA(-omega*p(tau_ind(i-1))) %expA @ tau_fb1
%         reshape(xxrot(:,i,:),dim,nvec) % Turn multiple sheets into a 2d matrix
        xxrot(:,i,:)=expA(-omega*p(tau_ind(i-1)))*reshape(xxrot(:,i,:),dim,nvec);
        % multiply the matricies and move the resulting columns into the
        % relevant page.
        % 
        % The whole process extracted the second column from each page, did
        % the multiplication, then put each multiplied second column back
        % where it came from.
    end
end
y0=user_rhs(xxrot,userpar); % calculate: given new, rotated 2nd column
% y0 == f(y(t),exp(-A*omega*tau1)*y(t-tau1),...)


% A*omega*reshape(xxrot(:,1,:),[dim,nvec])
% This thing is the -A*w*y(t) part

% reshape(A*omega*reshape(xxrot(:,1,:),[dim,nvec]),[dim,1,nvec])
% This thing puts it back into pages

y=y0-reshape(A*omega*reshape(xxrot(:,1,:),[dim,nvec]),[dim,1,nvec]);

%assignin('base','sample',{xx,p,A,expA,user_rhs,user_tau,isvec})

end

