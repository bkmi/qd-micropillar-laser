%This program runs for the single mode laser case.

% Setup steady state and start with continuation.
% continue_choice variable determines which paramter is continued.

if continue_choice == 1
  %DEFINE FEED PHASE
  %plot names
  plot_param_name = 'Feedback Phase';
  plot_param_unit = '(no units)';

  %prepare ddebif
  par_cont_ind = [ind_feed_phase,ind_omega];
  [branch1,suc]=SetupStst(funcs,'contpar',par_cont_ind,'corpar',ind_omega,...
      'x',xx_guess,'parameter',par,opt_inputs{:},...
      'max_step',[ind_feed_phase,2*pi/8] ,'max_bound',[ind_feed_phase,16*pi],'newton_max_iterations',10);
      
elseif continue_choice == 2
  %DEFINE FEED AMPLI
  %plot names
  plot_param_name = 'Feedback Ampli';
  plot_param_unit = '(no units)';

  %prepare ddebif
  par_cont_ind = [ind_feed_ampli,ind_omega];
  [branch1,suc]=SetupStst(funcs,'contpar',par_cont_ind,'corpar',ind_omega,...
      'x',xx_guess,'parameter',par,opt_inputs{:},...
      'max_step',[ind_feed_ampli,0.01] ,'max_bound',[ind_feed_ampli,0.99],'newton_max_iterations',10);
      
else
error('make a choice about continue_choice in options')

end

