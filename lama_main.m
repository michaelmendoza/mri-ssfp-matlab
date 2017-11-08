
clear();
addpath('./lib');
load('/Users/michael/Projects/mri-ssfp-matlab/loader/ssfp_phantom_lama2.mat')
load('/Users/michael/Projects/mri-ssfp-matlab/loader/GSfieldmap_phantom_LAMA2.mat')

K = 20;
for k = 1:K
  betaOffset = k * 2 * pi / K
  [water, fat] = lama(im(:,:,1), im(:,:,2), im(:,:,3), im(:,:,4), GSFM, betaOffset);

  figure(1);
  subplot(121);
  imshow(abs(water), []);
  subplot(122);
  imshow(abs(fat), []);
  pause(0.5);
end
