%Now we deviate depending on which parameter was continued. At the moment, only phase is interesting.


if continue_choice == 1
  % FEED PHASE Hopf, etc, continuation
  
  % How about a hopf bifurcation?!

  %% I do this in the initial continuation. ind_hopf is already defined there.
  % from lang kobayashi demo
  % ind_hopf=find(arrayfun(@(x)real(x.stability.l0(1))>0,branch1.point),1,'first')
  % ind_hopf=find(abs(diff(nunst_branch1))==2);

  % Hardcoded for the axes to remain the same. I don't think there is a good way to get around this.
  h1branch.method.continuation.plot=1;
  figure(6); clf;
  [h1branch,suc]=SetupRWHopf(funcs,branch1,ind_hopf(1),...
    'contpar',[ind_feed_phase, ind_feed_ampli, ind_omega],opt_inputs{:},...
    'print_residual_info',1,'dir',ind_feed_ampli,'step',0.01,'minimal_accuracy',1e-4,...
    'max_bound',[ind_feed_ampli,0.99]);
  h1branch=br_contn(funcs,h1branch,100);
  h1branch=br_rvers(h1branch);
  h1branch=br_contn(funcs,h1branch,100);
  title(strcat('Feedback Ampli vs Feedback Phase - Hopf Bifurcation Continuation'))
  xlabel('Feedback Phase (no units)')
  ylabel('Feedback Ampli (no units)')
  %prepare points for combined plot
  h1branch_feed_phase_vals = arrayfun(@(p)p.parameter(ind_feed_phase),h1branch.point);
  h1branch_feed_ampli_vals = arrayfun(@(p)p.parameter(ind_feed_ampli),h1branch.point);
  
  
  % Hardcoded for the axes to remain the same. I don't think there is a good way to get around this.
  % This one starts at the hopf bifurcation symetric to the one above.
  h2branch.method.continuation.plot=1;
  figure(6);
  [h2branch,suc]=SetupRWHopf(funcs,branch1,ind_hopf(12),...
    'contpar',[ind_feed_phase, ind_feed_ampli, ind_omega],opt_inputs{:},...
    'print_residual_info',1,'dir',ind_feed_ampli,'step',0.01,'minimal_accuracy',1e-4,...
    'max_bound',[ind_feed_ampli,1.2]);
  h2branch=br_contn(funcs,h2branch,100);
  h2branch=br_rvers(h2branch);
  h2branch=br_contn(funcs,h2branch,100);
  title(strcat('Feedback Ampli vs Feedback Phase - Hopf Bifurcation Continuation'))
  xlabel('Feedback Phase (no units)')
  ylabel('Feedback Ampli (no units)')
  %prepare points for combined plot
  h2branch_feed_phase_vals = arrayfun(@(p)p.parameter(ind_feed_phase),h2branch.point);
  h2branch_feed_ampli_vals = arrayfun(@(p)p.parameter(ind_feed_ampli),h2branch.point);
  
  
  %%
  %% Now let's look at the fold bifurcation
  
  ind_fold=find(abs(diff(nunst_branch1))==1);
  [foldfuncs,fold1branch,suc]=SetupRWFold(funcs,branch1,ind_fold(1),...
      'contpar',[ind_feed_phase, ind_feed_ampli, ind_omega],opt_inputs{:},...
      'print_residual_info',1,'dir',ind_feed_ampli,'step',0.01,...
      'max_bound',[ind_feed_ampli,1.2]); %'max_step',[ind_phi,0.1; ind_eta,0.01]);
  figure(6);
  fold1branch=br_contn(foldfuncs,fold1branch,60);
  fold1branch=br_rvers(fold1branch);
  fold1branch=br_contn(foldfuncs,fold1branch,60);
  title(strcat('Feedback Ampli vs Feedback Phase - Fold/Saddle-Node Bifurcation Continuation'))
  xlabel('Feedback Phase (no units)')
  ylabel('Feedback Ampli (no units)')
  %prepare points for combined plot
  fold1branch_feed_phase_vals = arrayfun(@(p)p.parameter(ind_feed_phase),fold1branch.point);
  fold1branch_feed_ampli_vals = arrayfun(@(p)p.parameter(ind_feed_ampli),fold1branch.point);
  
  % Plot all of these color coded bifurcations on the same graph
  figure(6); clf;
  plot(h1branch_feed_phase_vals, h1branch_feed_ampli_vals, 'k.', ...
      h2branch_feed_phase_vals, h2branch_feed_ampli_vals, 'r.', ...
      fold1branch_feed_phase_vals, fold1branch_feed_ampli_vals, 'b.', ...
      'linewidth',2);
  title(strcat('Feedback Ampli vs Feedback Phase - Combined Bifurcation Continuation'))
  xlabel('Feedback Phase (no units)')
  ylabel('Feedback Ampli (no units)')
      
elseif continue_choice == 2
  %DEFINE FEED AMPLI
  
  error('Currently, there are no interesting bifurcations along feedback amplitude. Goodbye.')
      
else
error('make a choice about continue_choice in options')

end

