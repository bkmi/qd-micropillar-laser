%simulation parameter setup

%prepare matlab
clear;                           % clear variables
close all;                       % close figures
present_working_directory = pwd
addpath(strcat(present_working_directory,'/functions/'))
clear('present_working_directory')

%Options are important, read them.
single_ef_coh_options;

if saveit == 1
  datadir_exist = exist(datadir);
    if datadir_exist == 0
      mkdir(datadir)
    elseif datadir_exist == 7
    else
      error('datadir variable does not make sense. Choose a new directory name in options.')
    end
  clear('datadir_exist')
  fprintf(strcat('Work saved in:\n', datadir, '\n'))
elseif saveit == 2
  fprintf('Work will NOT be saved. \n')
else
  error('Choose a saveit setting in options!!')
end
  
%define indicies
ind_kappa_s     = 1;
ind_kappa_w     = 2;
ind_mu_s        = 3;
ind_mu_w        = 4;
ind_epsi_ss     = 5;
ind_epsi_ww     = 6;
ind_epsi_sw     = 7;
ind_epsi_ws     = 8;
ind_beta        = 9;
ind_J_p         = 10;
ind_eta         = 11;
ind_tau_r       = 12;
ind_S_in        = 13;
ind_V           = 14;
ind_Z_QD        = 15;
ind_n_bg        = 16;
ind_tau_sp      = 17;
ind_T_2         = 18;
ind_A           = 19;
ind_hbar_omega	= 20;
ind_epsi_tilda	= 21;
ind_J           = 22;
ind_feed_phase  = 23;
ind_feed_ampli  = 24;
ind_tau_fb      = 25;
ind_epsi0	= 26;
ind_hbar 	= 27;
ind_e0 		= 28;
ind_c0 		= 29;


%% --


%define params in kg, m, s aka SI UNITS.
%general constants, these are the parameters passed to the par vector
epsi0 = 8.85e-12;		%F m^-1 == J V^-2 m^-1
hbar = 6.58e-16;		%Js
e0 = 1.6e-19;			%C
c0 = 3.0e8;			%m s^-1

%table 1 params
kappa_s    = 0.039*(1/1e-12);	%ps^-1 -> 1/s
kappa_w    = 0.041*(1/1e-12);	%ps^-1 -> 1/s
mu_s 	   = 3.70*(1e-9*e0);	%nm * e0 -> m*C
mu_w 	   = 3.75*(1e-9*e0);	%nm * e0 -> m*C
epsi_ss    = 70e-10;		%m^2 A^-1 V-^1
epsi_ww    = 50e-10;		%m^2 A^-1 V^-1
epsi_sw    = 160e-10;		%m^2 A^-1 V^-1
epsi_ws    = 150e-10;		%m^2 A^-1 V^-1
beta	   = 5.6e-3;
J_p 	   = 42.5*1e-6;		%microAmps -> Amps
eta 	   = 1.28e-3;
tau_r 	   = 150*(1e-12); 	%ps -> s
S_in 	   = 10^(-16)*(1/1e-12);%m^2 ps^-1 -> m^2 s^-1
V 	   = 6.3*(1e-6)^3; 	%micro m^3 -> m^3
Z_QD 	   = 110;
n_bg 	   = 3.34;
tau_sp 	   = 1*(1e-9);		%ns -> s
T_2 	   = 0.33*(1e-12); 	%ps -> s
A 	   = 3.14*(1e-6)^2; 	%micro m^2 -> m^2
hbar_omega = 1.38*(1.6e-19); 	%eV -> J
epsi_tilda = epsi0*n_bg*c0;
%continued param in paper
J	   = 2.5*90*(1e-6); 	%microAmps -> Amps (2.5 * Threshold. Threshold from Redlich paper, 2.5 from ott10)
%current is always reported in amps for the folder name!!
param_units = 'SI units used in definding parameters.';


% --


%create parameter array called par
par = [kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, beta, J_p, ...
      eta, tau_r, S_in, V, Z_QD, n_bg, tau_sp, T_2, A, hbar_omega, epsi_tilda, J, ...
      feed_phase, feed_ampli, tau_fb, epsi0, hbar, e0, c0];

      
