%SELECT DDE_BIFTOOL LOCATION
addpath('~/dde_biftool_v3.1.1/ddebiftool/'); 
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_psol/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_utilities/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_rotsym');

%SELECT UNIT SYSTEM
%dim_choice = 1; % dimensional units determined in setup_params
dim_choice = 2; % dimensionless, @Oct 31 2016 the dimensionless unit of time was counting nanoseconds with tau_sp

%SELECT DDEBIF CONTINUATION
continue_choice = 1; % 'Feedback phase: feed_phase'
%continue_choice = 2; % 'Feedback amplitude: feed_ampli'

%HIST VECTOR
hist=[1e-9;0;0;0];


%TIME SECTION (Depends on unit choice!!!)
%feedback/delay params
feed_phase = 0;
feed_ampli = 0.55;
tau_fb 	   = 0.8;	%units set with dim choice
%time bound
min_time = 0;	%units set with dim choice
max_time = 15;	%units set with dim choice


% dde23 solver options
% https://www.mathworks.com/help/matlab/ref/ddeset.html#f81-1031913
%,'RelTol',0.01,'InitialStep', 0.001e-12, 'MaxStep', 0.01e-12, 'OutputFcn',@odeplot,
options = ddeset('RelTol',10^-8) %, 'OutputFcn', @odeplot

% Data output folder (parent)
% The data files will be in a folder named based on the parameter settings at the start of the simulation
datadir = '../data_qd-micropillar-laser-ddebif/';
mkdir(datadir)
