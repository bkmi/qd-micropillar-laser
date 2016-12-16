function [ ] = plot_secondary_continuation(hopf_branches, fold_branches, ...
    nunst_source_branch, ind_hopf, ind_fold, par_names, par_units)
%Plot the hopf and fold branches together on a single plot.
%   Input:
%       hopf_branches
%       fold_branches
%       nunst_source_branch
%       ind_hopf
%       ind_fold
%       par_names
%       par_units
%   Options: (none)


% Make a new figure
figure; clf;
add_to_current_figure = 1; %Yes, plot it all on the same figure.

% Prepare hopf plotting on this figure.
hbranch_nameList = fieldnames(hopf_branches);
hbranch_calcError_nameList = {};

% create colormap based on nunst at the bifurcation point
colors = hsv(max(nunst_source_branch)+1); %rave colors
hbranch_nameList_colors = zeros(length(ind_hopf),3);
for i=1:length(ind_hopf)
  hbranch_nameList_colors(i,:) = colors(nunst_source_branch(ind_hopf(i))+1,:);
end


% Actually plot it
for i=1:length(hbranch_nameList)
    try
        plot_hopf_branch(hopf_branches.(hbranch_nameList{i}),...
            par_names,par_units,add_to_current_figure,hbranch_nameList_colors(i,:))
    catch ME
        switch ME.identifier
            case 'MATLAB:nonExistentField'
                if isfield(hopf_branches.(hbranch_nameList{i}),'error')
                    fprintf(strcat(hbranch_nameList{i}, ...
                        ': Produced an error during calculation.\n'))
                    hopf_branches.(hbranch_nameList{i}).error
                    hbranch_calcError_nameList = [hbranch_calcError_nameList; hbranch_nameList{i}];
                else
                    warning(hbranch_nameList{i},': Has a problem.')
                end
            otherwise
                rethrow(ME)
        end
    end
end

% The legend isn't that useful with so many repeating colors.
%plotted_hbranch_nameList = setdiff(hbranch_nameList,hbranch_calcError_nameList,'stable');
%legend(plotted_hbranch_nameList)

% --

% create colormap based on nunst at the bifurcation point
fbranch_nameList_colors = zeros(length(ind_hopf),3);
for i=1:length(ind_fold)
  fbranch_nameList_colors(i,:) = colors(nunst_source_branch(ind_fold(i))+1,:);
end

% Prepare fold plotting on this figure.
fbranch_nameList = fieldnames(fold_branches);
fbranch_calcError_nameList = {};
for i=1:length(fbranch_nameList)
    try
        plot_fold_branch(fold_branches.(fbranch_nameList{i}),...
            par_names,par_units,add_to_current_figure,fbranch_nameList_colors(i,:))
    catch ME
        switch ME.identifier
            case 'MATLAB:nonExistentField'
                if isfield(fold_branches.(fbranch_nameList{i}),'error')
                    fprintf(strcat(fbranch_nameList{i}, ...
                        ': Produced an error during calculation.\n'))
                    fold_branches.(fbranch_nameList{i}).error
                    fbranch_calcError_nameList = [fbranch_calcError_nameList; fbranch_nameList{i}];
                else
                    warning(fbranch_nameList{i},': Has a problem.')
                end
            otherwise
                rethrow(ME)
        end
    end
end

% This doesn't work because it creates a legend for the hopf bifurcation plot.
%plotted_fbranch_nameList = setdiff(fbranch_nameList,fbranch_calcError_nameList,'stable')
%legend(plotted_fbranch_nameList)

end