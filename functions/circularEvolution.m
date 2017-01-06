function [ rotSoln ] = circularEvolution( soln, omega, time )
%This function takes the solution of the system and rotates the electric 
%field in a circle on the complex plane. It is useful for generating 
%history vectors. If you want to use this function on a point in a DDEBIF
%branch use branch.point(1).x for soln,
%branch.point(1).parameter(ind_omega) for omega.
%
%   Input:
%       soln, ...
%       omega, ...
%       time
%
%   Output:
%       rotSoln

A = sqrt(soln(1)^2 + soln(2)^2);
% Get Phase
phi = asin(soln(2)/A);

rotating_A = A*exp(1.0i*(omega*time+phi));
rotSoln = [real(rotating_A); imag(rotating_A); soln(3); soln(4)];

end

