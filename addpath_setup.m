function [  ] = addpath_setup(  )
%This function adds the relevant folders to matlab path.

present_working_directory = pwd;

% Removed becuase I am putting my rot project in its own git project
% addpath(strcat(present_working_directory,'/rot/'))
% If you aren't me, direct this part of the path towards your multi_rot_sym
% extension to DDE-BIFTOOL.
addpath('/home/bkmiller/qd-micropillar-laser-project/ddebiftool_multirot')

addpath(present_working_directory)
addpath(strcat(present_working_directory,'/functions/'))
addpath(strcat(present_working_directory,'/functions/numerical_systems/'))
addpath(strcat(present_working_directory,'/scripts/'))
addpath('~/dde_biftool_v3.1.1/ddebiftool/'); 
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_psol/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_utilities/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_rotsym');

end

