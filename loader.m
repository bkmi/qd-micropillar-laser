function [ fileData ] = loader( varargin )
%Load data from the data directory.
%   The loader will load all save files from a folder.
%   If you call it with a single output that output will be a struct with
%   all of the saved data.
%
%   Options:
%       'datadir_parent' = str (location of parent datadir)
%           This is unnecessary if you called datadir_specific. By default
%           the directory '../data_qd-micropillar-laser-ddebif/' is chosen.
%       'datadir_specific' = str (location of the datadir you want to load)
%           This dir will be tried before trying datadir_parent.
%       'exclude' = {str, str, ...} (cell array of files not to include)
%           These files will not be loaded.
%       'include' = {str, str, ...} (cell array of files include)
%           These files will be loaded. Nothing else will be loaded from
%           the folder.
%       


% Create an options struct from varargin, preserves cell arrays.
for i=1:length(varargin)
    if iscell(varargin{i})
        varargin{i}=varargin(i);
    end
end
options=struct(varargin{:});
% Make a blank exclude list if none is chosen
if ~isfield(options,'exclude')
    options.exclude = {};
end


% Organize behavior from options
% Check for datadir_specific
if isfield(options,'datadir_specific') && isdir(options.datadir_specific)
    datadir_specific = options.datadir_specific;
elseif isfield(options,'datadir_specific') && ~isdir(options.datadir_specific)
    warning(strcat(options.datadir_specific, ': Is not a dir. Using regular behavior.'))
end
% Check for datadir_parent
if isfield(options,'datadir_parent') && isdir(options.datadir_parent) && ~exist('datadir_specific','var')
    datadir_parent = options.datadir_parent;
elseif isfield(options,'datadir_parent') && ~isdir(options.datadir_parent) && ~exist('datadir_specific','var')
    warning(strcat(options.datadir_parent, ': Is not a dir. Using regular behavior.'))
end


% Select data folder location
if ~(exist('datadir_specific','var') || exist('datadir_parent','var'))
    datadir_parent = '../data_qd-micropillar-laser-ddebif/'; %location of default data parent folder.
end
if ~exist('datadir_specific','var')
    directory = dir(datadir_parent);
    sub_all_list = {directory.name};
    which_are_folders = [directory.isdir];
    subfolder_list = sub_all_list(which_are_folders);
    [selection,exit_box] = listdlg('PromptString','Select a folder:',...
                                            'SelectionMode','single',...
                                            'ListString',subfolder_list);
    datadir_subfolder = strcat(subfolder_list{selection},'/');
    if exit_box==0
        error('You did not choose a folder. Nothing was loaded')
    end
    datadir_specific = strcat(datadir_parent,datadir_subfolder);
end


% Prepare matlab
present_working_directory = pwd;
addpath(strcat(present_working_directory,'/functions/'))
addpath('~/dde_biftool_v3.1.1/ddebiftool/'); 
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_psol/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_utilities/');
addpath('~/dde_biftool_v3.1.1/ddebiftool_extra_rotsym');


% Load
datadir = dir(datadir_specific);
fileIndex = find(~[datadir.isdir]);
% Load only 'included' things
if isfield(options,'include')
    names = {datadir.name};
    fileNames = names(fileIndex);
    for i = 1:length(options.include)
        include_fileName = options.include{i};
        if any(strcmp(include_fileName,fileNames))
            try
                data.(include_fileName(1:end-4)) = load(strcat(datadir_specific,include_fileName));
                disp(include_fileName);
            catch ME
                switch ME.identifier
                    case 'MATLAB:load:numColumnsNotSame'
                        warning(strcat(include_fileName,': Failed to load. MATLAB:load:numColumnsNotSame'))
                    otherwise
                        rethrow(ME)
                end
            end
        elseif ~any(strcmp(include_fileName,fileNames))
            warning(strcat(include_fileName,': No matches to that filename.'))
        end
    end
else
    % Load everything
    for i = 1:length(fileIndex)
        fileName = datadir(fileIndex(i)).name;
        if ~any(strcmp(fileName, options.exclude))
            try
                data.(fileName(1:end-4)) = load(strcat(datadir_specific,fileName));
            catch ME
                switch ME.identifier
                    case 'MATLAB:load:numColumnsNotSame'
                        warning(strcat(fileName,': Failed to load. MATLAB:load:numColumnsNotSame'))
                    otherwise
                        rethrow(ME)
                end
            end
        else
            warning(strcat(fileName,': Was excluded.'))
        end
    end
end


% Display data list aka files names.
fprintf('\n\n\n\nFiles loaded:\n')
disp(data)
fprintf('\n\n')

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
% Transfer to data file, along with datadir
data.saveit = struct;
data.saveit.saveit = saveit;
data.datadir_specific = struct;
data.datadir_specific.datadir_specific = datadir_specific;



% Did they call with an output?
switch nargout
    case 0 % No output arguments, load into workspace.
    % Bring it all into the main workspace
    savefileNames = fieldnames(data);
    for i=1:length(fieldnames(data))
        varNames = fieldnames(data.(savefileNames{i}));
        for j=1:length(varNames)
            assignin('base', varNames{j}, data.(savefileNames{i}).(varNames{j}))
        end
    end
    case 1 % They called with an output arg, don't load into workspace
        fileData = data;
    otherwise
        error('Use no output to load into workspace, one output to load into argument')
end


end

