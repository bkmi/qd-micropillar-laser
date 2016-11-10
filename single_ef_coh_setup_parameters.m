%simulation parameter setup

%prepare matlab
clear;                           % clear variables
close all;                       % close figures
present_working_directory = pwd
addpath(strcat(present_working_directory,'/functions/'))

%Options are important, read them.
single_ef_coh_options;

%define indicies
ind_kappa_s     = 1;
ind_kappa_w     = 2;
ind_mu_s        = 3;
ind_mu_w        = 4;
ind_epsi_ss     = 5;
ind_epsi_ww     = 6;
ind_epsi_sw     = 7;
ind_epsi_ws     = 8;
ind_beta        = 9;
ind_J_p         = 10;
ind_eta         = 11;
ind_tau_r       = 12;
ind_S_in        = 13;
ind_V           = 14;
ind_Z_QD        = 15;
ind_n_bg        = 16;
ind_tau_sp      = 17;
ind_T_2         = 18;
ind_A           = 19;
ind_hbar_omega	= 20;
ind_epsi_tilda	= 21;
ind_J           = 22;
ind_feed_phase  = 23;
ind_feed_ampli  = 24;
ind_tau_fb      = 25;
ind_epsi0	= 26;
ind_hbar 	= 27;
ind_e0 		= 28;
ind_c0 		= 29;


%% --


%define params in kg, m, s aka SI UNITS.
%general constants, these are the parameters passed to the par vector
epsi0 = 8.85e-12;		%F m^-1 == J V^-2 m^-1
hbar = 6.58e-16;		%Js
e0 = 1.6e-19;			%C
c0 = 3.0e8;			%m s^-1

%table 1 params
kappa_s    = 0.039*(1/1e-12);	%ps^-1 -> 1/s
kappa_w    = 0.041*(1/1e-12);	%ps^-1 -> 1/s
mu_s 	   = 3.70*(1e-9*e0);	%nm * e0 -> m*C
mu_w 	   = 3.75*(1e-9*e0);	%nm * e0 -> m*C
epsi_ss    = 70e-10;		%m^2 A^-1 V-^1
epsi_ww    = 50e-10;		%m^2 A^-1 V^-1
epsi_sw    = 160e-10;		%m^2 A^-1 V^-1
epsi_ws    = 150e-10;		%m^2 A^-1 V^-1
beta	   = 5.6e-3;
J_p 	   = 42.5*1e-6;		%microAmps -> Amps
eta 	   = 1.28e-3;
tau_r 	   = 150*(1e-12); 	%ps -> s
S_in 	   = 10^(-16)*(1/1e-12);%m^2 ps^-1 -> m^2 s^-1
V 	   = 6.3*(1e-6)^3; 	%micro m^3 -> m^3
Z_QD 	   = 110;
n_bg 	   = 3.34;
tau_sp 	   = 1*(1e-9);		%ns -> s
T_2 	   = 0.33*(1e-12); 	%ps -> s
A 	   = 3.14*(1e-6)^2; 	%micro m^2
hbar_omega = 1.38*(1.6e-19); 	%eV -> J
epsi_tilda = epsi0*n_bg*c0;
%continued param in paper
J	   = 2.5*90*(1e-6); 	%microAmps -> Amps (2.5 * Threshold. Threshold from Redlich paper, 2.5 from ott10)



%% --


%NOTICE: Below was my attempt at using dimensional, but non-SI units.
%I have never gotten it to work; however, the units are left just in case they become necessary.

