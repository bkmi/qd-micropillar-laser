function f = qd_1ef_sys(E, Etau, rho, rhotau, n, ntau, kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, beta, J_p, eta, tau_r, S_in, V, Z_QD, n_bg, tau_sp, T_2, A, hbar_omega, epsi_tilda, J, feed_phase, feed_ampli, tau_fb, epsi0, hbar, e0, c0)
    % First step in inputing a coherent feedback, signgle electric field direction, system.
    % Nondimensionalized!
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
    %
    %
    %
    % The nondim was done with this:
    % E = theta E_nodim
    % theta = sqrt((epsi_ss*epsi_tilda)^-1)
    %
    % t = lambda t_nodim
    % lambda = tau_sp
    %
    % n = phi n_nodim
    % phi = (S_in*tau_sp)^(-1)
    %
    % rho = rho (already nondim)
    
    epsi_bg = n_bg^2;
    
    %from mathematica + by hand, most likely to be wrong
    %Edot   = kappa_s*tau_sp*(exp(-1i*feed_phase)*Etau-E) + ((2*epsi_tilda*Z_QD*beta*epsi_ss*hbar_omega)/(V*epsi0*epsi_bg))*((E.*rho)./(E.*conj(E))) + ((hbar_omega*T_2*Z_QD*(mu_s^2)*tau_sp)/(V*epsi0*epsi_bg*hbar^2))*(E./(1 + E.*conj(E))).*(2*rho-1);
    %rhodot = n.*(1-rho) - rho - ((T_2*mu_s^2*tau_sp)/(2*epsi_tilda*epsi_ss*hbar^2))*(2*rho-1).*(E.*conj(E))./(1 + (E.*conj(E)));
    %ndot   = -((2*S_in*Z_QD*tau_sp)/A)*n.*(1-rho) - (tau_sp/tau_r)*n + ((eta*(J-J_p)*S_in*tau_sp^2)/(A*e0));
    
    % By hand
    %Edot = tau_sp*((hbar_omega*2*Z_QD)/(epsi0*epsi_bg))*((mu_s^2*T_2)/(2*hbar^2))*(2*rho-1).*E.*(1+(E.*conj(E)))^(-1) - tau_sp*kappa_s*(E - exp(-1i*feed_phase)*feed_ampli*Etau) + beta*((hbar_omega*2*Z_QD)/(epsi0*epsi_bg))*epsi_ss*epsi_tilda*rho.*E./(E.*conj(E));
    
    %with substitution
    F = hbar_omega*2*Z_QD/(epsi0*epsi_bg*V);
    Q = mu_s^2*T_2/(2*hbar^2);
    theta = sqrt((epsi_ss*epsi_tilda)^-1);
    lambda = tau_sp;
    phi = (S_in*tau_sp)^(-1);
    
    Edot = (lambda*F*Q/(1+(E.*conj(E)))).*(2*rho-1)*E - lambda*kappa_s*(E-exp(-1i*feed_phase)*feed_ampli*Etau) + (lambda*epsi_ss*epsi_bg*beta*F/tau_sp)*rho.*E./(E.*conj(E));
    rhodot = n.*(1-rho) - rho - ((T_2*mu_s^2*tau_sp)/(2*epsi_tilda*epsi_ss*hbar^2))*(2*rho-1).*(E.*conj(E))./(1 + (E.*conj(E))); %this one is copied but I'm pretty sure it's right
    ndot = (lambda/phi)*(eta/(e0*A))*(J-J_p) - lambda*S_in*(2*Z_QD/A)*(1-rho) - lambda/tau_r*n;
    
    f = cat(1, real(Edot), imag(Edot), rhodot, ndot);
    
end