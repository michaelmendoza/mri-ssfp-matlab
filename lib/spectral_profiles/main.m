% close all;

% Flags
is_raw_data = false;

% Params
alpha = .5*pi;
TEs = [ 3 6 12 ]*1e-3; %ms
dphis = [ 0 pi ]; % radians
T1 = 270e-3; % ms
T2 = 85e-3; % ms
fMax = 165;
im_dir = 'data/SSFP Spectral Profile ShortTR 12152017';
regex = 'meas*.*';
kspace_dir = 'kSpace';
ROOT = '../../../';
meas_smoothing_span = 40;

% Choose the filter
%     pass
%     square
%     square_offset
%     notch
%     notch_offset
%     guassian_notch
% filter_fun = 'pass';
% filter_fun = 'square';
% filter_fun = 'square_offset';
% filter_fun = 'notch';
filter_fun = 'notch_offset';

if is_raw_data
    
    % Check to make sure we have the right directory
    if not(exist(im_dir,'dir'))
        fprintf('Directory "%s" does not exist!\n',im_dir);
    else
        fprintf('Data was found in directory %s...\n',im_dir);
    end
    
    % Convert raw data to kSpace data if needed
    fprintf('Converting raw data to kSpace...\n');

    % Make sure we have readMeasData available
    if not(exist('readMeasDataVB15.m','file'))
        addpath(sprintf('%s/mri-ssfp-matlab/loader/',ROOT));
        fprintf('Added mri-ssfp-matlab/loader/ to the path!\n');
    end

    % Make sure we have a directory to throw the kSpace.mat files into
    % so we don't have to do this all over again
    if not(exist(sprintf('%s/%s',im_dir,kspace_dir),'dir'))
        mkdir(im_dir,kspace_dir);
        fprintf('Made the directory: %s/%s!\n',im_dir,kspace_dir);
    end

    % Grab all the files matching the regex from the directory
    files = dir(sprintf('%s/%s',im_dir,regex));
    kSpace = cell(numel(files),1);
    for ii = 1:numel(files)
        % Load and save each of them
        kspace = readMeasDataVB15(sprintf('%s/%s',files(ii).folder,files(ii).name));
        save(sprintf('%s/%s/%s.mat',im_dir,kspace_dir,files(ii).name),'kspace');
        kSpace{ii} = kspace;
    end

    fprintf('Done converting raw data to kSpace!\n');
end

% Load in .mat files if they aren't already in the workspace
if not(exist('kSpace','var')) && ~is_raw_data
    fprintf('Reloading images...\n');

    % Find the files
    files = dir(sprintf('%s/%s/%s',im_dir,kspace_dir,regex));

    % Load in all the kspace .mat files and store them in kSpace cell array
    kSpace = cell(numel(files),1);
    for ii = 1:numel(files)
        kSpace{ii} = load(sprintf('%s/%s/%s',im_dir,kspace_dir,files(ii).name));
    end

    fprintf('Done reloading images!\n');
end

% Convert the k-space data to image space data
fprintf('Transforming k-space data to image space...\n');
if isstruct(kSpace{1})
    imData = zeros(size(kSpace{1}.kspace,1),size(kSpace{1}.kspace,2));
else
    imData = zeros(size(kSpace{1},1),size(kSpace{1},2),numel(kSpace));
end
for ii = 1:numel(kSpace)
    if isstruct(kSpace{ii})
        imCoil = ifftshift(ifft2(kSpace{ii}.kspace));
    else
        imCoil = ifftshift(ifft2(kSpace{ii}));
    end
    
    % Average over all the averages, use only one coil
    num_avgs = size(imCoil,3);
    avg = squeeze(sum(imCoil,3))/num_avgs;
    %imData(:,:,ii) = rssq(avg,3);
    %imData(:,:,ii) = sum(avg,3);
    imData(:,:,ii) = avg(:,:,1);
end
fprintf('Done transforming k-space data to image space!\n');

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

