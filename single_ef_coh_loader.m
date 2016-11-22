% Helps load data from a previous simulation/continuation for further investigation.

% Select data location
datadir_parent = '../data_qd-micropillar-laser-ddebif/'; %location of data parent folder.
datadir_subfolder = 'monoEF_nondim_J=2.2e-04_FEED_tau=0.8_amp=0.55/'; %location of specific data folder
datadir_specific = strcat(datadir_parent,datadir_subfolder);

% Record options chosen at startup
load(strcat(datadir_specific,'option_choices.mat'))	%load options choices

% DDE23 solver data
load(strcat(datadir_specific,'turnON_TimeSeries.mat'))	%load solver data from turn on time series

% Necessary for DDEBIF continuation
load(strcat(datadir_specific,'parameters.mat')); 	%load parameters before adding omega
load(strcat(datadir_specific,'parameters_index.mat')); 	%load parameters index before adding omega
load(strcat(datadir_specific,'rot_parameters.mat')); 	%load parameters with omega
load(strcat(datadir_specific,'rot_funcs.mat')); 	%load functions
load(strcat(datadir_specific,'unit_system.mat'),'ef_units','time_units','n_units') %load relevant unit names

% Begin loading each, already calculated, branch
load(strcat(datadir_specific,'branch1.mat'));		%load initial branch
load(strcat(datadir_specific,'hopf_branches.mat'));	%load hopf branches
load(strcat(datadir_specific,'fold_branches.mat'));	%load fold brances (and ind_fold)

% Would the user like to overwrite files?
loaded_overwrite_opt = input('\n\nWARNING: You have loaded this data.\nShould scripts overwrite saved results? \n1 = yes \n2 = no \n\n');
% Force user to choose: OVERWRITE or not.
while(1)
  if loaded_overwrite_opt == 1
    saveit = 1; %Save and OVERWRITE
    fprintf('\nScripts will OVERWRITE saved results!!!\n\n')
    break
  elseif loaded_overwrite_opt == 2
    saveit = 2; %Don't save and don't overwrite.
    fprintf('\nScripts will NOT save results!!!\n\n\n')
    break
  end
end

% Clean up
clear('datadir_parent','datadir_subfolder') %Notice how 'datadir_specific' is not cleared.
					    %This is incase the user changes saveit later.