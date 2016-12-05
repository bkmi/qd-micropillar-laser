function [ dde23_soln ] = solver( hist, timeSpan, params_atStartPoint, ...
    ind_tau_fb, ind_J, varargin )
%Takes in parameters from the experimental setup and returns a time
%series plot starting at the values given by a "hist" vector. If "hist" is
%zero, except for electric field, then this is a "turn on" timeseries.
%   Options:
%       'plot' = 1,0
%           If you choose to plot = 1 then the solver will output the
%           solver plot. These are timeseries with ef, rho, and n.
%       'SI_units' = 1, 0
%           The solver will use dimensionless Ef, rho, and n units by
%           by default, or when 'SI_units' == 0. Using 'SI_units' == 1
%           casues the solver to use dimensional outputs in SI units.
%       'dde23_options' = ddeset('RelTol',10^-8), ...;
%           Calling this flag will let you change the precision, behavior
%           of the dde23 solver. The default is written above. For more
%           information check out the following link:
%         https://www.mathworks.com/help/matlab/ref/ddeset.html#f81-1031913
%       'save' = {'directory','dde23_soln_name','unit_system_name'}
%           The solver will save the dde23_soln as 'dde23_soln_name' in 
%           'directory'. It will also try to append unit_system_name with
%           the relevant fields. If there is no unit_system to append, it
%           will make one. If you set either 'dde23_soln_name' or
%           'unit_system_name' to 0 then the solver will not save that
%           value.


% Add functions folder to the path
addpath('./functions/')


% Create an options struct from varargin, preserves cell arrays.
for i=1:length(varargin)
    if iscell(varargin{i})
        varargin{i}=varargin(i);
    end
end
options=struct(varargin{:});
% Create a few default options.
if ~isfield(options,'SI_units')
    options.SI_units = 0;
end
if ~isfield(options,'plot')
    options.plot = 0;
end
if ~isfield(options,'dde23_options')
    options.dde23_options = ddeset('RelTol',10^-8);
elseif ~isempty(setdiff(fieldnames(options.dde23_options), ...
        fieldnames(ddeset())))
    error('You did not use ddeset() for dde23_options correctly.')
end


% Set par = params_atStartPoint
par = params_atStartPoint;



% Organize behavior from options
% DIMENSION HANDLER
if options.SI_units == 1
    %define solver ready func, SI_units
    sys_4solver=@(x)qd_1ef_sys(x(1,1)+1i*x(2,1),x(1,2)+1i*x(2,2), ...
        x(3,1),x(3,2),x(4,1),x(4,2), ... 
        par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9), ...
        par(10),par(11),par(12),par(13),par(14),par(15),par(16), ...
        par(17),par(18),par(19),par(20),par(21),par(22),par(23), ...
        par(24),par(25),par(26),par(27),par(28),par(29));
    %Termwise function defined for inspection.
    termwise_sys=@(x)qd_1ef_sys_TERMWISE(x(1,1)+1i*x(2,1), ...
        x(1,2)+1i*x(2,2),x(3,1),x(3,2),x(4,1),x(4,2), ... 
        par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9),...
        par(10),par(11),par(12),par(13),par(14),par(15),par(16),par(17),...
        par(18),par(19),par(20),par(21),par(22),par(23),par(24),par(25),...
        par(26),par(27),par(28),par(29));
    fprintf('Solver is using SI_units for output.\n')
    ef_units = '(V/m)';
    time_units = 's';
    n_units = 'm^{-2}';

elseif options.SI_units == 0
    %define solver ready func, dimensionless
    sys_4solver=@(x)qd_1ef_sys_nondim(x(1,1)+1i*x(2,1),x(1,2)+1i*x(2,2),...
        x(3,1),x(3,2),x(4,1),x(4,2), ... 
        par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9),...
        par(10),par(11),par(12),par(13),par(14),par(15),par(16),...
        par(17),par(18),par(19),par(20),par(21),par(22),par(23),...
        par(24),par(25),par(26),par(27),par(28),par(29));
    %Termwise function defined for inspection.
    termwise_sys=@(x)qd_1ef_sys_nondim_TERMWISE(x(1,1)+1i*x(2,1),...
        x(1,2)+1i*x(2,2),x(3,1),x(3,2),x(4,1),x(4,2), ... 
        par(1),par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9),...
        par(10),par(11),par(12),par(13),par(14),par(15),par(16),par(17),...
        par(18),par(19),par(20),par(21),par(22),par(23),par(24),par(25),...
        par(26),par(27),par(28),par(29));

    fprintf('Solver is using dimensionless units for output.\n')
    ef_units = '(\epsilon_{ss} \epsilon_{tilda})^{-1/2}';
    time_units = '(\tau_{sp})';
    n_units = '(S^{in} \tau_{sp})^{-1}';

else
    error('Error selecting output in SI_units or non-dimensional units.')

end


% Setup/use dde23 solver
lags = params_atStartPoint(ind_tau_fb); % lags == feedback time
fprintf(strcat('History vector, hist=',mat2str(hist)))
dde23_soln = dde23(@(t,y,z)sys_4solver([y,z]),...
    lags,hist,timeSpan, options.dde23_options);


% Plot, if necessary
if options.plot == 1
    plot_solver( dde23_soln, params_atStartPoint(ind_J), hist, ...
        time_units, ef_units, n_units )
end


% Save, if necessary
if isfield(options,'save')
    datadir_specific = options.save{1};
    dde23_save_name = options.save{2};
    unit_system_name = options.save{3};
    if dde23_save_name ~= 0
        save(strcat(datadir_specific,dde23_save_name),'dde23_soln')
    end
    if (any(unit_system_name ~= 0) && (exist(strcat(datadir_specific, ...
            unit_system_name),'file') == 2))
        save(strcat(datadir_specific,unit_system_name),...
            'ef_units','time_units','n_units','-append')
    elseif unit_system_name ~= 0
        save(strcat(datadir_specific,unit_system_name),...
            'ef_units','time_units','n_units')
    end
end

end