function [ timeSeries_atBranchPt ] = timeSeries_atBranchPt( ...
    point, timeSpan, param, ...
    varargin )
%This function takes a point on a DDEBIF branch and produces a time series
%with parameters from that point. By default, the function produces a time 
%series as if the system was in a stead state at those parameters.
%   Inputs:
%       point, ...
%       timeSpan, ...
%       param, ...
%       varargin
%
%   Outputs:
%       timeSeries_atBranchPt
%
%   Options:
%       'turn_on' = 0, 1
%           Instead of creating a time series along a steady state, the
%           solver will create a turn_on time series.
%       'plot' = 1,0
%           If you choose to plot = 1 then the solver will output the
%           solver plot. These are timeseries with ef, rho, and n.
%       'dde23_options' = ddeset('RelTol',10^-8), ...;
%           Calling this flag will let you change the precision, behavior
%           of the dde23 solver. The default is written above. For more
%           information check out the following link:
%         https://www.mathworks.com/help/matlab/ref/ddeset.html#f81-1031913
%       'save_name' = 'dde23_soln_name'
%           The solver will save the dde23_soln as 'dde23_soln_name' in 
%           a datadir_specific given by master_options. It will overwrite.
%
%   Master Options:
%       'save' = 0, 1
%           By default, this is set to 0. When 'save' = 0, the function
%           does not try to save anything. When 'save' = 1, the function 
%           tries to save ________.
%       'datadir_specific' = '../data_qd-micropillar-laser-ddebif/'
%           By default, this is set as above.
%       'dimensional' = 0, 1
%           By default, this is set to 0. When 'dimensional' = 0, the
%           function applies a non-dimensionalized system. When
%           'dimensional' = 1, the function applies a dimensionalized
%           system.


%% Defaults + InputParser + Organize Behavior

p = inputParser;

% General option defaults
p.addParameter('turn_on', 0)
p.addParameter('plot', 0)
p.addParameter('dde23_options', ddeset())%ddeset('RelTol',10^-8)
p.addParameter('save_name', 'timeSeries_atBranchPt')

% Master option defaults
p.addParameter('save',0)
p.addParameter('datadir_parent','../data_qd-micropillar-laser-ddebif/')
p.addParameter('datadir_specific','../data_qd-micropillar-laser-ddebif/')
p.addParameter('dimensional',0)

% Parse, Make options
parse(p,varargin{:})
options = p.Results;


%% Solver Prep + Soln
% Create hist
if options.turn_on == 0
    % Create hist like a steady state.
    hist = @(t)circularEvolution(point.x,... 
        point.parameter(param.omega.index), ...
        t);
    %hist = point.x;
    
elseif options.turn_on == 1
    % Create a static, low valued hist. I.e. turn on
    hist = [1e-9;0;0;0];
    
end
whos hist
% Actually solve
timeSeries_atBranchPt = solver( ...
    hist, ...
    timeSpan, ...
    param, ...
    'par_overwrite', point.parameter, ...
    'dde23_options', options.dde23_options, ...
    'plot', options.plot, ...
    'save_name', options.save_name, ...
    'save', options.save, ...
    'datadir_specific', options.datadir_specific, ...
    'dimensional', options.dimensional );


end