% Generate the measured basis
[ meas_basis,Ms,R_meas,E_meas ] = get_meas_basis(imData,meas_smoothing_span);
meas_basis = meas_basis(:,E_meas);
R_meas = R_meas(E_meas,E_meas);

%% Filter Approximations
% Approximate the function we wanted
f_sim = get_filter_fun(filter_fun,Ns);
f_meas = get_filter_fun(filter_fun,Ms);

% Find the coefficients of the approximation
f_sim_approx_coeff = sim_basis\f_sim;
f_meas_approx_coeff = meas_basis\f_meas;

% Compare the ideal to the approximation made with the simulated basis
figure;
subplot(2,1,1);
plot(1:Ns,f_sim,1:Ns,abs(sim_basis*f_sim_approx_coeff)); grid on;
xlim([ 1 Ns ]);
title(sprintf('%s function - simulated basis approximation',filter_fun));
legend('Ideal','Simulated');

subplot(2,1,2);
plot(1:Ms,f_meas,1:Ms,abs(meas_basis*f_meas_approx_coeff)); grid on;
xlim([ 1 Ms ]);
title(sprintf('%s function - measured basis approximation',filter_fun));
legend('Ideal','Meas. Approximation');

%% Apply filter to image
% 
% for jj = 1:size(imData,2)
%     tmp = squeeze(imData(:,jj,:));
%     imData_sim(:,jj,:) = tmp*R_sim(2:end,2:end);
%     imData_meas(:,jj,:) = tmp*R_meas(2:end,2:end);
% end

if size(imData,3) < size(R_sim,1)
    imData(:,:,7) = zeros(size(imData(:,:,1)));
    imData = imData(:,:,[ size(R_sim,1) 1:(size(R_sim,1)-1) ]);
end

imData_sim = zeros(size(imData));
imData_meas = zeros(size(imData));
for ii = 1:size(R_sim,1)
    for jj = 1:size(R_sim,2)
        imData_sim(:,:,ii) = imData_sim(:,:,ii) + imData(:,:,ii)*R_sim(ii,jj);
        imData_meas(:,:,ii) = imData_meas(:,:,ii) + imData(:,:,ii)*R_sim(ii,jj); % This should be using R_meas - not sure why it doesn't work
    end
end

im_sim = zeros(size(imData,1),size(imData,2));
im_meas = zeros(size(imData,1),size(imData,2));
for ii = 1:size(imData,3)
    im_sim = im_sim + (f_sim_approx_coeff(ii)*imData_sim(:,:,ii));
    im_meas = im_meas + (f_meas_approx_coeff(ii)*imData_meas(:,:,ii));
end

im_cntrl = rssq(imData,3);

figure;
subplot(3,3,1);
imshow(abs(im_sim).',[ 0 max(max(max(abs(im_sim))))*1.2 ]);
title('Simulated Filtered');

subplot(3,3,2);
imshow(abs(im_meas).',[ 0 max(max(max(abs(im_meas))))*1.2 ]);
title('Measured Filtered');

subplot(3,3,3);
imshow(im_cntrl.',[ 0 max(max(max(im_cntrl)))*1.2 ]);
title('Root Sum of Squares');

subplot(3,3,4);
plot(abs(sim_basis*f_sim_approx_coeff));
xlim([ 1 Ns ]);
title('Simulated Function Approximation');

subplot(3,3,5);
plot(abs(meas_basis*f_meas_approx_coeff));
xlim([ 1 Ms ]);
title('Measured Function Approximation');

subplot(3,3,7);
plot(abs(im_sim(:,floor(end/2))));
xlim([ 1 Ns ]);
title('Slice through center (Sim.)');

subplot(3,3,8);
plot(abs(im_meas(:,floor(end/2))));
xlim([ 1 Ns ]);
title('Slice through center (Meas.)');

subplot(3,3,9);
plot(im_cntrl(:,floor(end/2)));
xlim([ 1 Ns ]);
title('Slice through center (RMSquare)');