%{
  %define params in nm, ns, microAmps, V, eV, microC
  %general constants, these are the last parameters passed to the par vector
  epsi0 = 8.85e-12*(1e6)		%A s V^-1 m^-1 -> microA ns V^-1 nm^-1
  hbar = 4.13e-15*(1e9);		%eV s -> eV ns
  e0 = 1.6e-19*(1e6);		%C -> microC
  c0 = 3.0e8;			%nm ns^-1

  %table 1 params
  kappa_s    = 0.039*(1e3);	%ps^-1 -> 1/ns
  kappa_w    = 0.041*(1e3);	%ps^-1 -> 1/ns
  mu_s 	   = 3.70;		%nm * e0
  mu_w 	   = 3.75;		%nm * e0
  epsi_ss    = 70e-10*(1e12);	%m^2 A^-1 V-^1 -> nm^2 microA^-1 v^-1
  epsi_ww    = 50e-10*(1e12);	%m^2 A^-1 V^-1 -> nm^2 microA^-1 v^-1
  epsi_sw    = 160e-10*(1e12);	%m^2 A^-1 V^-1 -> nm^2 microA^-1 v^-1
  epsi_ws    = 150e-10*(1e12);	%m^2 A^-1 V^-1 -> nm^2 microA^-1 v^-1
  beta	   = 5.6e-3;
  J_p 	   = 42.5;		%microA
  eta 	   = 1.28e-3;
  tau_r 	   = 150*(1e-3); 	%ps -> ns
  S_in 	   = 10^(-16)*(1e21);	%m^2 ps^-1 -> nm^2 ns^-1
  V 	   = 6.3*(1e9); 	%micro m^3 -> m^3
  Z_QD 	   = 110;
  n_bg 	   = 3.34;
  tau_sp 	   = 1;			%ns
  T_2 	   = 0.33*(1e-3); 	%ps -> ns
  A 	   = 3.14*(1e6); 	%microm^2 -> nm^2
  hbar_omega = 1.38;	 	%eV
  epsi_tilda = epsi0*n_bg*c0;
  %continued param in paper
  J	   = 160; 		%microA
  %feedback/delay params
  feed_phase = 0;
  feed_ampli = 0.05;
  tau_fb 	   = 6;			%ns
%}
  
% --

%{
  %define params in nm, ps, microAmps, V, eV, microC
  %general constants, these are the last parameters passed to the par vector
  epsi0 = 8.85e-12*(1e6)*(1e3)	%A s V^-1 m^-1 -> microA ns V^-1 nm^-1 -> microA ps V^-1 nm^-1
  hbar = 4.13e-15*(1e12);		%eV s -> eV ps
  e0 = 1.6e-19*(1e6);		%C -> microC
  c0 = 3.0e8*(1e-3);		%nm ps^-1

  %table 1 params
  kappa_s    = 0.039;		%ps^-1
  kappa_w    = 0.041;		%ps^-1
  mu_s 	   = 3.70;		%nm * e0
  mu_w 	   = 3.75;		%nm * e0
  epsi_ss    = 70e-10*(1e12);	%m^2 A^-1 V-^1 -> nm^2 microA^-1 v^-1
  epsi_ww    = 50e-10*(1e12);	%m^2 A^-1 V^-1 -> nm^2 microA^-1 v^-1
  epsi_sw    = 160e-10*(1e12);	%m^2 A^-1 V^-1 -> nm^2 microA^-1 v^-1
  epsi_ws    = 150e-10*(1e12);	%m^2 A^-1 V^-1 -> nm^2 microA^-1 v^-1
  beta	   = 5.6e-3;
  J_p 	   = 42.5;		%microA
  eta 	   = 1.28e-3;
  tau_r 	   = 150;	 	%ps
  S_in 	   = 10^(-16)*(1e18);	%m^2 ps^-1 -> nm^2 ns^-1
  V 	   = 6.3*(1e9); 	%micro m^3 -> nm^3
  Z_QD 	   = 110;
  n_bg 	   = 3.34;
  tau_sp 	   = 1e3;		%ns
  T_2 	   = 0.33; 		%ps -> ns
  A 	   = 3.14*(1e6); 	%microm^2 -> nm^2
  hbar_omega = 1.38;	 	%eV
  epsi_tilda = epsi0*n_bg*c0;
  %continued param in paper
  J	   = 160; 		%microA
  %feedback/delay params
  feed_phase = 0;
  feed_ampli = 0.05;
  tau_fb 	   = 6e6;		%ns -> ps
%}


% --


%create parameter array called par
par = [kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, beta, J_p, ...
      eta, tau_r, S_in, V, Z_QD, n_bg, tau_sp, T_2, A, hbar_omega, epsi_tilda, J, ...
      feed_phase, feed_ampli, tau_fb, epsi0, hbar, e0, c0];