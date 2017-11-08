
clear(); clf; close all;
addpath('./lib');
load('/Users/michael/Projects/mri-ssfp-matlab/loader/ssfp_phantom_lama2.mat')
load('/Users/michael/Projects/mri-ssfp-matlab/loader/GSfieldmap_phantom_LAMA2.mat')

im = im / max(max(max(abs(im)))); 

figure(1);
subplot(141);
imshow(abs(im(:,:,1)), []);
subplot(142);
imshow(abs(im(:,:,2)), []);
subplot(143);
imshow(abs(im(:,:,3)), []);
subplot(144);
imshow(abs(im(:,:,4)), []);

wp = [250, 49];
fp = [250, 120];
K = 360;
points = zeros(4, K);
for k = 1:K
   betaOffset = k * 2 * pi / K;
   wIm = squeeze(im(wp(1), wp(2), :));
   fIm = squeeze(im(fp(1), fp(2), :));
   wGSFM = GSFM(wp(1), wp(2));
   fGSFM = GSFM(fp(1), fp(2));
      
   [points(1,k), points(2,k)] = lama(wIm(1), wIm(2), wIm(3), wIm(4), wGSFM, betaOffset);
   [points(3,k), points(4,k)] = lama(fIm(1), fIm(2), fIm(3), fIm(4), fGSFM, betaOffset);
end 

figure(2);
subplot(411);
plot(abs(points(1,:)));
subplot(412);
plot(abs(points(2,:)));
subplot(413);
plot(abs(points(3,:)));
subplot(414);
plot(abs(points(4,:)));

figure(3);
subplot(211);
plot(abs(points(1,:)));
subplot(212);
plot(abs(points(4,:)));

betaOffset = 100 * 2 * pi / K;
[water, fat] = lama(im(:,:,1), im(:,:,2), im(:,:,3), im(:,:,4), GSFM, betaOffset);

figure(4);
subplot(121);
imshow(abs(water), []);
subplot(122);
imshow(abs(fat), []);

% K = 20;
% for k = 1:K
%   betaOffset = k * 2 * pi / K
%   [water, fat] = lama(im(:,:,1), im(:,:,2), im(:,:,3), im(:,:,4), GSFM, betaOffset);
% 
%   figure(1);
%   subplot(121);
%   imshow(abs(water), []);
%   subplot(122);
%   imshow(abs(fat), []);
%   pause(0.5);
% end
