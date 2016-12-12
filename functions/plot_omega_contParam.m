function [  ] = plot_omega_contParam( branch1, nunst_branch1, ...
                                        ind_hopf, ind_omega, ...
                                        par_names, par_units )
%remake '.method.continuation.plot' omega vs continuation param plot
%   Detailed explanation goes here
%   
%   Input: ( branch1, nunst_branch1, ...
%            ind_hopf, ind_omega, ...
%            par_names, par_units )

% Prepare figure and vals
figure;clf;
stst_contin_param_vals = arrayfun(@(p)p.parameter(branch1.parameter.free(1)),branch1.point); %Get stst continued parameter values
stst_contin_omega_vals = arrayfun(@(p)p.parameter(ind_omega),branch1.point);

% Create selector function and colormap
sel=@(x,i)x(nunst_branch1==i);
colors = hsv(max(nunst_branch1)+1);

% Plot points, squares
hold on
for i=0:max(nunst_branch1)
    plot(sel(stst_contin_param_vals,i),sel(stst_contin_omega_vals,i), ...
        '.','Color',colors(i+1,:),'MarkerSize',11)
end
plot(stst_contin_param_vals(ind_hopf),stst_contin_omega_vals(ind_hopf),...
    'ks','linewidth',2);
hold off

% Create Legend
for i=unique(nunst_branch1)
    unique_nunst_vals = num2str(i);
end
legend(unique_nunst_vals)

% Add title, axes
title(strcat('Omega-vs-', par_names{branch1.parameter.free(1)}))
xlabel(strcat(par_names{branch1.parameter.free(1)},{' '}, ...
    par_units{branch1.parameter.free(1)}))
ylabel('Omega (1/\tau_{sp})')

end

