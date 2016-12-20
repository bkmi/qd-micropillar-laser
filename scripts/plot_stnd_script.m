%% Plot

figure

% Plot each hopf_branch
namesHopfBranches = fieldnames(hopf_branches);
for i = 1:numel(namesHopfBranches)
    % Add each hopf_branch
    if ~any(strcmp('error', ... 
            fieldnames(hopf_branches.(namesHopfBranches{i}))))
        % Only plot hopf_branches that DO NOT have errors
        plot_branch(hopf_branches.(namesHopfBranches{i}), param, ...
            'add_2_gcf', 1, 'color','c')
    end
end


% Plot each fold_branch
namesFoldBranches = fieldnames(fold_branches);
for i = 1:numel(namesFoldBranches)
    % Add each hopf_branch
    if ~any(strcmp('error',...
            fieldnames(fold_branches.(namesFoldBranches{i}))))
        % Only plot fold_branches that DO NOT have errors
        plot_branch(fold_branches.(namesFoldBranches{i}), param, ...
            'add_2_gcf', 1, 'color','r')
    end
    
end


% Plot init_branch
plot_branch(branch_stst, param, ...
            'add_2_gcf', 1, 'color','g', ...
            'axes_indParam', [ ind_feed_phase, ind_feed_ampli ])