
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
[ sim_basis,R_sim,E_sim ] = get_sim_basis(alpha,TEs,dphis,T1,T2,fMax,Ns);
sim_basis = sim_basis(:,E_sim);
R_sim = R_sim(E_sim,E_sim);

%% Filter Approximations
% Approximate the function we wanted
f_sim = get_filter_fun(filter_fun, Ns, filter_shift);

% Find the coefficients of the approximation
f_sim_approx_coeff = sim_basis\f_sim;

%% Apply filter to image

% Add bias
av = mean(mean(mean(imData, 1),2),3);
bias = av * ones(size(imData(:,:,1)));
imData = cat(3, bias, imData);

imData_sim = zeros(size(imData));
for ii = 1:size(R_sim,1)
    for jj = 1:size(R_sim,2)
        imData_sim(:,:,ii) = imData_sim(:,:,ii) + imData(:,:,ii) * R_sim(jj,ii);
    end 
end

im_sim = zeros(size(imData,1),size(imData,2));
for ii = 1:size(imData,3)
    im_sim = im_sim + (f_sim_approx_coeff(ii)*imData_sim(:,:,ii));
end

end


