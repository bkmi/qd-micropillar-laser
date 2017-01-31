%% Create initial branch and extend bifurcations from there. Basic setup.

clear;

% Setup parameters, save them
% setup_params('save',0,'feed_ampli',0.373, 'alpha_par',1,'clear',0)
setup_params('save',0,'feed_ampli',0.15, 'alpha_par',1,'clear',0)

% Create and save turn on time series
dde23_soln = solver([1e-9;0;1e-9;0;0;0], [0,20], param, master_options);

% Create initial branch
[branch_stst, nunst_branch_stst, ind_fold, ind_hopf] = ... 
    init_branch(funcs, ...
    dde23_soln.y(:,end), ind_feed_phase, 500, param, ...
    'max_step',[ind_feed_phase, (1.0)*pi/32], master_options);

% [nunst,dom,triv_defect,points] = GetStability(branch_stst, ...
%     'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',funcs,'recompute',true);
% [TEST_nunst,~,~,pts] = GetStability(branch_stst,'funcs',funcs,'recompute',true);

%% Create structs for fold_branches
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
            20, ...
            param,...
            'plot_prog', 1, ...
            master_options,...
            'save',0);

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
            otherwise
                rethrow(ME)
        end
    end
end


%% Create structs for hopf_branches
% Hopf
hopf_branches = struct;
for i = 1:length(ind_hopf)
    hopf_active_branch_name = ...
        strcat('h',num2str(i),'branch');

    try
        hbranch = ...
            bifurContin_FoldHopf( ...
            funcs, ... 
            branch_stst, ...
            ind_hopf(i), ...
            [ind_feed_phase, ind_feed_ampli], ...
            20, ...
            param,...
            'plot_prog', 1, ...
            master_options,...
            'save',0);

        hopf_branches.(hopf_active_branch_name) = hbranch;
    catch ME
        switch ME.identifier
            case 'br_contn:start'
                warning(ME.message);
                warning(strcat('During branch=',hopf_active_branch_name));
                hopf_branches.(hopf_active_branch_name).error = ME;
                hopf_branches.(hopf_active_branch_name).hopf_active_ind = ...
                    i;
                hopf_branches.(hopf_active_branch_name).hopf_active_branch_name = ...
                    hopf_active_branch_name;
            otherwise
                rethrow(ME)
        end
    end
end

% Save hopf and fold branches
save([master_options.datadir_specific,'hopf_branches'],'hopf_branches')
save([master_options.datadir_specific,'fold_branches'],'fold_branches')
