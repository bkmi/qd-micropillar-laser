function f = qd_1ef_sys(E, Etau, rho, rhotau, n, ntau, kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, beta, J_p, eta, tau_r, S_in, V, Z_QD, n_bg, tau_sp, T_2, A, hbar_omega, epsi_tilda, J, feed_phase, feed_ampli, tau_fb, epsi0, hbar, e0, c0)
    % First step in inputing a coherent feedback, signgle electric field direction, system.
    %
    % This function takes in every element explicitly so it can be easily
    % understood by the user. The Etau, rhotau, and ntau refer to delay by feedback.
    %
    % Since this function only deals with one electric field,
    % we call it's subscripts like the strong electric field. (E_s)
    % However, it just shows up as "E" in the function.
    %
    %
    %par =
    %   [ kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, ...
    %   beta, J_p, eta, ...
    %   tau_r, S_in, V, Z_QD, n_bg, ...
    %   tau_sp, T_2, A, hbar_omega, epsi_tilda, J, ...
    %   feed_phase, feed_ampli, tau_fb,
    %	epsi0, hbar, e0, c0]
    %	(The system gets mad when I try and reference omega here, so I just... won't call it in the last postion)
    %
    %
    % Output is [real(Edot); imag(Edot); rhodot; ndot]
    
    epsi_bg = n_bg^2;
    
    g = ((norm(mu_s)^2)*T_2/(2*hbar^2))*(1+epsi_ss*epsi_tilda*(E.*conj(E))).^(-1);
    
    Edot = ((hbar_omega/(epsi0*epsi_bg))*(2*Z_QD/V)*g.*(2*rho-1).*E) - (kappa_s*(E-feed_ampli*exp(-1.0i*feed_phase)*Etau)) + (beta*hbar_omega/(epsi0*epsi_bg))*(2*Z_QD/V)*(rho/tau_sp).*(E./(E.*conj(E)));
    rhodot = -(g.*(2*rho-1).*(E.*conj(E))) - (rho/tau_sp) + (S_in*n.*(1-rho)); 
    ndot = ((eta/(e0*A))*(J-J_p)) - ((S_in*n).*((2*Z_QD/A)*(1-rho))) - (n/tau_r);
    
    %updated changes
    %g = ((norm(mu_s)^2)*T_2/(2*hbar^2))*(1+epsi_ss*epsi_tilda*(E*conj(E)))^(-1)
    %Edot = (hbar_omega/(epsi0*epsi_bg))*(2*Z_QD/V)*g*(2*rho-1)*E-kappa_s*(E-feed_ampli*exp(-1.0i*feed_phase)*Etau)+(beta*hbar_omega/(epsi0*epsi_bg))*(2*Z_QD/V)*(rho/tau_sp)*(E/(E*conj(E)));
    %rhodot = -g*(2*rho-1)*(E*conj(E))-rho/tau_sp+S_in*n*(1-rho);
    %ndot = (eta/(e0*A))*(J-J_p)-S_in*n*(2*Z_QD/A)*(1-rho)-n/tau_r; 
    
    
    
    f = cat(1, real(Edot), imag(Edot), rhodot, ndot);
    
end