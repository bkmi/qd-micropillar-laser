%% Create initial branch

% Setup parameters, save them
setup_params('save',1,'feed_ampli',0.08)

% Create and save turn on time series
dde23_soln = solver([1e-9;0;0;0], [0,20], param, master_options);

% Create initial branch
[branch_stst, nunst_branch_stst, ind_fold, ind_hopf] = ... 
    init_branch(funcs, ...
    dde23_soln.y(:,end), ind_feed_phase, 750, param, ...
    'max_step',[ind_feed_phase, (1.25)*pi/64], ...
    'max_bound',[ind_feed_phase, 8*pi], ... 
    master_options);


%% Create structs for fold_branches and hopf_branches
% Fold
fold_branches = struct;
for i = 1:length(ind_fold)
    fold_active_branch_name = ...
        strcat('f',num2str(i),'branch');

    try
        fbranch = ...
            bifurContin_FoldHopf( ...
            funcs, ... 
            branch_stst, ...
            ind_fold(i), ...
            [ind_feed_phase, ind_feed_ampli], ...
            500, ...
            param,...
            'plot_prog', 1, ...
            'step', pi/8, ...
            'max_step', [ind_feed_phase,0.25, ind_feed_ampli,pi/4], ...
            'max_bound', [ind_feed_phase,10*pi, ind_feed_ampli,1.1], ...
            'min_bound', [ind_feed_phase,-10*pi, ind_feed_ampli,0.01], ...
            master_options,...
            'save', 0);

        fold_branches.(fold_active_branch_name) = fbranch;
    catch ME
        switch ME.identifier
            case 'br_contn:start'
                warning(ME.message);
                warning(strcat('During branch=',fold_active_branch_name));
                fold_branches.(fold_active_branch_name).error = ME;
                fold_branches.(fold_active_branch_name).fold_active_ind = ...
                    i;
                fold_branches.(fold_active_branch_name).fold_active_branch_name = ...
                    fold_active_branch_name;
        end
    end
end

% Save fold branches
save([master_options.datadir_specific,'fold_branches'],'fold_branches')


%% Determine where we are by plotting.

% Plot each fold_branch
namesFoldBranches = fieldnames(fold_branches);
for i = 1:numel(namesFoldBranches)
    % Add each fold_branch
    if ~any(strcmp('error',...
            fieldnames(fold_branches.(namesFoldBranches{i}))))
        % Only plot fold_branches that DO NOT have errors
        plot_branch(fold_branches.(namesFoldBranches{i}), param, ...
            'add_2_gcf', 1, 'color','r');
    end
    
end

% Ask user how many vertical continuations they'd like to make
lengthVert=input('How many continuations in the feed_ampli direction? \n');
feedAmpContinPts = zeros(lengthVert,1);

for i = 1:numel(feedAmpContinPts)
    feedAmpContinPts(i) = locate_along_branch(branch_stst, param, ...
    'fig',gcf, ... 
    'axes_indParam',[ind_feed_phase, ind_feed_ampli]);
end


%% Continue in the feedback amp direction

feedAmp_branches = struct;

for i = 1:numel(feedAmpContinPts)
    % Create a branch for each point selected by the user
    feedAmpBranch_active_name = ...
        strcat('feedAmp',num2str(i),'branch');
    
    % Calculate those branches
    [feedAmpBranch, nunst_feedAmpBranch, ...
        ind_fold_feedAmpBranch, ind_hopf_feedAmpBranch] = ...
    init_branch(funcs, ...
    branch_stst.point(feedAmpContinPts(i)).x, ...
    ind_feed_ampli, 1000, param, ...
    'par_overwrite', branch_stst.point(feedAmpContinPts(i)).parameter, ...
    master_options, ...
    'save', 0);

    % Add them to the branch struct
    feedAmp_branches.(feedAmpBranch_active_name).branch = feedAmpBranch;
    feedAmp_branches.(feedAmpBranch_active_name).nunst = ...
        nunst_feedAmpBranch;
    feedAmp_branches.(feedAmpBranch_active_name).ind_fold = ...
        ind_fold_feedAmpBranch;
    feedAmp_branches.(feedAmpBranch_active_name).ind_hopf = ...
        ind_hopf_feedAmpBranch;

end

% Save feedAmp branches
save([master_options.datadir_specific,'feedAmp_branches'],'feedAmp_branches')

%% Plot with the new params

figure

% Plot each fold_branch
namesFoldBranches = fieldnames(fold_branches);
for i = 1:numel(namesFoldBranches)
    % Add each hopf_branch
    if ~any(strcmp('error',...
            fieldnames(fold_branches.(namesFoldBranches{i}))))
        % Only plot fold_branches that DO NOT have errors
        plot_branch(fold_branches.(namesFoldBranches{i}), param, ...
            'add_2_gcf', 1, 'color','r');
    end
    
end

% Plot init_branch
plot_branch(branch_stst, param, ...
            'add_2_gcf', 1, 'color','g', ...
            'axes_indParam', [ ind_feed_phase, ind_feed_ampli ])

% Plot each feedAmp_branch
namesFeedAmp_branch = fieldnames(feedAmp_branches);
globalNunstMax = 0;
for i = 1:numel(namesFeedAmp_branch)
    % Find the max nunst overall.
    localNunstMax = max(feedAmp_branches.(namesFeedAmp_branch{i}).nunst);
    if localNunstMax > globalNunstMax
        globalNunstMax = localNunstMax;
    end
    
    % Add each FeedAmp_branch with nunst color
    plot_branch(feedAmp_branches.(namesFeedAmp_branch{i}).branch, ...
        param, ...
        'add_2_gcf', 1, ...
        'nunst_color', ...
        {feedAmp_branches.(namesFeedAmp_branch{i}).nunst, globalNunstMax },...
        'axes_indParam', [ ind_feed_phase, ind_feed_ampli ]);
    
end




