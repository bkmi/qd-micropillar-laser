% Helps load data from a previous simulation/continuation for further investigation.

% Select data location
datadir_parent = '../data_qd-micropillar-laser-ddebif/'; %location of data parent folder.
datadir_subfolder = 'monoEF_nondim_J=2.2e-04_FEED_tau=0.8_amp=0.55/'; %location of specific data folder
datadir_specific = strcat(datadir_parent,datadir_subfolder);

% DDE23 solver data
load(strcat(datadir_specific,'turnON_TimeSeries.mat'))	%load solver data from turn on time series

% Necessary for DDEBIF continuation
load(strcat(datadir_specific,'parameters.mat')); 	%load parameters before adding omega
load(strcat(datadir_specific,'parameters_index.mat')); 	%load parameters index before adding omega
load(strcat(datadir_specific,'rot_parameters.mat')); 	%load parameters with omega
load(strcat(datadir_specific,'rot_funcs.mat')); 	%load functions
load(strcat(datadir_specific,'unit_system.mat'),'ef_units','time_units','n_units') %load relevant unit names

% Being loading each, already calculated, branch
load(strcat(datadir_specific,'branch1.mat')); 	%load initial branch (phase, in this case)