% --



%% Determine name of folder with relevant parameters.

% mono mode (single) electric field
mode_report = 'monoEF_';

% report dimensionality
if dim_choice == 1
  dimension_report = 'dim_'; % dimensional units
elseif dim_choice == 2
  dimension_report = 'nondim_'; % non-dimensional units
else
  error('make a choice about units in options');
end

% report current IN AMPS
current_report = strcat('J=',num2str(J,'%1.1e'),'_');

% report feedback params
feed_tau_report = strcat('tau=',num2str(tau_fb),'_');
feed_amp_report = strcat('amp=',num2str(feed_ampli));

% Folder shall be named below:
datadir_subfolder = strcat(datadir,mode_report,dimension_report,current_report,'FEED_',feed_tau_report,feed_amp_report,'/');

% Make user confirm overwrite
warning('error', 'MATLAB:MKDIR:DirectoryExists'); % set warnings to errors.
try
    mkdir(datadir_subfolder);
catch what_error
  switch what_error.identifier
    case 'MATLAB:MKDIR:DirectoryExists'
      while(1)
	overwrite = input('\n\nWARNING: Directory already exists, would you like to overwrite data? \n1 = yes \n2 = no \n\n');
	if overwrite == 1
	  warning('On', 'MATLAB:MKDIR:DirectoryExists'); % reset warnings
	  break
	elseif overwrite == 2
	  warning('On', 'MATLAB:MKDIR:DirectoryExists'); % reset warnings
	  fprintf('\n\nYou have chosen not to overwrite the files. \nThe program WILL NOT SAVE.\n\n\n')
	  saveit = 2; %turn off saving
	  break
	end
      end
    otherwise
      rethrow(what_error)
  end
end
clear('overwrite', 'what_error')


% --


%% Make directory and clean up.
if saveit == 1
  %% create a folder named with relevant parameters
  fprintf(strcat('Subfolder:\n', datadir_subfolder,'\n'))
  
  
  % Save parameter index
  save(strcat(datadir_subfolder,'parameters_index.mat'),'ind_kappa_s','ind_kappa_w','ind_mu_s', ...
	'ind_mu_w','ind_epsi_ss','ind_epsi_ww','ind_epsi_sw',...
	'ind_epsi_ws','ind_beta','ind_J_p','ind_eta','ind_tau_r',...
	'ind_S_in','ind_V','ind_Z_QD','ind_n_bg','ind_tau_sp',...
	'ind_T_2','ind_A','ind_hbar_omega','ind_epsi_tilda','ind_J',...
	'ind_feed_phase','ind_feed_ampli','ind_tau_fb','ind_epsi0',...
	'ind_hbar','ind_e0','ind_c0')
  % Save parameters
  save(strcat(datadir_subfolder,'parameters.mat'),'kappa_s','kappa_w','mu_s', ...
	'mu_w','epsi_ss','epsi_ww','epsi_sw',...
	'epsi_ws','beta','J_p','eta','tau_r',...
	'S_in','V','Z_QD','n_bg','tau_sp',...
	'T_2','A','hbar_omega','epsi_tilda','J',...
	'feed_phase','feed_ampli','tau_fb','epsi0',...
	'hbar','e0','c0','par')
  % Save unit system
  if dim_choice == 1 %dimensional units used in solver
    calc_units = 'Dimensional units used in calculations i.e. solver and bifurcations.';
  elseif dim_choice == 2 %non-dimensional units used in solver
    calc_units = 'Non-dimensional units used in calculations i.e. solver and bifurcations.';
  else
    calc_units = 'No information was given regarding the use of dimensional or non-dimensional units in options.';
    warning('No information was given regarding the use of dimensional or non-dimensional units in options. \n This is recorded.');
  end
  
  % Save unit system
  save(strcat(datadir_subfolder,'unit_system.mat'),'param_units','calc_units')
  % Save options
  save(strcat(datadir_subfolder,'option_choices.mat'),'continue_choice','dim_choice')

elseif saveit == 2
else
  error('Choose a saveit setting in options!!')
end

clear('mode_report', 'dimension_report', 'current_report', 'feed_tau_report', 'feed_amp_report')


