
function [im_sim] = analyze_data(imData,alpha,TEs,dphis,T1,T2,fMax, filter_fun, filter_shift)

%% Get Bases
Ns = size(imData,1); % Length of each basis vector

% We'll need the ssfp_spectrum function to generate these basis
% functions - make sure it's on the path
if ~exist('ssfp_spectrum.m','file')
    addpath(sprintf('%s/mri-ssfp-matlab/lib',ROOT));
    fprintf('mri-ssfp-matlab/lib added to path!\n');
end

% Generate simulated basis
[ sim_basis,R_sim,E_sim, M ] = get_sim_basis(alpha,TEs,dphis,T1,T2,fMax,Ns);
sim_basis = sim_basis(:,E_sim);

%% Filter Approximations
% Approximate the function we wanted
f_sim = get_filter_fun(filter_fun, Ns, filter_shift);

% Find the coefficients of the approximation
f_sim_approx_coeff = sim_basis\f_sim;

% Ploting: Compare the ideal to the approximation made with the simulated basis
figure;
plot(1:Ns,f_sim,1:Ns,abs(sim_basis*f_sim_approx_coeff)); grid on;
xlim([ 1 Ns ]);
title(sprintf('%s function - simulated basis approximation',filter_fun));
legend('Ideal','Simulated');

figure;
for ii = 1:7
    subplot(3,3,ii);
    plot(abs(sim_basis(:,ii)));
end

figure;
for ii = 1:6
    subplot(2,3,ii);
    plot(abs(M(:,ii)));
end

end