%create continuation and plot
branch1.method.continuation.plot=1;
figure(2); clf;
[branch1,s,f,r]=br_contn(funcs,branch1,200);
title(strcat('Omega-vs-', plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel('Omega (1/\tau_{sp})')


% --


%Stability

%from lang kobayashi demo, get stability
branch1.method.stability.minimal_real_part = -1.0
[nunst_branch1,dom,defect,branch1.point]=GetStability(branch1,...
'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',funcs);

%Save branch1 with stability
save(strcat(datadir_subfolder,'branch1.mat'),'branch1','s','f','r','nunst_branch1','dom','defect')

figure(3); clf;
stst_contin_param_vals = arrayfun(@(p)p.parameter(par_cont_ind(1)),branch1.point); %Get stst continued parameter values
stst_contin_ef_vals = arrayfun(@(p)norm(p.x(1:2)),branch1.point); %Get stst normed ef vals
sel=@(x,i)x(nunst_branch1==i);
plot(sel(stst_contin_param_vals,0),sel(stst_contin_ef_vals,0),'k.', ...
    sel(stst_contin_param_vals,1),sel(stst_contin_ef_vals,1),'r.',...
    sel(stst_contin_param_vals,2),sel(stst_contin_ef_vals,2),'c.',...
    sel(stst_contin_param_vals,3),sel(stst_contin_ef_vals,3),'b.',...
    sel(stst_contin_param_vals,4),sel(stst_contin_ef_vals,4),'g.',...
    sel(stst_contin_param_vals,5),sel(stst_contin_ef_vals,5),'m.',...
    sel(stst_contin_param_vals,6),sel(stst_contin_ef_vals,6),'y.',...
    'linewidth',2);
title({strcat('Electric Field Amplitude-vs-', plot_param_name); strcat('with J=',num2str(J,'%1.1e'),'A')})
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel(strcat({'|E(t)| '}, ef_units))

%remake '.method.continuation.plot' omega vs continuation param plot
figure(2);clf;
%stst_contin_param_vals is already set above
stst_contin_omega_vals = arrayfun(@(p)p.parameter(ind_omega),branch1.point);
plot(sel(stst_contin_param_vals,0),sel(stst_contin_omega_vals,0),'k.', ...
    sel(stst_contin_param_vals,1),sel(stst_contin_omega_vals,1),'r.',...
    sel(stst_contin_param_vals,2),sel(stst_contin_omega_vals,2),'c.',...
    sel(stst_contin_param_vals,3),sel(stst_contin_omega_vals,3),'b.',...
    sel(stst_contin_param_vals,4),sel(stst_contin_omega_vals,4),'g.',...
    sel(stst_contin_param_vals,5),sel(stst_contin_omega_vals,5),'m.',...
    sel(stst_contin_param_vals,6),sel(stst_contin_omega_vals,6),'y.',...
    'linewidth',2);
title(strcat('Omega-vs-', plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel('Omega (1/\tau_{sp})')

%Omega vs QD Occupation Probability (\rho) with stability
figure(4); clf;
stst_contin_rho_vals = arrayfun(@(p)p.x(3),branch1.point);
stst_contin_omega_vals = arrayfun(@(p)p.parameter(ind_omega),branch1.point);
plot(sel(stst_contin_rho_vals,0),sel(stst_contin_omega_vals,0),'k.', ...
    sel(stst_contin_rho_vals,1),sel(stst_contin_omega_vals,1),'r.',...
    sel(stst_contin_rho_vals,2),sel(stst_contin_omega_vals,2),'c.',...
    sel(stst_contin_rho_vals,3),sel(stst_contin_omega_vals,3),'b.',...
    sel(stst_contin_rho_vals,4),sel(stst_contin_omega_vals,4),'g.',...
    sel(stst_contin_rho_vals,5),sel(stst_contin_omega_vals,5),'m.',...
    sel(stst_contin_rho_vals,6),sel(stst_contin_omega_vals,6),'y.',...
    'linewidth',2);
title('Omega vs QD Occupation Probability (\rho)')
xlabel('\rho (no units)')
ylabel('Omega (1/\tau_{sp})')

%from lina's example, plot real eigenvalue part versus parameter
figure(5); clf;
[x_measure,y_measure]= df_measr(1,branch1);
br_plot(branch1,x_measure,y_measure);
title(strcat('Real part of Eigenvalues-vs-', plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel('re(\lambda)')


% --

%{

%%
%% Currently turned off because I think these plots are irrelevant. I plotted the ef stuff above with stability above.
%%

% Access values at data points from continuation.
branch1_plot_vals = c_extract(branch1, par_cont_ind);


% Create plots versus modified params
figure(4); clf;
subplot(2,2,[1,2]);
plot(branch1_plot_vals.par(1,:), arrayfun(@(x)norm(x),branch1_plot_vals.soln(1,:)+1i*branch1_plot_vals.soln(2,:)))
title({strcat('Electric Field Amplitude-vs-', plot_param_name); strcat('with J=',num2str(J,'%1.1e'),'A')})
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel(strcat({'|E(t)| '}, ef_units))

subplot(2,2,3);
plot(branch1_plot_vals.par(1,:),branch1_plot_vals.soln(3,:))
title(strcat({'QD Occupation Prob vs '},plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel('\rho(t) (no units)')

subplot(2,2,4);
plot(branch1_plot_vals.par(1,:),branch1_plot_vals.soln(4,:))
title(strcat({'Carrier Density vs '},plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel(strcat({'n_r(t) '},n_units))

%}

% --


%Now we deviate depending on which parameter was continued. At the moment, only phase is interesting.


if continue_choice == 1
  % FEED PHASE Hopf, etc, continuation
  
  % How about a hopf bifurcation?!

  % from lang kobayashi demo
  % ind_hopf=find(arrayfun(@(x)real(x.stability.l0(1))>0,branch1.point),1,'first')
  ind_hopf=find(abs(diff(nunst_branch1))==2);

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
  
  %Augment omega vs 'plot_param_name' with boxes around potential hopf bifurcations
  figure(2);
  hold on
  plot(stst_contin_param_vals(ind_hopf),stst_contin_omega_vals(ind_hopf),'ks','linewidth',2);
  hold off
  
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


%{
%plot point
figure(3); clf;
hold on
plot(branch1_plot_vals.par(1,:), arrayfun(@(x)norm(x),branch1_plot_vals.soln(1,:)+1i*branch1_plot_vals.soln(2,:)))
plot(branch1_plot_vals.par(1,ind_hopf), ...
    norm(branch1_plot_vals.soln(1,ind_hopf)+1i*branch1_plot_vals.soln(2,ind_hopf)), '*')
hold off
title({strcat('Electric Field Amplitude-vs-', plot_param_name); strcat('with J=',num2str(J,'%1.1e'),'A')})
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel(strcat({'|E(t)| '}, ef_units))
%}

