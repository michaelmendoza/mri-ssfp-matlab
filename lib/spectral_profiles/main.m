
% close all;
clear;

% Flags
is_raw_data = false; 

% Params
alpha = .5*pi;
TEs = [ 3 6 12 ]*1e-3; %ms
dphis = [ 0 pi ]; % radians
T1 = 270e-3; % ms
T2 = 85e-3; % ms
fMax = 165;
shift = 0.2;
filter_index = 4;

% Data location
%im_dir = 'data/12152017_SSFP_Spectral_Profile_ShortTR';
im_dir = 'data/1212017_SSFP_Spectral_Profile_Phantom_Set1';
%im_dir = 'data/1212017_SSFP_Spectral_Profile_Phantom_Set2';
%im_dir = 'data/1212017_SSFP_Spectral_Profile_Phantom_Set3';
%im_dir = 'data/11072017_SSFP_Fourier_Basis_Good_SNR_Set1';
%im_dir = 'data/11072017_SSFP_Fourier_Basis_Good_SNR_Set2';
%im_dir = 'data/11072017_SSFP_Fourier_Basis_Good_SNR_Set3';
%im_dir = 'data/11072017_SSFP_Fourier_Basis_WaterFat_Phantom';

% Desired Spectra Filters
filters = ["pass", "square", "square_offset", "square_wide", "notch", "notch_offset", "notch_offset_2", "guassian_notch"];

imData = loader(is_raw_data, im_dir);

data = squeeze(imData(:,:,1,:));
analyze_sim(data, alpha, TEs, dphis, T1, T2, fMax, filters(filter_index), shift);

im_results = [];
for ii = 1:4 
    data = squeeze(imData(:,:,ii,:));
    im_sim = analyze_data(data, alpha, TEs, dphis, T1, T2, fMax, filters(filter_index), shift);
    im_results = cat(3, im_results, im_sim);
end

im_results = squeeze(rssq(im_results,3));
plot_data(im_results);

figure;
for ii = 1:6
   im =  squeeze(rssq(imData(384:640,:,:,ii),3));
   subplot(2,3,ii);
   imshow(im', []);
end

figure;
for ii = 1:6
   im =  squeeze(rssq(imData(384:640,:,:,ii),3));
   subplot(2,3,ii);
   plot(mean(im(:, 118:138), 2));
end



