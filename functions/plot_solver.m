function [  ] = plot_solver( sol, J, hist, time_units, ef_units, n_units )
%Input 'sol' struct from dde23, Generates new figure in solver plot stlye.
%   Detailed explanation goes here

figure; clf;
subplot(2,2,[1,2]);
plot(sol.x,arrayfun(@(x)norm(x),sol.y(1,:)+1i*sol.y(2,:)))
title({'Electric Field Amplitude vs Time '; ...
    strcat('with J=',num2str(J,'%1.1e'),'A');...
    strcat('hist=[re(E),im(E),\rho,n_r]=', mat2str(hist))})
xlabel(strcat({'Time '}, time_units))
ylabel(strcat({'|E(t)| '}, ef_units))

subplot(2,2,3);
plot(sol.x,sol.y(3,:))
title('QD Occupation Prob vs Time')
xlabel(strcat({'Time '}, time_units))
ylabel('\rho(t) (no units)')

subplot(2,2,4);
plot(sol.x,sol.y(4,:))
title('Carrier Density vs Time')
xlabel(strcat({'Time '}, time_units))
ylabel(strcat({'n_r(t) '},n_units))

end

