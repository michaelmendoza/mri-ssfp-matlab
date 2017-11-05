

basepath = '/Volumes/PNY SSD/MRI Data/10282017_SSPF Smoothing DL/';
filename = 'meas_MID885_trufi_phi0_FID4833.dat';
filepath = strcat(basepath, filename);

img = readMeasDataVB15(filepath);