function [ output_args ] = eval_branch1( input_args )
%
%   Detailed explanation goes here


% STILL A WORK IN PROGRESS. CURRENTLY USED TO ZOOM IN ON POINTS ALONG BRANCH1, LET'S MAKE IT GENERAL FOR ZOOMING IN ALONG A BRANCH.

[branch2,suc]=SetupStst(funcs,'contpar',par_cont_ind,'corpar',ind_omega,...
'x',branch1.point(ind_hopf(2)-5).x,'parameter',branch1.point(ind_hopf(2)-3).parameter,opt_inputs{:},...
'step',(1/8)*pi/4096,'max_step',[ind_feed_phase,(1/8)*pi/4096] ,'newton_max_iterations',25, ...
'min_bound',[ind_feed_phase,0],'max_bound',[ind_feed_phase,16*pi] );


branch2.method.continuation.plot=1;
figure(2); clf;
[branch2,s,f,r]=br_contn(funcs,branch2,8*200);
title(strcat('Omega-vs-', plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel('Omega (1/\tau_{sp})')


%from lang kobayashi demo, get stability
branch2.method.stability.minimal_real_part = -1.0;
[nunst_branch2,dom,defect,branch2.point]=GetStability(branch2,...
'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',funcs);


%remake '.method.continuation.plot' omega vs continuation param plot
figure(2);clf;
%stst_contin_param_vals is already set above
stst_contin_param_vals = arrayfun(@(p)p.parameter(par_cont_ind(1)),branch2.point); %Get stst continued parameter values
stst_contin_omega_vals = arrayfun(@(p)p.parameter(ind_omega),branch2.point);
sel=@(x,i)x(nunst_branch2==i);
colors = hsv(max(nunst_branch2)+1);
  hold on
  for i=0:max(nunst_branch2)
    plot(sel(stst_contin_param_vals,i),sel(stst_contin_omega_vals,i),'.','Color',colors(i+1,:),'MarkerSize',11)
  end
  hold off
  %for legend
  for i=unique(nunst_branch2)
    unique_nunst_vals = num2str(i);
  end
  legend(unique_nunst_vals)
title(strcat('Omega-vs-', plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel('Omega (1/\tau_{sp})')


end

