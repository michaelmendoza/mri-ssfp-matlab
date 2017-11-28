%% Generate an offcenter pulse to the right
function [ v ] = offcenter_pulse(len)
    v = zeros(len,1);
    v(floor(2*len/3):end-floor(len/10)) = 1;
end