function f = bimodal_sys(Es, Es_tau, Ew, Ew_tau, rho, rhotau, n, ntau, kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, beta, J_p, eta, tau_r, S_in, V, Z_QD, n_bg, tau_sp, T_2, A, hbar_omega, epsi_tilda, J, feed_phase, feed_ampli, tau_fb, epsi0, hbar, e0, c0)
    % Coherent feedback in perpendicular bimodal system.
    %
    % This function takes in every element explicitly so it can be easily
    % understood by the user. The Etau, rhotau, and ntau refer to delayed feedback.
    %
    %par =
    %   [ kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, ...
    %   beta, J_p, eta, ...
    %   tau_r, S_in, V, Z_QD, n_bg, ...
    %   tau_sp, T_2, A, hbar_omega, epsi_tilda, J, ...
    %   feed_phase, feed_ampli, tau_fb,
    %	epsi0, hbar, e0, c0 ]
    %	(The system gets mad when I try and reference omega here, so I just... won't call it in the last postion)
    %
    % feed_ampli = [ strong_strong, strong_weak; weak_strong, weak_weak ]
    % feed_phase = [ strong_strong, strong_weak; weak_strong, weak_weak ]
    %
    %
    %
    % Output is [real(EsDOT); imag(EsDOT); real(EwDOT); imag(EwDOT); rhodot; ndot]
    
    epsi_bg = n_bg^2;
    
    COEF = (hbar_omega/(epsi0*epsi_bg))*(2*Z_QD/V);
    
    gs = ((norm(mu_s)^2)*T_2/(2*hbar^2))*(1 + epsi_ss*epsi_tilda*(Es.*conj(Es)) + epsi_sw*epsi_tilda*(Ew.*conj(Ew))).^(-1);
    gw = ((norm(mu_w)^2)*T_2/(2*hbar^2))*(1 + epsi_ws*epsi_tilda*(Es.*conj(Es)) + epsi_ww*epsi_tilda*(Ew.*conj(Ew))).^(-1);
    
    EsDOT  = COEF*gs.*(2*rho-1).*Es - kappa_s*(Es-feed_ampli
    *exp(-1.0i*feed_phase)*Etau)
    EwDOT  = 
    rhodot = 
    ndot   = 
    
end