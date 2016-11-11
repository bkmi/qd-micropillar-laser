%Start at the first scanned value, use ddebif to make a continuation along your param
single_ef_coh_setup_parameters
single_ef_coh_solver
single_ef_coh_ddebiff_setup_rot
single_ef_coh_ddebiff_cont_feed_ampli

%Set the param which will be used to generate the time series.
series_along_par_ind = par_cont_ind(1);
fprintf('___Make a time series at every unstable point along your ddebif continuation path.\n')
fprintf(strcat('___The parameter which will be consider has an index=',num2str(series_along_par_ind)))

%find the unstable points along the continuation and we will make a time series at those points.
ind_unstable=find(arrayfun(@(x)real(x.stability.l0(1))>0,branch1.point));

%make directory
mkdir 'steady_state_figs'

for i=ind_unstable
  %change feedback amplitude to the value on the ddebif continuation
  par(series_along_par_ind) = branch1_plot_vals.par(1,i);
  %set the history to be the steady state at that point.
  hist = branch1_plot_vals.soln(:,i);
  %make a time series plot starting at that steady state with the relevant parameter
  single_ef_coh_solver
  savefig(strcat('steady_state_figs/Time_Series_with_feedback=',num2str(branch1_plot_vals.par(1,i)),'.fig'));
end