
basepath = '../../data/';
dirname = {'11082017_SSFP_LAMA _WATEROIL'};

imgs = loadData(basepath, dirname);
s = size(imgs{1});
im = zeros(s(1),s(2),4);
for n=1:4
  temp = imgs{n};
  temp = mean(temp, 3);
  temp = mean(temp, 4);
  im(:,:,n) = temp;
end

save('ssfp_phantom_lama2.mat', 'im');