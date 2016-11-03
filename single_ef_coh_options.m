%SELECT UNIT SYSTEM
%dim_choice = 1; % dimensional units determined in setup_params
dim_choice = 2; % dimensionless, @Oct 31 2016 the dimensionless unit of time was counting nanoseconds with tau_sp


%HIST VECTOR
hist=[1e-9;0;0;0];


%TIME SECTION (Depends on unit choice!!!)
%feedback/delay params
feed_phase = 0;
feed_ampli = .05;
tau_fb 	   = 6;	%units set with dim choice
%time bound
min_time = 0;	%units set with dim choice
max_time = 9;	%units set with dim choice


% dde23 solver options
% https://www.mathworks.com/help/matlab/ref/ddeset.html#f81-1031913
%,'RelTol',0.01,'InitialStep', 0.001e-12, 'MaxStep', 0.01e-12, 'OutputFcn',@odeplot,
options = ddeset('RelTol',10^-5, 'OutputFcn', @odeplot)