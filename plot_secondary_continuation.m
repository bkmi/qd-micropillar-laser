function [ ] = plot_secondary_continuation(hopf_branches, fold_branches, par_names,par_units)
% Plot a hopf branch.
%   add_2_gcf = 1 -> Adds plot to current figure.
%   add_2_gcf = 0 or Not Called -> New figure.


% Make a new figure
figure; clf;
add_to_current_figure = 1; %Yes, plot it all on the same figure.

% Prepare hopf plotting on this figure.
hbranch_nameList = fieldnames(hopf_branches);
colors = parula(length(hbranch_nameList));
for i=1:length(hbranch_nameList)
    try
        plot_hopf_branch(hopf_branches.(hbranch_nameList{i}),...
            par_names,par_units,add_to_current_figure,colors(i,:))
    catch ME
        switch ME.identifier
            case 'MATLAB:nonExistentField'
                if isfield(hopf_branches.(hbranch_nameList{i}),'error')
                    fprintf(strcat(hbranch_nameList{i}, ...
                        ': Produced an error during calculation.\n'))
                    hopf_branches.(hbranch_nameList{i}).error
                else
                    warning(hbranch_nameList{i},': Has a problem.')
                end
            otherwise
                rethrow(ME)
        end
    end
end

% Prepare fold plotting on this figure.
fbranch_nameList = fieldnames(fold_branches);
colors = copper(length(fbranch_nameList));
for i=1:length(fbranch_nameList)
    try
        plot_hopf_branch(fold_branches.(fbranch_nameList{i}),...
            par_names,par_units,add_to_current_figure,colors(i,:))
    catch ME
        switch ME.identifier
            case 'MATLAB:nonExistentField'
                if isfield(fold_branches.(fbranch_nameList{i}),'error')
                    fprintf(strcat(fbranch_nameList{i}, ...
                        ': Produced an error during calculation.\n'))
                    fold_branches.(fbranch_nameList{i}).error
                else
                    warning(fbranch_nameList{i},': Has a problem.')
                end
            otherwise
                rethrow(ME)
        end
    end
end

end