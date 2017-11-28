%% Load in all images
function ims = load_mats(mat_path)
    % Find all mat files in the directory
    mats = dir(sprintf('%s/meas*.mat',mat_path));
    
    for k = 1:length(mats)
        kspace = load(sprintf('%s/%s',mat_path,mats(k).name));
        im = ifftshift(ifft2(kspace.kSpace));
        % Average, use first coil
        avg = squeeze(sum(im,3))/size(im,3);
        ims(:,:,k) = avg(:,:,1);
    end
end