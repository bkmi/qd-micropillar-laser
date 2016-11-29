% Helps load data from a previous simulation/continuation for further investigation.

% Prepare matlab
present_working_directory = pwd;
addpath(strcat(present_working_directory,'/functions/'))
clear('present_working_directory')
addpath('~/dde_biftool_v3.1.1/ddebiftool/'); 
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_psol/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_utilities/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_rotsym');

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
    fprintf('\nScripts will NOT save results!!!\n\n')
    break
  end
end

% Clean up
clear('datadir_parent','datadir_subfolder') %Notice how 'datadir_specific' is not cleared.
					    %This is incase the user changes saveit later.|



% Would the user like to plot all?
plot_all_opt = 0;
% Force user to choose: plot or not.
while ~or(plot_all_opt==1,plot_all_opt==2)
  plot_all_opt = input('Would you like to output all relevant plots? \n1 = yes \n2 = no \n\n');
end

switch plot_all_opt
  case 1 %Plot
    fprintf('\nPlotting...\n\n')
    %Plot from dde23 solver
    plot_solver( turnON_TimeSeries, J, hist, time_units, ef_units, n_units )
    
    %Plot ef versus continued parameter
    plot_ef_contParam( branch1, nunst_branch1, ind_hopf, J, ef_units, par_names, par_units )
    
    %Plot omega versus continued parameter
    plot_omega_contParam( branch1, nunst_branch1, ind_hopf, ind_omega, par_names, par_units )
    
    %Plot rho versus omega
    plot_rho_omega( branch1, nunst_branch1, ind_hopf, ind_omega )
    
    %Plot secondary continuation branches (hopf + fold)
    plot_secondary_continuation(hopf_branches,fold_branches,nunst_branch1,ind_hopf,ind_fold,par_names,par_units)
    
  case 2 %Don't plot
    fprintf('\nNot plotting.\n\n')
end