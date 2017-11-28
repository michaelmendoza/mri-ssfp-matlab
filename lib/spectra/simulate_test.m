clear;
close all;

% Make sure ssfp_spectrum.m is available to simulate.m
path(path,'..');

%% Sinusoisal Simulation Parameters
alpha = 0.5 * pi;
dphi = 0;
T1 = 0.270;
T2 = 0.085;
fMax = 165;
TEs = [ .003, .006, .012 ];
TRs = TEs*2;

% Desired test functions
cp = center_pulse(100);
ocp = offcenter_pulse(100);

% Show centered pulse
[ Q, c ] = simulate(alpha,dphi,TEs,TRs,T1,T2,fMax,cp,0);
h = compare_plot(cp,abs(Q*c),'Simulated Sine, centered Pulse');

% Show off-center pusle
[ Q2, c2 ] = simulate(alpha, dphi, TEs, TRs, T1, T2, fMax,ocp,0);
h2 = compare_plot(ocp,abs(Q2*c2),'Simulated Sine, off-center Pulse');

%% Castle Simulation Parameters
alpha = 0.2 * pi;

% Centered pulse
[ Q3, c3 ] = simulate(alpha,dphi,TEs,TRs,T1,T2,fMax,cp,0);
h3 = compare_plot(cp,abs(Q3*c3),'Simulated Castle, centered Pulse');

% Offcenter Pulse
[ Q4, c4 ] = simulate(alpha, dphi, TEs, TRs, T1, T2, fMax,ocp,0);
h4 = compare_plot(ocp,abs(Q4*c4),'Simulated Castle, off-center Pulse');
