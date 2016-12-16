function [  ] = plot_rho_omega( branch1, nunst_branch1, ...
                                        ind_hopf, ind_omega )
%QD Occupation Probability (\rho) vs Omega with stability
%   Detailed explanation goes here

% Prepare figure and vals
figure; clf;
stst_contin_rho_vals = arrayfun(@(p)p.x(3),branch1.point);
stst_contin_omega_vals = arrayfun(@(p)p.parameter(ind_omega),branch1.point);

% Create selector function and colormap
sel=@(x,i)x(nunst_branch1==i);
colors = hsv(max(nunst_branch1)+1);

% Plot points, squares
hold on
for i=0:max(nunst_branch1)
    plot(sel(stst_contin_omega_vals,i),sel(stst_contin_rho_vals,i),'.',...
        'Color',colors(i+1,:),'MarkerSize',11)
end
plot(stst_contin_omega_vals(ind_hopf),stst_contin_rho_vals(ind_hopf),...
    'ks','linewidth',2)
hold off

% Create Legend
for i=unique(nunst_branch1)
    unique_nunst_vals = num2str(i);
end
legend(unique_nunst_vals)

% Add title, axes
title('QD Occupation Probability (\rho) vs Omega')
xlabel('Omega (1/\tau_{sp})')
ylabel('\rho (no units)')

end