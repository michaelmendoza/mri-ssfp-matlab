addpath('./lib');
addpath('./loader');

% Experiment - Whole Body

% Load Data
if 0
    basepath = '/Users/michael/Downloads/';
    dirname = {'10182017_WholeBodyFat/Pilot2'};
    imgs = loadData(basepath, dirname);
end   

% Access imgs, and do dixon separation
n = 0;
n = n * 7 + 1;
slice = 3;
img1 = imgs{n}(:,:,1,slice);
img2 = imgs{n+1}(:,:,1,slice);
img3 = imgs{n+2}(:,:,1,slice);
[ water, fat ] = dixon( img1, img2, img3 );

% Plot water/fat images
figure(1);
subplot(1,2,1);
imshow(abs(water), []);
subplot(1,2,2);
imshow(abs(fat), []);


