
clear; close all;

debug = true;

if ~exist('ssfp_spectrum.m','file')
    addpath(sprintf('%s/mri-ssfp-matlab/lib',ROOT));
    fprintf('mri-ssfp-matlab/lib added to path!\n');
end

% Params
alpha = .5*pi;
TEs = [ 3 6 12 ]*1e-3; %ms
dphis = [ 0 pi ]; % radians
T1 = 270e-3; % ms
T2 = 85e-3; % ms
fMax = 165;
Ns = 100; % size(imData,1); 

M = get_sim_SSFP(alpha, TEs, dphis, T1, T2, fMax, Ns, debug);
[basis, fcoeff] = get_basis_coeff(M);

figure;
plot(abs(basis * fcoeff));


