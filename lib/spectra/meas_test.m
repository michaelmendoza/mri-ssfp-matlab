clear;
close all;

%% Load
% Give the location of the MAT files you want to use
ims = load_mats('/home/ecestudent/Documents/Fourier Basis Lard/copper');

%% Select the patch we want to work with
[ idx, idy ] = select_patch(ims);
patches = zeros(length(idy),length(idx),size(ims,5));
for k = 1:size(ims,3)
    patches(:,:,k) = ims(idy,idx,k);
end

%% Make Basis, find coefficients
% Select the line down the center of the patch
% I can only get this to work with absolute values...
% REALLY smoothing (sigma = 5) seems to help, but I think that's not the
% point, because then you end up with random data...
slices = abs(squeeze(patches(:,floor(size(patches,2)/2),:)));

Q = make_basis(slices);
h = disp_basis(Q,'Measured Basis');

% Desired test functions
cp = center_pulse(size(Q,1));
ocp = offcenter_pulse(size(Q,1));

% Grab the coefficients
c = Q\cp;
c2 = Q\ocp;

%% Show me the results
compare_plot(cp,abs(Q*c),'Measured, Centered Pulse');
compare_plot(ocp,abs(Q*c2),'Measured, Offcenter Pulse');
