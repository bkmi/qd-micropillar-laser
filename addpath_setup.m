function [  ] = addpath_setup(  )
%This function adds the relevant folders to matlab path.
%% My files

present_working_directory = pwd;
addpath(present_working_directory)

addpath(strcat(present_working_directory,'/functions/'))
addpath(strcat(present_working_directory,'/functions/numerical_systems/'))
addpath(strcat(present_working_directory,'/scripts/'))

%% DDE-BIFTOOL
addpath(strcat(present_working_directory,'ddebiftool_multirot/')) % Multi_rot
addpath('~/dde_biftool_v3.1.1/ddebiftool/'); 
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_psol/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_utilities/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_rotsym');

end

