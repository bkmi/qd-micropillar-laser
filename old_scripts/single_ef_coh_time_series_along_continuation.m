%Start at the first scanned value, use ddebif to make a continuation along your param
single_ef_coh_setup_parameters
single_ef_coh_solver
single_ef_coh_ddebiff_setup_rot
single_ef_coh_ddebiff_initial_continuation

%Set the param which will be used to generate the time series.
series_along_par_ind = branch1.parameter.free(1);
fprintf('___Make a time series at every unstable point along your ddebif continuation path.\n')
fprintf(strcat('___The parameter which will be consider has an index=',num2str(series_along_par_ind)))
fprintf(strcat('___And a name=',par_names{series_along_par_ind}))

%find the unstable points along the continuation and we will make a time series at those points.
ind_unstable=find(arrayfun(@(x)real(x.stability.l0(1))>0,branch1.point));

%make directory
mkdir '../figs_qd-micropillar-laser-ddebif'
mkdir '../figs_qd-micropillar-laser-ddebif/time_series_along_continuation'

for i=ind_unstable
  %change feedback amplitude to the value on the ddebif continuation
  par(series_along_par_ind) = branch1.point(i).parameter(series_along_par_ind);
  %set the history to be the steady state at that point.
  hist = branch1.point(1).x;
  %make a time series plot starting at that steady state with the relevant parameter
  single_ef_coh_solver
  savefig(strcat('../figs_qd-micropillar-laser-ddebif/time_series_along_continuation/Time_Series_with_feedback=',num2str(branch1.point(i).parameter(series_along_par_ind)),'.fig'));
end