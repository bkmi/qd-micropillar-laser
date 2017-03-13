function [  ] = addpath_setup(  )
%This function adds the relevant folders to matlab path.

present_working_directory = pwd;
addpath(strcat(present_working_directory,'/functions/'))
addpath(strcat(present_working_directory,'/functions/numerical_systems/'))
addpath(strcat(present_working_directory,'/scripts/'))
addpath(strcat(present_working_directory,'/BrewerMap/'))
addpath(strcat(present_working_directory, '/dde_biftool_v3.1.1/ddebiftool/')); 
addpath(strcat(present_working_directory, '/dde_biftool_v3.1.1/ddebiftool_extra_psol/'));
addpath(strcat(present_working_directory, '/dde_biftool_v3.1.1/ddebiftool_utilities/'));
addpath(strcat(present_working_directory, '/dde_biftool_v3.1.1/ddebiftool_extra_rotsym'));

end

