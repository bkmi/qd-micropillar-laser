%Now we deviate depending on which parameter was continued. At the moment, only phase is interesting.


if continue_choice == 1
  % FEED PHASE Hopf, Fold continuation.
  % HOPF continuation
  hopf_branches = struct;
  hopf_count = 1:length(ind_hopf);
  
  figure(6); clf; % prepare figure, remove previous plots
  
  % generate a branch for each hopf bifurcation. Put those branches into a single struct called "hopf_branches"
  for i=hopf_count
    hopf_active_ind = hopf_count(i);
    hopf_active_branch_name = strcat('h',num2str(hopf_active_ind),'branch');
    hbranch.method.continuation.plot=1;
    
    try
      [hbranch,suc]=SetupRWHopf(funcs,branch1,ind_hopf(i),...
	'contpar',[ind_feed_phase, ind_feed_ampli, ind_omega],opt_inputs{:},...
	'print_residual_info',1,'dir',ind_feed_ampli,'step',0.01,'minimal_accuracy',1e-4,...
	'max_bound',[ind_feed_ampli,0.99]);
	
      figure(6);
      [hbranch,s,f,r]=br_contn(funcs,hbranch,150);
      hbranch=br_rvers(hbranch);
      hbranch=br_contn(funcs,hbranch,150);
      title(strcat('Feedback Ampli vs Feedback Phase - Hopf Bifurcation Continuation'))
      xlabel('Feedback Phase (no units)')
      ylabel('Feedback Ampli (no units)')
      
      hopf_branches.(hopf_active_branch_name) = hbranch;
    catch ME
      switch ME.identifier
	case 'br_contn:start'
	  warning(ME.message);
	  warning(strcat('During branch=',hopf_active_branch_name));
	  hopf_branches.(hopf_active_branch_name).error = ME;
	  hopf_branches.(hopf_active_branch_name).hopf_active_ind = hopf_active_ind;
	  hopf_branches.(hopf_active_branch_name).hopf_active_branch_name = hopf_active_ind;
      end
    end
  end
  
  %% old plotting technique
  %% prepare points for combined plot
  % h1branch_feed_phase_vals = arrayfun(@(p)p.parameter(ind_feed_phase),h1branch.point);
  % h1branch_feed_ampli_vals = arrayfun(@(p)p.parameter(ind_feed_ampli),h1branch.point);
  
  %Save hopf_branches
  if saveit==1
    save(strcat(datadir_specific,'hopf_branches.mat'),'hopf_branches');
  elseif saveit == 2
  else
    error('Choose a saveit setting in options!!')
  end
  

  % FOLD continuation
  ind_fold=find(abs(diff(nunst_branch1))==1);
  fold_branches = struct;
  fold_count = 1:length(ind_fold);
  
  for i=fold_count
    fold_active_ind = fold_count(i);
    fold_active_branch_name = strcat('f',num2str(fold_active_ind),'branch');
    fbranch.method.continuation.plot=1;
    
    try
      [foldfuncs,fbranch,suc]=SetupRWFold(funcs,branch1,ind_fold(i),...
	  'contpar',[ind_feed_phase, ind_feed_ampli, ind_omega],opt_inputs{:},...
	  'print_residual_info',1,'dir',ind_feed_ampli,'step',0.01,...
	  'max_bound',[ind_feed_ampli,1.2]); %'max_step',[ind_phi,0.1; ind_eta,0.01]);
      
      figure(6);
      fbranch=br_contn(foldfuncs,fbranch,100);
      fbranch=br_rvers(fbranch);
      fbranch=br_contn(foldfuncs,fbranch,100);
      title(strcat('Feedback Ampli vs Feedback Phase - Fold/Saddle-Node Bifurcation Continuation'))
      xlabel('Feedback Phase (no units)')
      ylabel('Feedback Ampli (no units)')
      
      fold_branches.(fold_active_branch_name) = fbranch;
    catch ME
      switch ME.identifier
	case 'br_contn:start'
	  warning(ME.message);
	  warning(strcat('During branch=',fold_active_branch_name));
	  fold_branches.(fold_active_branch_name).error = ME;
	  fold_branches.(fold_active_branch_name).fold_active_ind = fold_active_ind;
	  fold_branches.(fold_active_branch_name).fold_active_branch_name = fold_active_branch_name;
      end
    end
  end
  
  %% old plotting technique
  %% prepare points for combined plot
  % fold1branch_feed_phase_vals = arrayfun(@(p)p.parameter(ind_feed_phase),fold1branch.point);
  % fold1branch_feed_ampli_vals = arrayfun(@(p)p.parameter(ind_feed_ampli),fold1branch.point);
  
  %Save fold_branches
  if saveit==1
    save(strcat(datadir_specific,'fold_branches.mat'),'fold_branches','ind_fold');
  elseif saveit == 2
  else
    error('Choose a saveit setting in options!!')
  end
  
  
elseif continue_choice == 2
  %DEFINE FEED AMPLI
  
  error('Currently, there are no interesting bifurcations along feedback amplitude. Goodbye.')
      
else
error('make a choice about continue_choice in options')

end

