

function [imData] = loader(is_raw_data, im_dir)

regex = 'meas*.*';
kspace_dir = 'kSpace';
ROOT = '../../../';

% Load libs
if ~exist('ssfp_spectrum.m','file')
    addpath(sprintf('%s/mri-ssfp-matlab/lib',ROOT));
    fprintf('mri-ssfp-matlab/lib added to path!\n');
end

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
    imData = zeros(size(kSpace{1}.kspace,1), size(kSpace{1}.kspace,2),  size(kSpace{1}.kspace,4));
else
    imData = zeros(size(kSpace{1},1),size(kSpace{1},2), size(kSpace{1},4), numel(kSpace));
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
    imData(:,:,:,ii) = avg;
end
fprintf('Done transforming k-space data to image space!\n');

end


